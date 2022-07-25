//
//  Constants.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"
#import "APIManager.h"

@implementation Constants

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

// For confetti on session details view
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

// Info for incoming friend notifications
+ (NSString *)acceptedConfirmationStringFor:(NSString *)name {
    return [NSString stringWithFormat:@"You are now friends with %@", name];
}

+ (NSString *)deniedConfirmationStringFor:(NSString *)name {
    return [NSString stringWithFormat:@"You denied %@'s friend request", name];
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
    [titles addObject:@"Session Scope"];
    
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
    } else if (row == 4) {
        return [Constants sessionTypeList];
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
    
    return [NSArray arrayWithArray:sports];
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
    
    return [NSArray arrayWithArray:sports];
}

+ (NSArray *)skillLevelsList:(BOOL)needAll {
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    if (needAll) [skillLevels addObject:@"All"];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    
    return [NSArray arrayWithArray:skillLevels];
}

+ (NSArray *)sessionTypeList {
    NSMutableArray *sessionTypes = [[NSMutableArray alloc] init];
    [sessionTypes addObject:@"All"];
    [sessionTypes addObject:@"Friends"];
    [sessionTypes addObject:@"Own"];
    
    return [NSArray arrayWithArray:sessionTypes];
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

+ (UIColor *)playmateBlueOpaque {
    return [UIColor colorWithRed: 0.90 green: 0.96 blue: 1 alpha: 1];
}

+ (UIColor *)playmateTealOpaque {
    return [UIColor colorWithRed: 0.05 green: 0.28 blue: 0.32 alpha: 1];
}

+ (UIColor *)playmateBlueSelected {
    return [UIColor colorWithRed: 0.76 green: 1 blue: 1 alpha: 0.7];
}

// playmate logo placeholder profile image

+ (UIImage *)profileImagePlaceholder {
    return [UIImage imageNamed:@"playmate_logo_fit"];
}

// for empty table view

+ (NSString *)emptyTablePlaceholderMsg {
    return @"Search for a session to join or create your own session to view them here!";
}

+ (NSString *)emptyTablePlaceholderTitle {
    return @"No Sessions";
}

+ (NSString *)emptyPlayerProfilesPlaceholderTitle {
    return @"No players in this session";
}

+ (NSString *)emptySearchPlaceholderMsg {
    return @"No sessions match your search. Adjust the filters or create your own session!";
}

+ (NSString *)emptyListPlaceholderMsg {
    return @"Explore sessions to meet your Playmates!";
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

+ (NSString *)emptyCollectionLoadingSessionsTitle {
    return @"Loading Sessions ...";
}

+ (NSString *)emptyCalendarTableForDate:(NSDate *)date {
    NSString *dateString = [Helpers formatDateNoTime:date];
    return [@"No sessions on " stringByAppendingString:dateString];
}

+ (NSString *)emptyInvitationsPlaceholderTitle {
    return @"No invitations";
}

+ (NSString *)emptyInvitationsPlaceholderMsg {
    return @"Check back later to see if your friends invited you to join their session!";
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
                                                    @"confetti",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",
                                                    @"playmate_logo_transparent",nil];
    
    NSDictionary *sportToImageName = [[NSDictionary alloc] initWithObjects:imageNames forKeys:[Constants sportsList:NO]];
    
    return sportToImageName[sport];
}

// for uiimage gifs
+ (NSArray *)addressGifImages {
    NSMutableArray *addressGifImages = [[NSMutableArray alloc] initWithCapacity:155];
    for (int i = 0; i < 155; i++) {
        [addressGifImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"address_%d", i]]];
    }
    return [NSArray arrayWithArray:addressGifImages];
}

+ (NSArray *)manualGifImages {
    NSMutableArray *manualGifImages = [[NSMutableArray alloc] initWithCapacity:93];
    for (int i = 0; i < 93; i++) {
        [manualGifImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%d", i]]];
    }
    return [NSArray arrayWithArray:manualGifImages];
}

+ (NSArray *)rollingPlaymateLogoGif {
    NSMutableArray *rollingGifImages = [[NSMutableArray alloc] initWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"playmate_logo_fit_%d", i]];
        [rollingGifImages addObject:[Helpers resizeImage:image withDimension:60]];
    }
    return [NSArray arrayWithArray:rollingGifImages];
}

@end
