//
//  FriendCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "FriendCell.h"
#import "Constants.h"

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
    
    NSLog(@"self.thisuserid %@", self.thisUserId);
    
    PFQuery *query = [PFUser query];
    PFUser *thisUser = [[query getObjectWithId:self.thisUserId] fetchIfNeeded];
    
    self.nameLabel.text = thisUser.username;
    
    if (thisUser[@"profileImage"] != nil) {
        UIImage* img = [UIImage imageWithData:[thisUser[@"profileImage"] getData]];
        [self.profileImageView setImage:[Constants resizeImage:img withDimension:40]];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:[Constants resizeImage:img withDimension:40]];
    }
    
    const BOOL hasProfileImage = (thisUser[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? thisUser[@"profileImage"] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Constants resizeImage:img withDimension:40]];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

@end
