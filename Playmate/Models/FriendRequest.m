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

+ (void)saveFriendRequest:(FriendRequest *)request {
    [request saveInBackground];
}

@end
