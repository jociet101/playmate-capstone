//
//  Invitation.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/21/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Invitation : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *invitationToId;
@property (nonatomic, strong) NSString *invitationFromId;
@property (nonatomic, strong) NSString *sessionObjectId;

+ (void)saveInvitationTo:(NSString *)objectId forSession:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
