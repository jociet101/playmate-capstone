//
//  FriendRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequestCell.h"
#import "Constants.h"
#import "PlayerConnection.h"
#import "DateTools.h"
#import "Helpers.h"

@interface FriendRequestCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;

@property (nonatomic, strong) PFUser *requester;

@end

@implementation FriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

- (void)didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate didTap:self profileImage:self.requester];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequestInfo:(FriendRequest *)requestInfo {
    
    _requestInfo = requestInfo;
    
    PFQuery *query = [PFUser query];
    self.requester = [query getObjectWithId:requestInfo.requestFromId];
            
    NSString *requesterName = [Constants concatenateFirstName:self.requester[@"firstName"][0] andLast:self.requester[@"lastName"][0]];
    self.titleLabel.text = [requesterName stringByAppendingString:@" wants to be friends."];
    self.acceptButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.denyButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    const BOOL hasProfileImage = (self.requester[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[self.requester[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:83]];
    
    // set time ago timestamp
    self.timeAgoLabel.text = [[requestInfo.updatedAt shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
}

- (void)deleteThisRequest {
    [self.requestInfo deleteInBackground];
}

- (IBAction)didTapAccept:(id)sender {
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    // add a connection from this person's side
    PlayerConnection *connection;
    
    if ([user objectForKey:@"playerConnection"] == nil) {
        connection = [PlayerConnection initializePlayerConnection];
        [user addObject:connection forKey:@"playerConnection"];
        [user saveInBackground];
    } else {
        connection = user[@"playerConnection"];
    }
    
    [PlayerConnection saveMyConnectionTo:self.requestInfo.requestFromId withStatus:YES andWeight:1];
    [PlayerConnection savePlayer:self.requestInfo.requestFromId ConnectionToMeWithStatus:YES andWeight:1];
    
    [self deleteThisRequest];
    
    [self.delegate didRespondToRequest];
}

- (IBAction)didTapDeny:(id)sender {
    
    [PlayerConnection removeSelfFromPendingOf:self.requestInfo.requestFromId];
    
    [self deleteThisRequest];
    
    [self.delegate didRespondToRequest];
}

@end
