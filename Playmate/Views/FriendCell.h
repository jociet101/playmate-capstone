//
//  FriendCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FriendCellDelegate;

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) NSString *thisUserId;
@property id<FriendCellDelegate> delegate;

- (void)setThisUserId:(NSString *)thisUserId;

@end

@protocol FriendCellDelegate

- (void)didTap:(FriendCell *)cell forName:(NSString *)name;

@end


NS_ASSUME_NONNULL_END
