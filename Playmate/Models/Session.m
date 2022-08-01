//
//  Session.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "Session.h"
#import "Location.h"

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
    return [@"Sports" stringByAppendingString:NSStringFromClass([Session class])];
}

+ (void) createSession: (PFUser * _Nullable)user
             withSport: (NSString * _Nullable)spt
             withLevel: (NSString * _Nullable)level
              withDate: (NSDate * _Nullable)date
          withDuration: (NSNumber * _Nullable)duration
          withLocation:(PFObject * _Nullable)loc
          withCapacity:(NSNumber * _Nullable)cap
        withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Session *newSession = [Session new];
    newSession.sport = spt;
    newSession.skillLevel = level;
    newSession.creator = user;
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    [tempList addObject:[PFUser currentUser]];
    newSession.playersList = (NSArray *)tempList;
    newSession.occursAt = date;
    newSession.duration = duration;
    newSession.location = (Location *)loc;
    newSession.capacity = cap;
    newSession.occupied = @(1);
    
    [newSession saveInBackgroundWithBlock:completion];
}

@end
