//
//  NotificationHandler.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "NotificationHandler.h"
#import "SessionNotification.h"
#import "Session.h"
#import "Invitation.h"
#import "FriendRequest.h"
#import "Helpers.h"
#import "Strings.h"
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UserNotifications/UNNotificationCategory.h>
#import <UserNotifications/UNNotificationAction.h>
#import <UserNotifications/UNNotificationContent.h>
#import <UserNotifications/UNNotificationRequest.h>
#import <UserNotifications/UNNotificationTrigger.h>

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

+ (void)scheduleSessionNotification:(SessionNotification *)notification {
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    Session *session = [query getObjectWithId:notification.sessionObjectId];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    content.title = @"Playmate";
    content.body = [NSString stringWithFormat:@"You have an upcoming %@ session in 30 minutes.", session.sport];
    
    content.categoryIdentifier = @"SESSION";
    
    UNCalendarNotificationTrigger* trigger =  [UNCalendarNotificationTrigger
           triggerWithDateMatchingComponents:[Helpers getComponentsFromDate:notification.thirtyBeforeTime] repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest
           requestWithIdentifier:@"Session" content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

+ (void)sendInvitationNotification:(Invitation *)invitation {
    
}

+ (void)sendFriendRequestNotification:(FriendRequest *)request {
    
}

@end
