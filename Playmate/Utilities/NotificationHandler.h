//
//  NotificationHandler.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SessionNotification.h"
#import "Session.h"
#import "Invitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationHandler : NSObject

+ (void)setUpNotifications;
+ (void)scheduleSessionNotification:(SessionNotification *)notification;

@end

NS_ASSUME_NONNULL_END
