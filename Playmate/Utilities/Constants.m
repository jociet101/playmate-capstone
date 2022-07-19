//
//  Constants.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import "Constants.h"
#import "APIManager.h"
#import "Helpers.h"

@implementation Constants

// For API
+ (NSString *)geoapifyBaseURLString {
    return @"https://api.geoapify.com/v1/";
}

+ (NSString *)decathalonSportsListString {
    return @"https://sports.api.decathlon.com/sports";
}

+ (NSString *)decathalonOneSportString {
    return @"https://sports.api.decathlon.com/sports/:";
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

+ (NSArray *)listOfSystemColors {
    return [NSArray arrayWithObjects:[UIColor systemPinkColor],
                                     [UIColor systemRedColor],
                                     [UIColor systemBlueColor],
                                     [UIColor systemCyanColor],
                                     [UIColor systemMintColor],
                                     [UIColor systemGreenColor],
                                     [UIColor systemOrangeColor],
                                     [UIColor systemPurpleColor],
                                     [UIColor systemYellowColor],
                                     [UIColor systemGrayColor], nil];
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
+ (NSString *)selectDurationPlease {
    return @"Please select a duration.";
}
+ (NSString *)selectSportPlease {
    return @"Please select a sport.";
}
+ (NSString *)selectDateTimePlease {
    return @"Please select a date and time.";
}
+ (NSString *)selectSkillLevelPlease {
    return @"Please select a skill level.";
}
+ (NSString *)selectNumberOfPlayersPlease {
    return @"Please select the number of players.";
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

+ (NSArray *)sportsListLarge:(BOOL)needAll {
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    
    if (needAll) [sports addObject:@"All"];
    
    APIManager *manager = [APIManager new];
    [manager getSportsListWithCompletion:^(NSDictionary *list, NSError *error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        } else {
            NSArray *data = list[@"data"];
            
            for (NSDictionary *datum in data) {
                
                NSString *sport = [NSString stringWithFormat:@"%@", datum[@"attributes"][@"name"]];
                [sports addObject:sport];
            }
        }
    }];
    
    return (NSArray *)sports;
}

+ (NSArray *)sportsList:(BOOL)needAll {
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    
    if (needAll) {
        [sports addObject:@"All"];
    }
    
    NSArray *sportsList = [NSArray arrayWithObjects:@"American football",
                                                    @"Badminton",
                                                    @"Baseball",
                                                    @"Basketball",
                                                    @"Boxing",
                                                    @"Bowling",
                                                    @"Cricket",
                                                    @"Ice Hockey",
                                                    @"Flag Football",
                                                    @"Field Hockey",
                                                    @"Golf",
                                                    @"Ice Hockey",
                                                    @"MMA",
                                                    @"Soccer",
                                                    @"Table Tennis",
                                                    @"Tennis",
                                                    @"Ultimate Frisbee",
                                                    @"Volleyball",
                                                    @"Wrestling", nil];
    
    [sports addObjectsFromArray:sportsList];
    
    return (NSArray *)sports;
}

+ (NSArray *)skillLevelsList:(BOOL)needAll {
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    if (needAll) [skillLevels addObject:@"All"];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    
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

+ (NSString *)emptyIncomingRequestsPlaceholderTitle {
    return @"No Incoming Friend Requests";
}

+ (NSString *)emptyOutgoingRequestsPlaceholderTitle {
    return @"No Outgoing Friend Requests";
}

+ (NSDictionary *)descriptionAttributes {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *descriptionAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return descriptionAttributes;
}

+ (NSDictionary *)titleAttributes {
    NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return titleAttributes;
}

// for home view
+ (NSString *)getImageNameForSport:(NSString *)sport {
    NSArray *imageNames = [NSArray arrayWithObjects:@"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",nil];
    
    NSDictionary *sportToImageName = [[NSDictionary alloc] initWithObjects:imageNames forKeys:[Constants sportsList:NO]];
    
    return sportToImageName[sport];
}

@end
