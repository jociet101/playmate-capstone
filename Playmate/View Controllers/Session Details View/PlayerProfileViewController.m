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
#import "ManageUserStatistics.h"

@interface PlayerProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *numberOfFriendsButton;
@property (weak, nonatomic) IBOutlet UILabel *numberTotalSessionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberDaysOnPlaymateLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstSportLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSportLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdSportLabel;

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
    
    const BOOL hasBiography = ([self.user objectForKey:@"biography"] != nil);
    self.bioField.text = hasBiography ? self.user[@"biography"][0] : @"No biography";
    
    const BOOL hasProfileImage = (self.user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[self.user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:img];
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:self.user];
    
    unsigned long numFriends = ((NSArray *)playerConnection[@"friendsList"]).count;
    NSString *numberFriendsLabel = (numFriends == 1) ? @"1 friend" : [NSString stringWithFormat:@"%ld friends", numFriends];
    [self.numberOfFriendsButton setTitle:numberFriendsLabel forState:UIControlStateNormal];
    
    [self configureDataFields];
}

-(void)manageFriendButtonUI {
    [Helpers setCornerRadiusAndColorForButton:self.addFriendButton andIsSmall:YES];
    
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
    
    self.numberTotalSessionsLabel.text = [[NSString stringWithFormat:@"%ld", [ManageUserStatistics getNumberTotalSessionsForUser:self.user]] stringByAppendingString:@" Total Sessions"];
    self.numberDaysOnPlaymateLabel.text = [[NSString stringWithFormat:@"%@", [ManageUserStatistics getNumberDaysOnPlaymateForUser:self.user]] stringByAppendingString:@" Days on Playmate"];
}

- (void)disableFriendButton {
    [self.addFriendButton setTitle:@"You" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor clearColor];
}

- (void)setSendRequestToYouAsState {
    [self.addFriendButton setTitle:@"Sent You Request" forState:UIControlStateNormal];
    [self.addFriendButton setEnabled:NO];
    self.addFriendButton.backgroundColor = [UIColor clearColor];
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
