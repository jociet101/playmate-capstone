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

@property (nonatomic, strong) PFUser *requester;

@end

@implementation FriendRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2.0f;
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate didTap:self profileImage:self.requester];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *)resizeImage:(UIImage *)image {
    
    CGSize size = CGSizeMake(83, 83);
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 83)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setRequestInfo:(FriendRequest *)requestInfo {
    
    PFUser *requester = requestInfo.requestFrom;
    [requester fetchIfNeeded];
    self.requester = requester;
        
    NSString *requesterName = [Constants concatenateFirstName:requester[@"firstName"][0] andLast:requester[@"lastName"][0]];
    self.titleLabel.text = [requesterName stringByAppendingString:@" wants to be friends."];
    self.acceptButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.denyButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    if (requester[@"profileImage"] != nil) {
        UIImage* img = [UIImage imageWithData:[requester[@"profileImage"] getData]];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
}

- (void)deleteThisRequest {
    
}

- (IBAction)didTapAccept:(id)sender {
    [self deleteThisRequest];
    
    // add a connection from this person's side
}

- (IBAction)didTapDeny:(id)sender {
    [self deleteThisRequest];
    
    // do not add a connection
}

@end
