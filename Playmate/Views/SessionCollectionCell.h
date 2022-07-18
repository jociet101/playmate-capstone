//
//  SessionCollectionCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SessionCollectionCellDelegate

- (void)segueToFullSessionDetails:(Session *)session;

@end

@interface SessionCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) id<SessionCollectionCellDelegate> delegate;

- (void)setSession:(Session *)session;

@end

NS_ASSUME_NONNULL_END
