//
//  NotificationHandler.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <UserNotifications/UserNotifications.h>
#import "Session.h"
#import "Invitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationHandler : NSObject

+ (void)setUpNotifications;
+ (void)scheduleSessionNotification:(NSString *)sessionObjectId;
+ (void)unscheduleSessionNotification:(NSString *)sessionObjectId;

@end

NS_ASSUME_NONNULL_END
