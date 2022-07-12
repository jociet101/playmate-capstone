//
//  PlayerConnection.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerConnection.h"

@implementation PlayerConnection

@dynamic userObjectId;
@dynamic connections;

+ (nonnull NSString *)parseClassName {
    return @"PlayerConnection";
}

+ (void)savePlayer:(NSString *)objectId withConnections:(NSDictionary *)connect {
    PlayerConnection *pc = [PlayerConnection new];
    pc.userObjectId = objectId;
    pc.connections = connect;
    
    [pc saveInBackground];
}

@end
