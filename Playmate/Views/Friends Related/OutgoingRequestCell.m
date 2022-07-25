//
//  OutgoingRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "OutgoingRequestCell.h"
#import "PlayerConnection.h"
#import "FriendRequest.h"
#import "Constants.h"
#import "Helpers.h"

@interface OutgoingRequestCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation OutgoingRequestCell

- (void)setUserObjectId:(NSString *)userObjectId {
    _userObjectId = userObjectId;
    
    PFQuery *query = [PFUser query];
    PFUser *user = [[query getObjectWithId:userObjectId] fetchIfNeeded];
    self.titleLabel.text = [Helpers outgoingRequestMessageFor:user];
    
    [Helpers setCornerRadiusAndColorForButton:self.cancelButton andIsSmall:YES];
    
    const BOOL hasProfileImage = (user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:83]];
    [Helpers roundCornersOfImage:self.profileImageView];
}

- (IBAction)cancelOutgoingRequest:(id)sender {
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    // remove user from my pending list
    PlayerConnection *connection = user[@"playerConnection"][0];
    
    NSMutableArray *tempPendingList = (NSMutableArray *)connection[@"pendingList"];
    [tempPendingList removeObject:self.userObjectId];
    connection[@"pendingList"] = (NSArray *)tempPendingList;
    
    [connection saveInBackground];
    
    // delete the friend request object
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"requestFromId" equalTo:user.objectId];
    [query whereKey:@"requestToId" equalTo:self.userObjectId];
    
    FriendRequest *request = [query getFirstObject];
    [request deleteInBackground];
    
    [self.delegate didCancelRequest];
}

@end
