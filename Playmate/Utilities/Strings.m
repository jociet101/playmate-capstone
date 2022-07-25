//
//  Strings.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/25/22.
//

#import "Strings.h"

@implementation Strings

#pragma mark - API Endpoints

+ (NSString *)geoapifyBaseURLString {
    return @"https://api.geoapify.com/v1/";
}

+ (NSString *)decathalonSportsListString {
    return @"https://sports.api.decathlon.com/sports";
}

+ (NSString *)decathalonOneSportString {
    return @"https://sports.api.decathlon.com/sports/:";
}

#pragma mark - Session Details

// Error messages
+ (NSString *)fullSessionErrorMsg {
    return @"Session is full";
}

+ (NSString *)alreadyInSessionErrorMsg {
    return @"Already in session";
}

+ (NSString *)noOpenSlotsErrorMsg {
    return @"No open slots";
}

// Strings based on value
+ (NSString *)dateFormatString {
    return @"E MMM d HH:mm:ss yyyy";
}

+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity {
    return [[NSString stringWithFormat:@"%d", [capacity intValue] - [occupied intValue]] stringByAppendingString:[@"/" stringByAppendingString:[[NSString stringWithFormat:@"%@", capacity] stringByAppendingString:@" open slots"]]];
}

@end
