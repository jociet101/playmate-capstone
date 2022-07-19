//
//  PlayerProfileViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerProfileViewController.h"
#import "Constants.h"
#import "Helpers.h"
#import "FriendRequest.h"
#import "PlayerConnection.h"
#import "FriendsListViewController.h"

@interface PlayerProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *numberOfFriendsButton;

@property (nonatomic, assign) BOOL isMyFriend;

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
    
    const BOOL hasProfileImage = (self.user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[self.user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:img];
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:self.user];
    
    unsigned long numFriends = ((NSArray *)playerConnection[@"friendsList"]).count;
    
    [self.numberOfFriendsButton setTitle:[NSString stringWithFormat:@"%ld friends", numFriends] forState:UIControlStateNormal];
}

-(void)manageFriendButtonUI {
    self.addFriendButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    // if this profile belongs to current user, disable the button
    if ([me[@"username"] isEqualToString:self.user.username]) {
        self.isMyFriend = NO;
        [self disableFriendButton];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:me.objectId];
    PlayerConnection *playerConnection = [[query getFirstObject] fetchIfNeeded];
    
    if (playerConnection != nil) {
        // if current user is friends w this person, set title "Remove Friend"
        if ([playerConnection.friendsList containsObject:self.user.objectId]) {
            self.isMyFriend = YES;
            [self.addFriendButton setTitle:@"Remove Friend" forState:UIControlStateNormal];
        }
        // if current user sent unseen request to this person, set as "Request Pending"
        else if ([playerConnection.pendingList containsObject:self.user.objectId]) {
            self.isMyFriend = NO;
            [self setRequestPendingAsState];
        }
    }
    
    [query whereKey:@"userObjectId" equalTo:self.user.objectId];
    playerConnection = [[query getFirstObject] fetchIfNeeded];
    
    // if current user has request from this person, set as "Sent you a request"
    if (playerConnection != nil && [playerConnection.pendingList containsObject:me.objectId]) {
        self.isMyFriend = NO;
        [self setSendRequestToYouAsState];
    }
}

- (void)disableFriendButton {
    [self.addFriendButton setTitle:@"You" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor whiteColor];
}

- (void)setSendRequestToYouAsState {
    [self.addFriendButton setTitle:@"Sent You Request" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor whiteColor];
}

- (void)setRequestPendingAsState {
    [self.addFriendButton setTitle:@"Request Pending" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)resetAddFriendButton {
    [self.addFriendButton setTitle:@"Add Friend" forState:UIControlStateNormal];
}

- (IBAction)didTapFriend:(id)sender {
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    if (self.isMyFriend) {
        // if removing friend
        // remove self.user.objectId from my friends list
        PlayerConnection *myPlayerConnection = [Helpers getPlayerConnectionForUser:user];
        
        NSMutableArray *tempFriendsList = (NSMutableArray *)myPlayerConnection.friendsList;
        [tempFriendsList removeObject:self.user.objectId];
        myPlayerConnection.friendsList = (NSArray *)tempFriendsList;
        
        [myPlayerConnection saveInBackground];
        
        // remove user.objectId from self.user.playerconnect friends list
        PlayerConnection *theirPlayerConnection = [Helpers getPlayerConnectionForUser:self.user];
        
        tempFriendsList = (NSMutableArray *)theirPlayerConnection[@"friendsList"];
        [tempFriendsList removeObject:user.objectId];
        theirPlayerConnection[@"friendsList"] = (NSArray *)tempFriendsList;
        
        [theirPlayerConnection saveInBackground];
        
        [self resetAddFriendButton];
        self.isMyFriend = NO;
    } else {
        // if add friend
        // Create FriendRequest from me to other
        [FriendRequest saveFriendRequestTo:self.user.objectId];
        PlayerConnection *playerConnection;
        
        if ([user objectForKey:@"playerConnection"] == nil) {
            playerConnection = [PlayerConnection initializePlayerConnection];
            
            NSMutableArray *tempPendingList = (NSMutableArray *)playerConnection.pendingList;
            [tempPendingList addObject:self.user.objectId];
            playerConnection.pendingList = (NSArray *)tempPendingList;
        } else {
            playerConnection = [Helpers getPlayerConnectionForUser:user];
            
            NSMutableArray *tempPendingList = (NSMutableArray *)playerConnection[@"pendingList"];
            [tempPendingList addObject:self.user.objectId];
            playerConnection[@"pendingList"] = (NSArray *)tempPendingList;
        }
        
        // Add pending friend connection from me to other
        [playerConnection saveInBackground];
        
        [user addObject:playerConnection forKey:@"playerConnection"];
        
        [user saveInBackground];
        
        [self setRequestPendingAsState];
        
        self.isMyFriend = YES;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toFriendsList"]) {
        FriendsListViewController *vc = [segue destinationViewController];
        vc.thisUser = self.user;
    }
}

@end
