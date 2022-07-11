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

@end

@implementation PlayerProfileCollectionCell

- (void)setUserProfile:(PFUser *)user {
    [user fetchIfNeeded];
    self.nameLabel.text = [Constants concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    NSLog(@"name %@", self.nameLabel.text);
}

@end
