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
    [self.requestInfo deleteInBackground];
}

- (IBAction)didTapAccept:(id)sender {
    [self deleteThisRequest];
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    // add a connection from this person's side
    PlayerConnection *connection;
    
    if ([user objectForKey:@"playerConnection"] == nil) {
        connection = [PlayerConnection initializePlayerConnection];
    } else {
        connection = user[@"playerConnection"];
        [user removeObjectForKey:@"playerConnection"];
    }
    
    [connection saveMyConnectionTo:self.requestInfo.requestFromId withStatus:YES andWeight:1];
    [PlayerConnection savePlayer:self.requestInfo.requestFromId ConnectionToMeWithStatus:YES andWeight:1];
}

/*
 - (IBAction)didTapFriend:(id)sender {
     
     PFUser *user = [PFUser currentUser];
     [user fetchIfNeeded];
     
     // if add friend
     
     // Create FriendRequest from me to other
     [FriendRequest saveFriendRequestTo:self.user.objectId];
     PlayerConnection *connection;
     
     if ([user objectForKey:@"playerConnection"] == nil) {
         connection = [PlayerConnection initializePlayerConnection];
     } else {
         connection = user[@"playerConnection"];
         [user removeObjectForKey:@"playerConnection"];
     }
     
     // Add pending friend connection from me to other
     
 //  TODO: save content to connection
 //  [connection saveMyConnectionTo:self.user.objectId withStatus:YES andWeight:1];
     
     [connection.pendingList addObject:self.user.objectId];
     NSLog(@"pending list %@", connection.pendingList);
     [user addObject:connection forKey:@"playerConnection"];
     
     [self.addFriendButton setTitle:@"Remove Friend" forState:UIControlStateNormal];
     
     // TODO: if remove friend
 }
 */

- (IBAction)didTapDeny:(id)sender {
    [self deleteThisRequest];
    
    // do not add a connection
}

@end
