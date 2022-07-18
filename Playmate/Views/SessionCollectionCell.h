//
//  SessionCollectionCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@interface SessionCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Session *session;

- (void)setSession:(Session *)session;

@end

NS_ASSUME_NONNULL_END
