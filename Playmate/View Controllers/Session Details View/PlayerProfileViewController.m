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
    self.usernameLabel.text = [@"@" stringByAppendingString:self.user.username];
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
    
    PFUser *me = [PFUser currentUser];
    [me fetchIfNeeded];
    
    // if this profile belongs to current user, disable the button
    if ([me[@"username"] isEqualToString:self.user.username]) {
        [self disableFriendButton];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:me.objectId];
    PlayerConnection *pc = [query getFirstObject];
    [pc fetchIfNeeded];
    
    // if current user is friends w this person, set title "Remove Friend"
    if (pc != nil) {
        NSLog(@"pc not nil, pending list %@", pc.pendingList);
        if ([pc.friendsList containsObject:self.user.objectId]) {
            [self.addFriendButton setTitle:@"Remove Friend" forState:UIControlStateNormal];
        } else if ([pc.pendingList containsObject:self.user.objectId]) {
            [self setRequestPendingAsState];
        }
    }
}

- (void)disableFriendButton {
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.alpha = 0;
}

- (void)setRequestPendingAsState {
    [self.addFriendButton setTitle:@"Request Pending" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)didTapFriend:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    // if add friend
    
    // Create FriendRequest from me to other
    [FriendRequest saveFriendRequestTo:self.user.objectId];
    PlayerConnection *pc;
    
    if ([user objectForKey:@"playerConnection"] == nil) {
        pc = [PlayerConnection initializePlayerConnection];
    } else {
        pc = user[@"playerConnection"];
        [user removeObjectForKey:@"playerConnection"];
    }
    
    // Add pending friend connection from me to other
    
    NSMutableArray *tempPendingList = (NSMutableArray *)pc[@"pendingList"];
    [tempPendingList addObject:self.user.objectId];
    pc[@"pendingList"] = (NSArray *)tempPendingList;
    
    [pc saveInBackground];
    
    [user addObject:pc forKey:@"playerConnection"];
    
    [user saveInBackground];
    
    [self setRequestPendingAsState];
    
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
