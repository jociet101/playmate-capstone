//
//  FriendRequest.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequest.h"

@implementation FriendRequest

@dynamic userObjectId;
@dynamic requestFrom;

+ (nonnull NSString *)parseClassName {
    return @"FriendRequest";
}

+ (void)saveFriendRequest:(NSString *)objectId from:(PFUser *)user {
    
    FriendRequest *request = [FriendRequest new];
    
    NSLog(@"object id = %@", objectId);
    
    request.userObjectId = objectId;
    request.requestFrom = user;
    
    [request saveInBackground];
}

@end
