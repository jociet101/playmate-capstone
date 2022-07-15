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
#import "EditProfileViewController.h"
#import "PlayerConnection.h"
#import "FriendsListViewController.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UILabel *profileImagePlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *numberOfFriendsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsMenuButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    PFUser *user = [PFUser currentUser];
    self.nameLabel.text = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.usernameLabel.textColor = [UIColor lightGrayColor];
    self.genderLabel.text = [@"Identifies as " stringByAppendingString:user[@"gender"][0]];
    self.ageLabel.text = [[Constants getAgeInYears:user[@"birthday"][0]] stringByAppendingString:@" years old"];
    
    if ([user objectForKey:@"biography"] != nil) {
        self.bioField.text = user[@"biography"][0];
    }
    if (user[@"profileImage"] != nil) {
        // set image stuff
        UIImage* img = [UIImage imageWithData:[user[@"profileImage"] getData]];
        [self.profileImageView setImage:img];
        self.profileImagePlaceholder.alpha = 0;
    }
    
    PlayerConnection *myPc = user[@"playerConnection"][0];
    [myPc fetchIfNeeded];
    
    unsigned long numFriends = ((NSArray *)myPc[@"friendsList"]).count;
    
    // TODO: find out how to make font bold, look like a button
//    [self.numberOfFriendsButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:16.0]];
    
    [self.numberOfFriendsButton setTitle:[NSString stringWithFormat:@"%ld friends", numFriends] forState:UIControlStateNormal];
    
    [self configureSettingsMenu];
}

- (void)configureSettingsMenu {
    
    // create uiactions for menu dropdown
    UIAction *editProfile = [UIAction actionWithTitle:@"Edit Profile" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [self didTapEdit];
    }];
    UIAction *logout = [UIAction actionWithTitle:@"Logout" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [self didTapLogout];
    }];
    
    UIMenu *menu = [UIMenu menuWithTitle:@"Options" children:[NSArray arrayWithObjects:editProfile, logout, nil]];
    
    // set menu dropdown
    self.settingsMenuButton.menu = menu;
    self.settingsMenuButton.showsMenuAsPrimaryAction = YES;
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
        if (succeeded) {
            NSLog(@"Profile image saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handling button or gesture actions

- (void)didTapLogout {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        myDelegate.window.rootViewController = welcomeViewController;
    }];
}

- (void)didTapEdit {
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
