//
//  PlayerProfileViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
