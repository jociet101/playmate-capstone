//
//  PlayerProfileCollectionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerProfileCollectionCell.h"
#import "Constants.h"
#import "Helpers.h"

@interface PlayerProfileCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation PlayerProfileCollectionCell

- (void)setUserProfile:(PFUser *)user {
    self.backgroundColor = [Constants playmateBlue];
    
    _userProfile = user;
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [user fetchIfNeeded];
    self.nameLabel.text = [Helpers concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.detailsLabel.text = [Helpers getDetailsLabelForPlayerCell:user];
    
    const BOOL hasProfileImage = (user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Helpers resizeImage:img withDimension:114]];
    [Helpers roundCornersOfImage:self.profileImageView];
}

@end
