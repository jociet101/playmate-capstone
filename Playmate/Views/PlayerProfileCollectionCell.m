//
//  PlayerProfileCollectionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerProfileCollectionCell.h"
#import "Constants.h"

@interface PlayerProfileCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation PlayerProfileCollectionCell

- (void)setUserProfile:(PFUser *)user {
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [user fetchIfNeeded];
    self.nameLabel.text = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.detailsLabel.text = [[[Constants getAgeInYears:user[@"birthday"][0]] stringByAppendingString:@" yo "] stringByAppendingString:user[@"gender"][0]];
    
    const BOOL hasProfileImage = (user[@"profileImage"] != nil);
    UIImage *img = hasProfileImage ? [UIImage imageWithData:[user[@"profileImage"] getData]] : [Constants profileImagePlaceholder];
    [self.profileImageView setImage:[Constants resizeImage:img withDimension:114]];
    
    // make profile image view a circle
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

@end
