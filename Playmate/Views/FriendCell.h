//
//  FriendCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) NSString *thisUserId;

- (void)setThisUserId:(NSString *)thisUserId;

@end

NS_ASSUME_NONNULL_END
