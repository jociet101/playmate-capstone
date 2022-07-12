//
//  PlayerProfileViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerProfileViewController.h"
#import "Constants.h"
#import "FriendRequest.h"
#import "PlayerConnection.h"

@interface PlayerProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end

@implementation PlayerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self manageFriendButtonUI];
    
    self.nameLabel.text = [Constants concatenateFirstName:self.user[@"firstName"][0] andLast:self.user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:self.user[@"username"]];
    self.usernameLabel.textColor = [UIColor lightGrayColor];
    self.genderLabel.text = [@"Identifies as " stringByAppendingString:self.user[@"gender"][0]];
    self.ageLabel.text = [[Constants getAgeInYears:self.user[@"birthday"][0]] stringByAppendingString:@" years old"];
    
    if ([self.user objectForKey:@"biography"] != nil) {
        self.bioField.text = self.user[@"biography"][0];
    }
    else {
        self.bioField.text = @"No biography";
    }
    
    if (self.user[@"profileImage"] != nil) {
        // set image stuff
        UIImage* img = [UIImage imageWithData:[self.user[@"profileImage"] getData]];
        [self.profileImageView setImage:img];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:img];
    }
    
}

-(void)manageFriendButtonUI {
    self.addFriendButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    // if this profile belongs to current user, disable the button
    // if current user is friends w this person, set title "Remove Friend"
}

- (IBAction)didTapFriend:(id)sender {
    
    // if add friend
    [FriendRequest saveFriendRequest:self.user.objectId from:[PFUser currentUser]];
//    [PlayerConnection ]
    
    // TODO: if remove friend
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
