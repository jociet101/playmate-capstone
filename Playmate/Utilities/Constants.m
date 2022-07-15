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

// For calendar

+ (NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                 fromDate:(NSDate *)date
{
   NSCalendar *calendar = [NSCalendar currentCalendar];
   NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                                         NSCalendarUnitMonth|
                                                         NSCalendarUnitDay
                                               fromDate:date];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
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

+ (NSString *)formatDate:(NSDate *)original {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    NSString *originalDate = [formatter stringFromDate:original];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)formatDateShort:(NSDate *)original {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    NSString *originalDate = [formatter stringFromDate:original];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:date];
}

// Information for profile tab
+ (NSString *)defaultBio {
    return @"Edit profile to enter a bio!";
}

+ (NSString *)concatenateFirstName:(NSString *)first andLast:(NSString *)last {
    return [first stringByAppendingString:[@" " stringByAppendingString:last]];
}

+ (NSString *)getAgeInYears:(NSDate *)date {
    NSString *rawYears = [date timeAgoSinceNow];
    NSArray *parsed = [rawYears componentsSeparatedByString:@" "];
    NSString *year = parsed[0];
    return year;
}

// Information for filters and create
+ (NSString *)createMenuTitle:(int)row {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    [titles addObject:@"Sport"];
    [titles addObject:@"Date and Time"];
    [titles addObject:@"Duration"];
    [titles addObject:@"Skill Level"];
    [titles addObject:@"Number of Players"];
    [titles addObject:@"Location"];
    
    return titles[row];
}

+ (NSString *)createFiltersMenuTitle:(int)row {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    [titles addObject:@"Sport"];
    [titles addObject:@"Skill Level"];
    [titles addObject:@"Location"];
    [titles addObject:@"Radius (in miles)"];
    
    return titles[row];
}

+ (NSString *)selectLocationPlease {
    return @"Please select a location on map.";
}

+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row {
        
    if (row == 0) {
        return [Constants sportsList:needAll];
    }  else if (row == 2) {
        return [Constants durationList];
    } else if (row == 3) {
        return [Constants skillLevelsList:needAll];
    }
    return nil;
}

+ (NSArray * _Nullable)getFilterData:(BOOL)needAll forRow:(int)row {
        
    if (row == 0) {
        return [Constants sportsList:needAll];
    } else if (row == 1) {
        return [Constants skillLevelsList:needAll];
    }
    return nil;
}

+ (NSArray *)durationList {
    NSMutableArray *durations = [[NSMutableArray alloc] init];
    
    [durations addObject:@"30 minutes"];
    [durations addObject:@"45 minutes"];
    [durations addObject:@"1 hour"];
    [durations addObject:@"1 hour, 15 minutes"];
    [durations addObject:@"1 hour, 30 minutes"];
    [durations addObject:@"1 hour, 45 minutes"];
    [durations addObject:@"2 hours"];
    [durations addObject:@"2 hours, 15 minutes"];
    [durations addObject:@"2 hours, 30 minutes"];
    [durations addObject:@"2 hours, 45 minutes"];
    [durations addObject:@"3 hours"];
    
    return (NSArray *)durations;
}

+ (NSArray *)durationListShort {
    NSMutableArray *durations = [[NSMutableArray alloc] init];
    
    [durations addObject:@"30 min"];
    [durations addObject:@"45 min"];
    [durations addObject:@"1 hr"];
    [durations addObject:@"1 hr, 15 min"];
    [durations addObject:@"1 hr, 30 min"];
    [durations addObject:@"1 hr, 45 min"];
    [durations addObject:@"2 hr"];
    [durations addObject:@"2 hr, 15 min"];
    [durations addObject:@"2 hr, 30 min"];
    [durations addObject:@"2 hr, 45 min"];
    [durations addObject:@"3 hr"];
    
    return (NSArray *)durations;
}

+ (NSNumber *)durationKeyToInteger:(int)key {
//    return @(((float)key)/4 + 0.5);
    NSMutableArray *durations = [[NSMutableArray alloc] init];

    [durations addObject:@(0.5)];
    [durations addObject:@(0.75)];
    [durations addObject:@(1)];
    [durations addObject:@(1.25)];
    [durations addObject:@(1.5)];
    [durations addObject:@(1.75)];
    [durations addObject:@(2)];
    [durations addObject:@(2.25)];
    [durations addObject:@(2.5)];
    [durations addObject:@(2.75)];
    [durations addObject:@(3)];

    return durations[key];
}

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

+ (int)smallButtonCornerRadius {
    return 12;
}

// some colors
+ (UIColor *)playmateBlue {
    return [UIColor colorWithRed: 0.31 green: 0.78 blue: 0.94 alpha: 0.30];
}

// for resizing images

+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension {
    
    CGSize size = CGSizeMake(dimension, dimension);
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dimension, dimension)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// playmate logo placeholder profile image

+ (UIImage *)profileImagePlaceholder {
    return [UIImage imageNamed:@"playmate_logo_transparent"];
}

// for empty table view

+ (NSString *)emptyTablePlaceholderMsg {
    return @"Search for a session to join or create your own session to view them here!";
}

+ (NSString *)emptyTablePlaceholderTitle {
    return @"No Sessions";
}

+ (NSString *)emptySearchPlaceholderMsg {
    return @"No sessions match your search. Adjust the filters or create your own session!";
}

+ (NSString *)emptyListPlaceholderMsg {
    return @"Create or join sessions to meet your Playmates!";
}

+ (NSString *)emptyListPlaceholderTitle {
    return @"No Friends";
}

+ (NSString *)emptyRequestsPlaceholderMsg {
    return @"";
}

+ (NSString *)emptyRequestsPlaceholderTitle {
    return @"No Incoming Friend Requests";
}

+ (NSString *)emptyOutgoingRequestsPlaceholderTitle {
    return @"No Outgoing Friend Requests";
}

@end
