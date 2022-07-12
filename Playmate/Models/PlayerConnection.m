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
    pc.connections = [NSDictionary new];
    pc.friendsList = [NSMutableArray new];
    pc.pendingList = [NSMutableArray new];
    
    [pc saveInBackground];
    return pc;
}

// for saving own(A) connection to someone(B) else; Save B in A's dictionary (A is me)
- (void)saveMyConnectionTo:(NSString *)otherObjectId withStatus:(BOOL)areFriends andWeight:(int)weight {
    // can use self
}

// for saving someone(B) else's connection to self(A); Save A in B's dictionary (A is me)
- (void)savePlayer:(NSString *)otherObjectId ConnectionToMewithStatus:(BOOL)areFriends andWeight:(int)weight {
    
}

// if I deny someone else's friend request
- (void)removeSelfFromPendingOf:(NSString *)otherObjectId {
    
}

@end
