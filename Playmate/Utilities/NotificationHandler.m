//
//  NotificationHandler.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "NotificationHandler.h"
#import "FriendRequest.h"
#import "Location.h"
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
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    Session *session = [query getObjectWithId:notification.sessionObjectId];
    Location *location = [session.location fetchIfNeeded];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Playmate";
    content.body = [NSString stringWithFormat:@"You have an upcoming %@ session at %@.", session.sport, location.locationName];
    content.categoryIdentifier = @"SESSION";
    
    NSDate *newDate = notification.tenBeforeTime;
    NSString *uniqueId = [me.objectId stringByAppendingString:notification.sessionObjectId];
    NSLog(@"newdate = %@", newDate);
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:[Helpers getComponentsFromDate:newDate] repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:uniqueId content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

+ (void)unscheduleSessionNotification:(NSString *)sessionObjectId {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    NSArray *identifierArray = [[NSArray alloc] initWithObjects:[me.objectId stringByAppendingString:sessionObjectId], nil];
    [center removePendingNotificationRequestsWithIdentifiers:identifierArray];
}

+ (void)sendInvitationNotification:(Invitation *)invitation {
    
}

+ (void)sendFriendRequestNotification:(FriendRequest *)request {
    
}

@end
