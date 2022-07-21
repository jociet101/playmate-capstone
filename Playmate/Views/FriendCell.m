//
//  FriendCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "FriendCell.h"
#import "Constants.h"
#import "Helpers.h"

@interface FriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThisUserId:(NSString *)thisUserId {
    _thisUserId = thisUserId;
        
    PFQuery *query = [PFUser query];
    PFUser *thisUser = [[query getObjectWithId:self.thisUserId] fetchIfNeeded];
    
    self.nameLabel.text = thisUser.username;
    
    const BOOL hasProfileImage = (thisUser[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[thisUser[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:40]];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

@end
