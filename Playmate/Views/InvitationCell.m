//
//  InvitationCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import "InvitationCell.h"

@interface InvitationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *invitationMessage;
@property (weak, nonatomic) IBOutlet UIButton *viewSessionButton;


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
    
}

@end
