//
//  FriendRequest.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequest.h"

@implementation FriendRequest

@dynamic toObjectId;
@dynamic requestFrom;

+ (nonnull NSString *)parseClassName {
    return @"FriendRequest";
}

+ (void)saveFriendRequest:(NSString *)objectId from:user {
    FriendRequest *request = [FriendRequest new];
    request.toObjectId = objectId;
    request.requestFrom = user;
    
    [request saveInBackground];
}

@end
