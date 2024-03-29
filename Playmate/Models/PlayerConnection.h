//
//  PlayerConnection.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerConnection : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSArray *friendsList;
@property (nonatomic, strong) NSArray *pendingList;

+ (PlayerConnection *)initializePlayerConnection;

// for saving own(A) connection to someone(B) else; Save B in A's dictionary (A is me)
+ (void)saveMyConnectionTo:(NSString *)otherObjectId withStatus:(BOOL)areFriends andWeight:(int)weight;

// for saving someone(B) else's connection to self(A); Save A in B's dictionary (A is me)
+ (void)savePlayer:(NSString *)otherObjectId ConnectionToMeWithStatus:(BOOL)areFriends andWeight:(int)weight;

// for when self (A) denies friend request of otherobjectid (B)
+ (void)removeSelfFromPendingOf:(NSString *)otherObjectId;

@end

NS_ASSUME_NONNULL_END
