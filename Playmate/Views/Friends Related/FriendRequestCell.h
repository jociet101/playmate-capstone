//
//  FriendRequestCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "FriendRequest.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FriendRequestCellDelegate;

@interface FriendRequestCell : UITableViewCell

@property (nonatomic, strong) FriendRequest *requestInfo;

- (void)setRequestInfo:(FriendRequest *)requestInfo;

@property (nonatomic, weak) id<FriendRequestCellDelegate> delegate;

@end

@protocol FriendRequestCellDelegate

- (void)didTap:(FriendRequestCell *)cell profileImage:(PFUser *)user;
- (void)didRespondToRequest;

@end

NS_ASSUME_NONNULL_END
