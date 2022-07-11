//
//  Session.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Session : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *sport;
@property (nonatomic, strong) NSString *skillLevel;
@property (nonatomic, strong) PFUser *creator;
@property (nonatomic, strong) NSArray *playersList;
@property (nonatomic, strong) NSDate *occursAt;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSNumber *occupied;

+ (void) createSession: (PFUser * _Nullable)user withSport: (NSString * _Nullable)spt withLevel: (NSString * _Nullable)level withDate: (NSDate * _Nullable)date withDuration: (NSNumber * _Nullable)duration withLocation:(PFObject * _Nullable)loc withCapacity:(NSNumber * _Nullable)cap withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
