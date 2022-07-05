//
//  SessionCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@interface SessionCell : UITableViewCell

@property (strong, nonatomic) Session* session;

- (void)setSession:(Session *)session;

@end

NS_ASSUME_NONNULL_END
