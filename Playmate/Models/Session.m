//
//  Session.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "Session.h"

@implementation Session

@dynamic objectId;
@dynamic sport;
@dynamic skillLevel;
@dynamic creator;
@dynamic playersList;
@dynamic occursAt;
@dynamic duration;
@dynamic location;
@dynamic capacity;
@dynamic occupied;

+ (nonnull NSString *)parseClassName {
    return @"SportsSession";
}

+ (void) createSession: (PFUser * _Nullable)user withSport: (NSString * _Nullable)spt withLevel: (NSString * _Nullable)level withDate: (NSDate * _Nullable)date withDuration: (NSNumber * _Nullable)duration withLocation:(PFObject * _Nullable)loc withCapacity:(NSNumber * _Nullable)cap withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//+ (void) createSession: (PFUser * _Nullable)user withSport: (NSString * _Nullable)spt withLevel: (NSString * _Nullable)level withDate: (NSDate * _Nullable)date withCapacity:(NSNumber * _Nullable)cap withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    NSLog(@"creating session");
    
    Session *newSession = [Session new];
    newSession.sport = spt;
    newSession.skillLevel = level;
    newSession.creator = user;
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    [tempList addObject:[PFUser currentUser]];
    newSession.playersList = (NSArray *)tempList;
    newSession.occursAt = date;
    newSession.duration = duration;
    newSession.location = loc;
    newSession.capacity = cap;
    newSession.occupied = @(1);
    
    [newSession saveInBackgroundWithBlock: completion];
}

@end
