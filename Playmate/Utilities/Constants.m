//
//  Constants.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import "Constants.h"
#import "APIManager.h"

@interface Constants ()

@end

@implementation Constants

// For API
+ (NSString *)geoapifyBaseURLString {
    return @"https://api.geoapify.com/v1/";
}

+ (NSString *)decathalonSportsListString {
    return @"https://sports.api.decathlon.com/sports";
}

// Error messages for session details
+ (NSString *)fullSessionErrorMsg {
    return @"Session is full";
}

+ (NSString *)alreadyInSessionErrorMsg {
    return @"Already in session";
}

+ (NSString *)noOpenSlotsErrorMsg {
    return @"No open slots";
}

// Information for session details
+ (NSString *)dateFormatString {
    return @"E MMM d HH:mm:ss yyyy";
}

+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity {
    return [[NSString stringWithFormat:@"%d", [capacity intValue] - [occupied intValue]] stringByAppendingString:[@"/" stringByAppendingString:[[NSString stringWithFormat:@"%@", capacity] stringByAppendingString:@" open slots"]]];
}

// Information for home tab
+ (NSString *)emptyTablePlaceholderMsg {
    return @"Search for a session to join or create your own session to view them here!";
}

+ (NSString *)emptyTablePlaceholderTitle {
    return @"No Sessions";
}

// Information for profile tab
+ (NSString *)defaultBio {
    return @"Edit profile to enter a bio!";
}

// Information for filters and create
+ (NSString *)defaultAll {
    return @"All";
}

+ (NSString *)defaultSport {
    return @"Tennis";
}

+ (NSArray *)sportsList:(BOOL)needAll {
    
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    
    // TODO: Need to debug this for getting all sports later
    /*
    APIManager *manager = [APIManager new];
    [manager getSportsListWithCompletion:^(NSDictionary *list, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSArray *data = list[@"data"];

            for (NSDictionary *datum in data) {
                NSString *sport = [NSString stringWithString:datum[@"attributes"][@"name"]];

                NSString *sportType = [NSString stringWithFormat:@"%@", [sport class]];

                if ([sportType isEqualToString:@"NSTaggedPointerString"]) {
                    [sports addObject:sport];
                }
            }
        }
    }];

    NSLog(@"%@", sports);
    */
    
    if (needAll) {
        [sports addObject:@"All"];
    }
    
    [sports addObject:@"Tennis"];
    [sports addObject:@"Basketball"];
    [sports addObject:@"Golf"];
    return (NSArray *)sports;
}

+ (NSArray *)skillLevelsList:(BOOL)needAll {
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    if (needAll) [skillLevels addObject:@"All"];
    
    return (NSArray *)skillLevels;
}

+ (int)defaultNumPlayers {
    return 2;
}

+ (int)defaultSkillPickerIndex {
    return 3;
}

// Some numbers
+ (int)buttonCornerRadius {
    return 20;
}

// some colors
+ (UIColor *)playmateBlue {
    return [UIColor colorWithRed: 0.31 green: 0.78 blue: 0.94 alpha: 0.30];
}


@end
