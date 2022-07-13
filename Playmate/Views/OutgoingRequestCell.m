//
//  OutgoingRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "OutgoingRequestCell.h"

@interface OutgoingRequestCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
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
}

@end
