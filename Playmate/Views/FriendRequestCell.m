//
//  FriendRequestCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequestCell.h"
#import "Constants.h"
#import "PlayerConnection.h"

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
    
    _requestInfo = requestInfo;
    
    PFQuery *query = [PFUser query];
    self.requester = [query getObjectWithId:requestInfo.requestFromId];
    
    NSLog(@"requester username %@", self.requester[@"username"]);
        
    NSString *requesterName = [Constants concatenateFirstName:self.requester[@"firstName"][0] andLast:self.requester[@"lastName"][0]];
    self.titleLabel.text = [requesterName stringByAppendingString:@" wants to be friends."];
    self.acceptButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.denyButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    if (self.requester[@"profileImage"] != nil) {
        UIImage* img = [UIImage imageWithData:[self.requester[@"profileImage"] getData]];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
    else {
        UIImage* img = [UIImage imageNamed:@"playmate_logo_transparent.png"];
        [self.profileImageView setImage:[self resizeImage:img]];
    }
}

- (void)deleteThisRequest {
//    [self.requestInfo deleteInBackground];
}

- (IBAction)didTapAccept:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    // add a connection from this person's side
    PlayerConnection *connection;
    
    if ([user objectForKey:@"playerConnection"] == nil) {
        connection = [PlayerConnection initializePlayerConnection];
        [user addObject:connection forKey:@"playerConnection"];
        [user saveInBackground];
    } else {
        connection = user[@"playerConnection"];
    }
    
//    [self saveMyConnectionToThem:user];
//    [self saveTheirConnectionToMe:user];
    
    [PlayerConnection saveMyConnectionTo:self.requestInfo.requestFromId withStatus:YES andWeight:1];
    [PlayerConnection savePlayer:self.requestInfo.requestFromId ConnectionToMeWithStatus:YES andWeight:1];
    
    [self deleteThisRequest];
}

//- (void)saveMyConnectionToThem:(PFUser *)me {
//
//    PlayerConnection *pc = me[@"playerConnection"];
//
//    NSLog(@"player connection %@", pc);
//    NSLog(@"friends list %@", pc.friendsList);
//    NSLog(@"pending list %@", pc.pendingList);
//
//    [pc.friendsList addObject:self.requestInfo.requestFromId];
//    [pc.pendingList removeObject:self.requestInfo.requestFromId];
//}
//
//- (void)saveTheirConnectionToMe:(PFUser *)me {
//
//    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
//    [query whereKey:@"userObjectId" equalTo:self.requestInfo.requestFromId];
//
//    PlayerConnection *pc = [query getFirstObject];
//
//    [pc.friendsList addObject:me.objectId];
//    [pc.pendingList removeObject:me.objectId];
//}

- (IBAction)didTapDeny:(id)sender {
    
    [PlayerConnection removeSelfFromPendingOf:self.requestInfo.requestFromId];
    
    [self deleteThisRequest];
}

@end
