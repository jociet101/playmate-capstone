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
    
    if (self.user[@"profileImage"] != nil) {
        // set image stuff
        UIImage* img = [UIImage imageWithData:[self.user[@"profileImage"] getData]];
        [self.profileImageView setImage:img];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:img];
    }
    
    PlayerConnection *thisPc = self.user[@"playerConnection"];
    [thisPc fetchIfNeeded];
    
    unsigned long numFriends = ((NSArray *)thisPc[@"friendList"]).count;
    
    [self.numberOfFriendsButton setTitle:[NSString stringWithFormat:@"%ld friends", numFriends] forState:UIControlStateNormal];
}

-(void)manageFriendButtonUI {
    self.addFriendButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    PFUser *me = [PFUser currentUser];
    [me fetchIfNeeded];
    
    // if this profile belongs to current user, disable the button
    if ([me[@"username"] isEqualToString:self.user.username]) {
        self.isMyFriend = NO;
        [self disableFriendButton];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:me.objectId];
    PlayerConnection *pc = [query getFirstObject];
    [pc fetchIfNeeded];
    
    if (pc != nil) {
        // if current user is friends w this person, set title "Remove Friend"
        if ([pc.friendsList containsObject:self.user.objectId]) {
            self.isMyFriend = YES;
            [self.addFriendButton setTitle:@"Remove Friend" forState:UIControlStateNormal];
        }
        // if current user sent unseen request to this person, set as "Request Pending"
        else if ([pc.pendingList containsObject:self.user.objectId]) {
            self.isMyFriend = NO;
            [self setRequestPendingAsState];
        }
    }
    
    [query whereKey:@"userObjectId" equalTo:self.user.objectId];
    pc = [query getFirstObject];
    [pc fetchIfNeeded];
    
    // if current user has request from this person, set as "Sent you a request"
    if (pc != nil && [pc.pendingList containsObject:me.objectId]) {
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
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    if (self.isMyFriend) {
        // if removing friend
        
        PFUser *me = [PFUser currentUser];
        [me fetchIfNeeded];
        
        // remove self.user.objectId from my friends list
        PlayerConnection *myPc = me[@"playerConnection"][0];
        [myPc fetchIfNeeded];
        
        NSMutableArray *tempFriendsList = (NSMutableArray *)myPc.friendsList;
        [tempFriendsList removeObject:self.user.objectId];
        myPc.friendsList = (NSArray *)tempFriendsList;
        
        [myPc saveInBackground];
        
        // remove me.objectId from self.user.pc friends list
        PlayerConnection *theirPc = self.user[@"playerConnection"][0];
        [theirPc fetchIfNeeded];
        
        tempFriendsList = (NSMutableArray *)theirPc[@"friendsList"];
        [tempFriendsList removeObject:me.objectId];
        theirPc[@"friendsList"] = (NSArray *)tempFriendsList;
        
        [theirPc saveInBackground];
        
        [self resetAddFriendButton];
                
        self.isMyFriend = NO;
    } else {
        // if add friend
        // Create FriendRequest from me to other
        [FriendRequest saveFriendRequestTo:self.user.objectId];
        PlayerConnection *pc;
        
        if ([user objectForKey:@"playerConnection"] == nil) {
            pc = [PlayerConnection initializePlayerConnection];
            
            NSMutableArray *tempPendingList = (NSMutableArray *)pc.pendingList;
            [tempPendingList addObject:self.user.objectId];
            pc.pendingList = (NSArray *)tempPendingList;
        } else {
            pc = user[@"playerConnection"][0];
            [pc fetchIfNeeded];
            
            NSMutableArray *tempPendingList = (NSMutableArray *)pc[@"pendingList"];
            [tempPendingList addObject:self.user.objectId];
            pc[@"pendingList"] = (NSArray *)tempPendingList;
        }
        
        // Add pending friend connection from me to other
        [pc saveInBackground];
        
        [user addObject:pc forKey:@"playerConnection"];
        
        [user saveInBackground];
        
        [self setRequestPendingAsState];
        
        self.isMyFriend = YES;
    }
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
