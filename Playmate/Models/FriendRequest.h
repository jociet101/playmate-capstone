//
//  FriendRequest.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequest : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *requestToId;
@property (nonatomic, strong) NSString *requestFromId;

+ (void)saveFriendRequestTo:(NSString *)objectId;

@end

NS_ASSUME_NONNULL_END
