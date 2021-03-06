//
//  FriendRequest.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequest.h"

@implementation FriendRequest

@dynamic requestToId;
@dynamic requestFromId;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([FriendRequest class]);
}

+ (void)saveFriendRequestTo:(NSString *)objectId {
    FriendRequest *request = [FriendRequest new];
    request.requestToId = objectId;
    
    PFUser *requester = [[PFUser currentUser] fetchIfNeeded];
    request.requestFromId = requester.objectId;
    
    [request saveInBackground];
}

@end
