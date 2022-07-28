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

@interface NotificationHandler ()

@end

@implementation NotificationHandler

// TODO: implement other types of notifications
+ (void)setUpNotifications {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
    
    [NotificationHandler registerCategories];
}

+ (void)registerCategories {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    // Create view session and open map actions
    UNNotificationAction* viewSessionAction = [UNNotificationAction
          actionWithIdentifier:@"VIEW_ACTION"
          title:@"View Details"
          options:UNNotificationActionOptionForeground];
    
    UNNotificationAction* openInGoogleMapsAction = [UNNotificationAction
          actionWithIdentifier:@"OPEN_GOOGLE_MAP_ACTION"
          title:@"Open in Google Maps"
          options:UNNotificationActionOptionNone];
    
    UNNotificationAction* openInAppleMapsAction = [UNNotificationAction
          actionWithIdentifier:@"OPEN_APPLE_MAP_ACTION"
          title:@"Open in Apple Maps"
          options:UNNotificationActionOptionNone];
    
    UNNotificationCategory* sessionNotificationCategory = [UNNotificationCategory
         categoryWithIdentifier:@"SESSION"
         actions:@[viewSessionAction, openInGoogleMapsAction, openInAppleMapsAction]
         intentIdentifiers:@[]
         options:UNNotificationCategoryOptionNone];
    
    NSSet *categorySet = [[NSSet alloc] initWithObjects:sessionNotificationCategory, nil];
    [center setNotificationCategories:categorySet];
}

+ (void)scheduleSessionNotification:(SessionNotification *)notification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    Session *session = [query getObjectWithId:notification.sessionObjectId];
    Location *location = [session.location fetchIfNeeded];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Playmate";
    content.body = [NSString stringWithFormat:@"You have an upcoming %@ session in 10 minutes at %@.", session.sport, location.locationName];
    content.categoryIdentifier = @"SESSION";
    content.userInfo = @{@"sessionObjectId" : session.objectId};
    
    NSDate *newDate = [Helpers removeMinutes:10 fromTime:session.occursAt];    
    NSString *uniqueId = [me.objectId stringByAppendingString:session.objectId];
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
