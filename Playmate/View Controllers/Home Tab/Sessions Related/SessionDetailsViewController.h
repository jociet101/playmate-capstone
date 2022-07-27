//
//  SessionDetailsViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SessionDetailsViewControllerDelegate

- (void)reloadHomeTabSessions;

@end

@interface SessionDetailsViewController : UIViewController

@property (nonatomic, strong) Session* sessionDetails;

@property (nonatomic, strong) id<SessionDetailsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
