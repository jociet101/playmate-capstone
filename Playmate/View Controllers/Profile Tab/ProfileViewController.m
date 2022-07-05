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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;

@end

NSString *defaultBio = @"Enter a bio.";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.nameLabel.text = [user[@"firstName"][0] stringByAppendingString:[@" " stringByAppendingString:user[@"lastName"][0]]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.usernameLabel.textColor = [UIColor lightGrayColor];
    self.genderLabel.text = user[@"gender"][0];
    self.ageLabel.text = [@"Born " stringByAppendingString:[user[@"birthday"][0] timeAgoSinceNow]];
    
    if (![self.bioField.text isEqualToString:defaultBio]) {
        self.bioField.text = user[@"bio"][0];
    }
    if (user[@"profileImage"] != nil) {
        // set image stuff
    }
    
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeVC"];
        
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        myDelegate.window.rootViewController = welcomeViewController;
    }];
}

- (IBAction)didTapEdit:(id)sender {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
