//
//  PlayerConnection.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "PlayerConnection.h"
#import "Constants.h"
#import "Helpers.h"

@implementation PlayerConnection

@dynamic userObjectId;
@dynamic connections;
@dynamic friendsList;
@dynamic pendingList;

+ (nonnull NSString *)parseClassName {
    return @"PlayerConnection";
}

+ (PlayerConnection *)initializePlayerConnection {
    
    PlayerConnection *playerConnection = [PlayerConnection new];

    PFUser *me = [PFUser currentUser];
    playerConnection.userObjectId = me.objectId;
    playerConnection.connections = [NSMutableDictionary new];
    playerConnection.friendsList = [NSMutableArray new];
    playerConnection.pendingList = [NSMutableArray new];
    
    [playerConnection saveInBackground];
    return playerConnection;
}

// for saving own(A) connection to someone(B) else; Save B in A's dictionary (A is me)
+ (void)saveMyConnectionTo:(NSString *)otherObjectId withStatus:(BOOL)areFriends andWeight:(int)weight {

    // TODO: use for recommender system later
//    ConnectionState *cs = [ConnectionState new];
//    cs.areFriends = areFriends;
//    cs.relationshipWeight = weight;
//    [pc.connections setObject:cs forKey:otherObjectId];
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:me];

    if (areFriends) {
        NSMutableArray *tempFriendsList = (NSMutableArray *)playerConnection[@"friendsList"];
        [tempFriendsList addObject:otherObjectId];
        playerConnection[@"friendsList"] = (NSArray *)tempFriendsList;
    }
    
    [playerConnection saveInBackground];
}

// for saving someone(B) else's connection to self(A); Save A in B's dictionary (A is me)
+ (void)savePlayer:(NSString *)otherObjectId ConnectionToMeWithStatus:(BOOL)areFriends andWeight:(int)weight {
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:otherObjectId];
    
    PlayerConnection *playerConnection = [[query getFirstObject] fetchIfNeeded];
    
    // TODO: use for recommender system later
//    ConnectionState *cs = [ConnectionState new];
//    cs.areFriends = areFriends;
//    cs.relationshipWeight = weight;

//    [pc.connections setObject:cs forKey:me.objectId];

    if (areFriends) {
        
        NSMutableArray *tempFriendsList = (NSMutableArray *)playerConnection[@"friendsList"];
        [tempFriendsList addObject:me.objectId];
        playerConnection[@"friendsList"] = (NSArray *)tempFriendsList;
        
        NSMutableArray *tempPendingList = (NSMutableArray *)playerConnection[@"pendingList"];
        [tempPendingList removeObject:me.objectId];
        playerConnection[@"pendingList"] = (NSArray *)tempPendingList;
    }
    
    [playerConnection saveInBackground];
}

// if I deny someone else's friend request
+ (void)removeSelfFromPendingOf:(NSString *)otherObjectId {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerConnection"];
    [query whereKey:@"userObjectId" equalTo:otherObjectId];
    
    PlayerConnection *playerConnection = [query getFirstObject];
    
    NSMutableArray *tempPendingList = (NSMutableArray *)playerConnection[@"pendingList"];
    [tempPendingList removeObject:me.objectId];
    playerConnection[@"pendingList"] = (NSArray *)tempPendingList;
    
    [playerConnection saveInBackground];
}

@end
