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

- (UIImage *)resizeImage:(UIImage *)image {
    
    CGSize size = CGSizeMake(114, 114);
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 114, 114)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setUserProfile:(PFUser *)user {
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [user fetchIfNeeded];
    self.nameLabel.text = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    self.usernameLabel.text = [@"@" stringByAppendingString:user[@"username"]];
    self.detailsLabel.text = [[[Constants getAgeInYears:user[@"birthday"][0]] stringByAppendingString:@" yo "] stringByAppendingString:user[@"gender"][0]];
    
    if (user[@"profileImage"] != nil) {
        // set image stuff
        UIImage* img = [UIImage imageWithData:[user[@"profileImage"] getData]];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
    
    // make profile image view a circle
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

@end
