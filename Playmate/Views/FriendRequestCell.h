//
//  FriendRequestCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "FriendRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequestCell : UITableViewCell

@property (nonatomic, strong) FriendRequest *requestInfo;

- (void)setRequestInfo:(FriendRequest *)requestInfo;

@end

NS_ASSUME_NONNULL_END
