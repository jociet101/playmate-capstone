//
//  OutgoingRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "OutgoingRequestCell.h"
#import "Constants.h"
#import "PlayerConnection.h"
#import "FriendRequest.h"
#import "Helpers.h"

@interface OutgoingRequestCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation OutgoingRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserObjectId:(NSString *)userObjectId {
    _userObjectId = userObjectId;
    
    PFQuery *query = [PFUser query];
    PFUser *user = [[query getObjectWithId:userObjectId] fetchIfNeeded];
    
    NSString *name = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.titleLabel.text = [@"You requested to be friends with " stringByAppendingString:name];
    
    [Helpers setCornerRadiusAndColorForButton:self.cancelButton andIsSmall:YES];
    
    const BOOL hasProfileImage = (user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:83]];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
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
