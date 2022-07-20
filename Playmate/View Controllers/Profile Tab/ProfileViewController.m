//
//  ProfileViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "ProfileViewController.h"
#import "WelcomeViewController.h"
#import "SceneDelegate.h"
#import "DateTools.h"
#import "Constants.h"
#import "Helpers.h"
#import "EditProfileViewController.h"
#import "PlayerConnection.h"
#import "FriendsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ManageUserStatistics.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UILabel *profileImagePlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *numberOfFriendsButton;
@property (weak, nonatomic) IBOutlet UILabel *numberTotalSessionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberDaysOnPlaymateLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstSportLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSportLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdSportLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    self.nameLabel.text = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.usernameLabel.textColor = [UIColor lightGrayColor];
    self.genderLabel.text = [@"Identifies as " stringByAppendingString:user[@"gender"][0]];
    self.ageLabel.text = [[Constants getAgeInYears:user[@"birthday"][0]] stringByAppendingString:@" years old"];
    
    const BOOL hasBiography = ([user objectForKey:@"biography"] != nil);
    self.bioField.text = hasBiography ? [user objectForKey:@"biography"][0] : @"No biography";
        
    if (user[@"profileImage"] != nil) {
        // set image stuff
        UIImage* img = [UIImage imageWithData:[user[@"profileImage"] getData]];
        [self.profileImageView setImage:img];
        self.profileImagePlaceholder.alpha = 0;
    }
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:user];
    unsigned long numFriends = ((NSArray *)playerConnection[@"friendsList"]).count;
    [self.numberOfFriendsButton setTitle:[NSString stringWithFormat:@"%ld friends", numFriends] forState:UIControlStateNormal];
    
    // TODO: find out how to make font bold, look like a button
//    [self.numberOfFriendsButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:16.0]];
    
    [self configureDataFields];
    [self configureButtonUI];
}

- (void)configureDataFields {
    self.numberTotalSessionsLabel.layer.borderColor = [[Constants playmateBlue] CGColor];
    self.numberDaysOnPlaymateLabel.layer.borderColor = [[Constants playmateBlue] CGColor];
    self.numberTotalSessionsLabel.layer.borderWidth = 1.0;
    self.numberDaysOnPlaymateLabel.layer.borderWidth = 1.0;
    self.numberTotalSessionsLabel.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.numberDaysOnPlaymateLabel.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    self.firstSportLabel.backgroundColor = [Constants playmateBlue];
    self.secondSportLabel.backgroundColor = [Constants playmateBlue];
    self.thirdSportLabel.backgroundColor = [Constants playmateBlue];
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    self.numberTotalSessionsLabel.text = [[NSString stringWithFormat:@"%ld", [ManageUserStatistics getNumberTotalSessionsForUser:me]] stringByAppendingString:@" Total Sessions"];
    self.numberDaysOnPlaymateLabel.text = [[NSString stringWithFormat:@"%@", [ManageUserStatistics getNumberDaysOnPlaymateForUser:me]] stringByAppendingString:@" Days on Playmate"];
}

- (void)configureButtonUI {
    self.editProfileButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.logoutButton.layer.borderColor = [[UIColor systemRedColor] CGColor];
    self.editProfileButton.layer.borderWidth = 0.2;
    self.logoutButton.layer.borderWidth = 0.2;
    
    self.editProfileButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.logoutButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    [self.logoutButton setTintColor:[UIColor systemRedColor]];
}

#pragma mark - Uploading or taking profile image

- (void)initializeTaker {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = (id)self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    [self.profileImageView setImage:editedImage];
    self.profileImagePlaceholder.alpha = 0;
    
    // save profile image
    NSData* data = UIImagePNGRepresentation(editedImage);
    PFFileObject *file = [PFFileObject fileObjectWithData:data];
    
    PFUser *user = [PFUser currentUser];
    user[@"profileImage"] = file;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            [Helpers handleAlert:error withTitle:@"Could not save profile image." withMessage:nil forViewController:self];
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handling button or gesture actions

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        myDelegate.window.rootViewController = welcomeViewController;
    }];
}

- (IBAction)didTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"toEditProfile" sender:nil];
}

- (IBAction)uploadProfileImage:(id)sender {
    [self initializeTaker];
}

- (IBAction)viewFriendRequests:(id)sender {
    [self performSegueWithIdentifier:@"viewFriendRequests" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toFriendsList"]) {
        FriendsListViewController *vc = [segue destinationViewController];
        vc.thisUser = [PFUser currentUser];
    }
}

@end
