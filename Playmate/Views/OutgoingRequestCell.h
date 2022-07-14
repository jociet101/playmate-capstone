//
//  OutgoingRequestCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OutgoingRequestCellDelegate;

@interface OutgoingRequestCell : UITableViewCell

@property (nonatomic, strong) NSString *userObjectId;

- (void)setUserObjectId:(NSString *)userObjectId;

@property (nonatomic, weak) id<OutgoingRequestCellDelegate> delegate;

@end

@protocol OutgoingRequestCellDelegate

- (void)didCancelRequest;

@end

NS_ASSUME_NONNULL_END
