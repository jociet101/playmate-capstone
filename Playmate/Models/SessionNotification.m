//
//  SessionNotification.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import "SessionNotification.h"
#import "Session.h"
#import "Helpers.h"

@implementation SessionNotification

@dynamic sessionObjectId;
@dynamic userObjectId;
@dynamic tenBeforeTime;
@dynamic thirtyBeforeTime;
@dynamic sixtyBeforeTime;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([SessionNotification class]);
}

+ (void)createNotificationForSession:(NSString *)sessionId forUser:(NSString *)userId {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    Session *session = [query getObjectWithId:sessionId];
    NSDate *sessionDate = session.occursAt;
    
    SessionNotification *notification = [SessionNotification new];
    notification.sessionObjectId = sessionId;
    notification.userObjectId = userId;
    notification.tenBeforeTime = [Helpers removeMinutes:10 fromTime:sessionDate];
    notification.thirtyBeforeTime = [Helpers removeMinutes:30 fromTime:sessionDate];
    notification.sixtyBeforeTime = [Helpers removeMinutes:60 fromTime:sessionDate];
    
    [notification saveInBackground];
}

+ (SessionNotification *)fetchMostRecentSessionNotification {
    PFQuery *query = [PFQuery queryWithClassName:@"SessionNotification"];
    [query orderByDescending:@"updatedAt"];
    
    SessionNotification *notification = [[query getFirstObject] fetchIfNeeded];
    return notification;
}

@end
