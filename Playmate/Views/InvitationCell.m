//
//  InvitationCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import "InvitationCell.h"
#import "Invitation.h"
#import "Helpers.h"
#import "Constants.h"
#import "Session.h"

@interface InvitationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *invitationMessage;
@property (weak, nonatomic) IBOutlet UIButton *viewSessionButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteInviteButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deletedInvitationIcon;
@property (weak, nonatomic) IBOutlet UILabel *deletedInvitationConfirmationLabel;

@property (nonatomic, strong) Session *session;

@end

@implementation InvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInvitation:(Invitation *)invitation {
    [Helpers setCornerRadiusAndColorForButton:self.viewSessionButton andIsSmall:YES];
    [Helpers setCornerRadiusAndColorForButton:self.deleteInviteButton andIsSmall:YES];
    
    self.deletedInvitationIcon.alpha = 0;
    self.deletedInvitationConfirmationLabel.alpha = 0;
    
    _invitation = invitation;
    
    PFQuery *query = [PFUser query];
    PFUser *user = [query getObjectWithId:invitation.invitationFromId];
    PFQuery *sessionQuery = [PFQuery queryWithClassName:@"SportsSession"];
    self.session = [sessionQuery getObjectWithId:invitation.sessionObjectId];

    NSString *inviterName = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.invitationMessage.text = [inviterName stringByAppendingString:[NSString stringWithFormat:@" invited you to join a %@ session.", self.session.sport]];
    
    // TODO: set image view to the sport icon
    const BOOL hasProfileImage = (user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:img];
    
    // set time ago timestamp
    self.timeAgoLabel.text = [[invitation.createdAt shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
}

- (void)disableButtons {
    self.viewSessionButton.alpha = 0;
    [self.viewSessionButton setEnabled:NO];
    self.deleteInviteButton.alpha = 0;
    [self.deleteInviteButton setEnabled:NO];
}

- (IBAction)didTapViewSession:(id)sender {
    [self.delegate viewSessionFromInvite:self.session];
}

- (IBAction)didTapDeleteInvite:(id)sender {
    self.deletedInvitationIcon.alpha = 1;
    self.deletedInvitationConfirmationLabel.alpha = 1;
    [self disableButtons];
    [self.invitation deleteInBackground];
}

@end
