//
//  ConnectionState.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/12/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionState : PFObject <PFSubclassing>

@property (nonatomic, assign) BOOL areFriends;
@property (nonatomic, assign) int relationshipWeight;

@end

NS_ASSUME_NONNULL_END
