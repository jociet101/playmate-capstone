//
//  Invitation.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/21/22.
//

#import "Invitation.h"

@implementation Invitation

@dynamic invitationToId;
@dynamic invitationFromId;
@dynamic sessionObjectId;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([Invitation class]);
}

+ (void)saveInvitationTo:(NSString *)objectId forSession:(NSString *)sessionId {
    Invitation *invitation = [Invitation new];
    invitation.invitationToId = objectId;
    
    PFUser *inviter = [[PFUser currentUser] fetchIfNeeded];
    invitation.invitationFromId = inviter.objectId;
    
    invitation.sessionObjectId = sessionId;
    
    [invitation saveInBackground];
}

@end
