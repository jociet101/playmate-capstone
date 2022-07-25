//
//  CreateMenuViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreateMenuViewControllerDelegate

- (void)reloadHomeTabSessions;

@end

@interface CreateMenuViewController : UIViewController

@property (nonatomic, strong) id<CreateMenuViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
