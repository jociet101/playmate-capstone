//
//  SessionNotification.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "SessionNotification.h"
#import "Session.h"
#import "Helpers.h"
#import "Strings.h"

@implementation SessionNotification

@dynamic sessionObjectId;
@dynamic userObjectId;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([SessionNotification class]);
}

+ (void)createNotificationForSession:(NSString *)sessionId forUser:(NSString *)userId {
    SessionNotification *notification = [SessionNotification new];
    notification.sessionObjectId = sessionId;
    notification.userObjectId = userId;
    
    [notification saveInBackground];
}

+ (SessionNotification *)fetchMostRecentSessionNotification {
    PFQuery *query = [PFQuery queryWithClassName:@"SessionNotification"];
    [query orderByDescending:@"createdAt"];
    
    SessionNotification *notification = [[query getFirstObject] fetchIfNeeded];
    return notification;
}

+ (void)deleteNotificationsForSession:(NSString *)sessionId {
    PFQuery *query = [PFQuery queryWithClassName:@"SessionNotification"];
    [query whereKey:@"sessionObjectId" equalTo:sessionId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        } else {
            for (SessionNotification *notification in objects) {
                [notification deleteInBackground];
            }
        }
    }];
}

@end
