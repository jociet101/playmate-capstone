//
//  FriendCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "FriendCell.h"

@interface FriendCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

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
    PFUser *thisUser = [query getObjectWithId:self.thisUserId];
    [thisUser fetchIfNeeded];
    
    self.nameLabel.text = thisUser.username;
}

@end
