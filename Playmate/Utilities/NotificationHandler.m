//
//  NotificationHandler.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "NotificationHandler.h"
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UserNotifications/UNNotificationCategory.h>
#import <UserNotifications/UNNotificationAction.h>

@implementation NotificationHandler

+ (void)setUpNotifications {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
          // Enable or disable features based on authorization.
    }];
    
    UNNotificationAction* viewSessionAction = [UNNotificationAction
          actionWithIdentifier:@"VIEW_SESSION_ACTION"
          title:@"View Session"
          options:UNNotificationActionOptionNone];
    
    UNNotificationAction* openInMapsAction = [UNNotificationAction
          actionWithIdentifier:@"OPEN_MAP_ACTION"
          title:@"Open in Maps"
          options:UNNotificationActionOptionNone];
    
    UNNotificationCategory* sessionNotificationCategory = [UNNotificationCategory
         categoryWithIdentifier:@"SESSION"
         actions:@[viewSessionAction, openInMapsAction]
         intentIdentifiers:@[]
         options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNNotificationCategory* sessionInvitationCategory = [UNNotificationCategory
         categoryWithIdentifier:@"INVITATION"
         actions:@[]
         intentIdentifiers:@[]
         options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNNotificationCategory* friendRequestCategory = [UNNotificationCategory
         categoryWithIdentifier:@"FRIEND_REQUEST"
         actions:@[]
         intentIdentifiers:@[]
         options:UNNotificationCategoryOptionCustomDismissAction];
    
    [center setNotificationCategories:[NSSet setWithObjects:sessionNotificationCategory, sessionInvitationCategory, friendRequestCategory, nil]];
}

@end
