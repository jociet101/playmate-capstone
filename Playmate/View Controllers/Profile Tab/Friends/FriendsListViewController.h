//
//  FriendsListViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsListViewController : UIViewController

@property (nonatomic, strong) PFUser *thisUser;
@property (nonatomic, assign) BOOL isForInvitations;

@end

NS_ASSUME_NONNULL_END
