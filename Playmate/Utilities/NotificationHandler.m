//
//  NotificationHandler.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "NotificationHandler.h"
#import "FriendRequest.h"
#import "Helpers.h"
#import "Strings.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationHandler () <UNUserNotificationCenterDelegate>

@end

@implementation NotificationHandler

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
   // Update the app interface directly.
    NSLog(@"delegate notif method called");
    // Play a sound.
   completionHandler(UNNotificationPresentationOptionSound);
}

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
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"requests.count = %ld\n%@", requests.count, requests);
    }];
    
//    [center removeAllPendingNotificationRequests];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    Session *session = [query getObjectWithId:notification.sessionObjectId];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    content.title = @"Playmate";
    content.body = [NSString stringWithFormat:@"You have an upcoming %@ session in 30 minutes.", session.sport];
    
    content.categoryIdentifier = @"SESSION";
        
    NSDate *newDate = [Helpers removeMinutes:-9 fromTime:notification.tenBeforeTime];
    
    UNCalendarNotificationTrigger* trigger =  [UNCalendarNotificationTrigger
           triggerWithDateMatchingComponents:[Helpers getComponentsFromDate:newDate] repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest
           requestWithIdentifier:[NSString stringWithFormat:@"session_%@", notification.sessionObjectId] content:content trigger:trigger];
    
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

+ (void)scheduleNotificationTesting {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Playmate Notification";
    content.body = @"You have a received a playmate notification.";
    content.categoryIdentifier = @"alarm";
    NSDateComponents *comp = [NSDateComponents new];
    comp.hour = 10;
    comp.minute = 30;
//    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comp repeats:YES];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[[NSUUID UUID] UUIDString] content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"ADDED REQUEST");
    }];
}

@end
