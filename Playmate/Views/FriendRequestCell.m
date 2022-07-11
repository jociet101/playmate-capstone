//
//  FriendRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequestCell.h"
#import "Constants.h"

@interface FriendRequestCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation FriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequestInfo:(FriendRequest *)requestInfo {
    
    PFUser *requester = requestInfo.requestFrom;
    [requester fetchIfNeeded];
    NSString *requesterName = [Constants concatenateFirstName:requester[@"firstName"] andLast:requester[@"lastName"]];
    
    self.titleLabel.text = [requesterName stringByAppendingString:@" wants to be friends."];
    self.acceptButton.layer.cornerRadius = [Constants buttonCornerRadius];
    self.denyButton.layer.cornerRadius = [Constants buttonCornerRadius];
}

- (IBAction)didTapAccept:(id)sender {
}

- (IBAction)didTapDeny:(id)sender {
}

@end
