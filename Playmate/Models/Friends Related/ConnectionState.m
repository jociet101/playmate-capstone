//
//  ConnectionState.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/12/22.
//

#import "ConnectionState.h"

@implementation ConnectionState

@dynamic areFriends;
@dynamic relationshipWeight;

+ (nonnull NSString *)parseClassName {
    return @"ConnectionState";
}

@end
