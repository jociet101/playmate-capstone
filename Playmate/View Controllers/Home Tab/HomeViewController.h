//
//  HomeViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeViewControllerDelegate

- (void)loadSessionList:(NSArray *)sessionList;

@end

@interface HomeViewController : UIViewController

@property (weak, nonatomic) id<HomeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
