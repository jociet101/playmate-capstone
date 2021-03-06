//
//  FriendRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequestCell.h"
#import "PlayerConnection.h"
#import "DateTools.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface FriendRequestCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *acceptedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *deniedIcon;

@property (nonatomic, strong) PFUser *requester;

@end

@implementation FriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Setup gesture recognizer so tapping on profile image leads to player profile
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    [Helpers roundCornersOfImage:self.profileImageView];
}

- (void)didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate didTap:self profileImage:self.requester];
}

- (void)setRequestInfo:(FriendRequest *)requestInfo {
    
    _requestInfo = requestInfo;
    
    PFQuery *query = [PFUser query];
    self.requester = [query getObjectWithId:requestInfo.requestFromId];
    self.titleLabel.text = [Helpers incomingRequestMessageFor:self.requester];
    
    [Helpers setCornerRadiusAndColorForButton:self.acceptButton andIsSmall:YES];
    [Helpers setCornerRadiusAndColorForButton:self.denyButton andIsSmall:YES];
    
    const BOOL hasProfileImage = (self.requester[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[self.requester[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:83]];
    self.timeAgoLabel.text = [Helpers appendAgoToTime:requestInfo.updatedAt];
    [self hideConfirmationLabels];
    [self enableButtons];
}

- (void)hideConfirmationLabels {
    self.acceptedIcon.alpha = 0;
    self.deniedIcon.alpha = 0;
    self.confirmationLabel.alpha = 0;
}

- (void)disableButtons {
    [self.acceptButton setEnabled:NO];
    [self.denyButton setEnabled:NO];
    self.acceptButton.alpha = 0;
    self.denyButton.alpha = 0;
}

- (void)enableButtons {
    [self.acceptButton setEnabled:YES];
    [self.denyButton setEnabled:YES];
    self.acceptButton.alpha = 1;
    self.denyButton.alpha = 1;
}

- (void)deleteThisRequest {
    [self.requestInfo deleteInBackground];
}

- (IBAction)didTapAccept:(id)sender {
    // Update confirmation UI
    self.acceptedIcon.alpha = 1;
    self.confirmationLabel.alpha = 1;
    self.confirmationLabel.text = [Constants acceptedConfirmationStringFor:self.requester.username];
    [self disableButtons];
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    // Add a connection from this person's side
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
}

- (IBAction)didTapDeny:(id)sender {
    // Update confirmation UI
    self.deniedIcon.alpha = 1;
    self.confirmationLabel.alpha = 1;
    self.confirmationLabel.text = [Constants deniedConfirmationStringFor:self.requester.username];
    [self disableButtons];
    
    [PlayerConnection removeSelfFromPendingOf:self.requestInfo.requestFromId];
    [self deleteThisRequest];
}

@end
