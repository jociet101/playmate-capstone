//
//  PlayerConnection.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <Parse/Parse.h>
#import "ConnectionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerConnection : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userObjectId;
// dictionary of ConnectionStates
@property (nonatomic, strong) NSDictionary *connections;
@property (nonatomic, strong) NSArray *friendsList;
@property (nonatomic, strong) NSArray *pendingList;

// methods

+ (PlayerConnection *)initializePlayerConnection;

// for saving own(A) connection to someone(B) else; Save B in A's dictionary (A is me)
+ (void)saveMyConnectionTo:(NSString *)otherObjectId withStatus:(BOOL)areFriends andWeight:(int)weight;

// for saving someone(B) else's connection to self(A); Save A in B's dictionary (A is me)
+ (void)savePlayer:(NSString *)otherObjectId ConnectionToMeWithStatus:(BOOL)areFriends andWeight:(int)weight;

+ (void)removeSelfFromPendingOf:(NSString *)otherObjectId;

@end

NS_ASSUME_NONNULL_END
