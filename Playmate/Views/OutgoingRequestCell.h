//
//  OutgoingRequestCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutgoingRequestCell : UITableViewCell

@property (nonatomic, strong) NSString *userObjectId;

- (void)setUserObjectId:(NSString *)userObjectId;

@end


/*
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
 */

NS_ASSUME_NONNULL_END
