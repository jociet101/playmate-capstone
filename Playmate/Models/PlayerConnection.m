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
@dynamic friendsList;
@dynamic pendingList;

+ (nonnull NSString *)parseClassName {
    return @"PlayerConnection";
}

//+ (void)savePlayer:(NSString *)objectId withConnections:(NSDictionary *)connect {
//    PlayerConnection *pc = [PlayerConnection new];
//    pc.userObjectId = objectId;
//    pc.connections = connect;
//
//    [pc saveInBackground];
//}

+ (PlayerConnection *)initializePlayerConnection {
    
    PlayerConnection *pc = [PlayerConnection new];
    
    PFUser *me = [PFUser currentUser];
    pc.userObjectId = me.objectId;
    pc.connections = [NSMutableDictionary new];
    pc.friendsList = [NSMutableArray new];
    pc.pendingList = [NSMutableArray new];
    
    [pc saveInBackground];
    return pc;
}

// for saving own(A) connection to someone(B) else; Save B in A's dictionary (A is me)
+ (void)saveMyConnectionTo:(NSString *)otherObjectId withStatus:(BOOL)areFriends andWeight:(int)weight {
    
//    ConnectionState *cs = [ConnectionState new];
//    cs.areFriends = areFriends;
//    cs.relationshipWeight = weight;
    
    PFUser *me = [PFUser currentUser];
    [me fetchIfNeeded];
    
    PlayerConnection *pc = me[@"playerConnection"][0];
    [pc fetchIfNeeded];

//    [pc.connections setObject:cs forKey:otherObjectId];
    NSLog(@"pc = %@", pc[@"friendsList"]);

    if (areFriends) {
        NSMutableArray *tempFriendsList = (NSMutableArray *)pc[@"friendsList"];
        [tempFriendsList addObject:otherObjectId];
        pc[@"friendsList"] = (NSArray *)tempFriendsList;
    }
    
    [pc saveInBackground];
}

// for saving someone(B) else's connection to self(A); Save A in B's dictionary (A is me)
+ (void)savePlayer:(NSString *)otherObjectId ConnectionToMeWithStatus:(BOOL)areFriends andWeight:(int)weight {
    
    PFUser *me = [PFUser currentUser];
    [me fetchIfNeeded];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:otherObjectId];
    
    PlayerConnection *pc = [query getFirstObject];
    [pc fetchIfNeeded];
    
    NSLog(@"pc %@ for %@", pc, otherObjectId);
    
//    ConnectionState *cs = [ConnectionState new];
//    cs.areFriends = areFriends;
//    cs.relationshipWeight = weight;

//    [pc.connections setObject:cs forKey:me.objectId];

    if (areFriends) {
        
        NSMutableArray *tempFriendsList = (NSMutableArray *)pc[@"friendsList"];
        [tempFriendsList addObject:me.objectId];
        pc[@"friendsList"] = (NSArray *)tempFriendsList;
        
        NSMutableArray *tempPendingList = (NSMutableArray *)pc[@"pendingList"];
        [tempPendingList removeObject:me.objectId];
        pc[@"pendingList"] = (NSArray *)tempPendingList;
    }
    
    [pc saveInBackground];
}

// if I deny someone else's friend request
+ (void)removeSelfFromPendingOf:(NSString *)otherObjectId {
    PFUser *me = [PFUser currentUser];
    [me fetchIfNeeded];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:otherObjectId];
    
    PlayerConnection *pc = [query getFirstObject];
    
    NSMutableArray *tempPendingList = (NSMutableArray *)pc[@"pendingList"];
    [tempPendingList removeObject:me.objectId];
    pc[@"pendingList"] = (NSArray *)tempPendingList;
    
    [pc saveInBackground];
}

@end
