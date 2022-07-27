//
//  SessionNotification.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/26/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionNotification : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *sessionObjectId;
@property (nonatomic, strong) NSString *userObjectId;

+ (void)createNotificationForSession:(NSString *)sessionId forUser:(NSString *)userId;
+ (SessionNotification *)fetchMostRecentSessionNotification;
+ (void)deleteNotificationsForSession:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
