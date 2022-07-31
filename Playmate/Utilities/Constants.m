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

#pragma mark - Dates
+ (NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                 fromDate:(NSDate *)date {
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

#pragma mark - Strings with parameters

+ (NSString *)acceptedConfirmationStringFor:(NSString *)name {
    return [NSString stringWithFormat:@"You are now friends with %@", name];
}

+ (NSString *)deniedConfirmationStringFor:(NSString *)name {
    return [NSString stringWithFormat:@"You denied %@'s friend request", name];
}


#pragma mark - Filter Menu Pickers

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

// Duration
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

// Sport
+ (NSArray *)sportsListLarge:(BOOL)needAll {
    NSMutableArray *sports = [[NSMutableArray alloc] init];
    
    if (needAll) [sports addObject:[Strings defaultAll]];
    
    APIManager *manager = [APIManager new];
    [manager getSportsListWithCompletion:^(NSDictionary *list, NSError *error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
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
        [sports addObject:[Strings defaultAll]];
    }
    
    NSArray *sportsList = [NSArray arrayWithObjects:@"Archery",
                                                    @"Badminton",
                                                    @"Baseball",
                                                    @"Basketball",
                                                    @"Boxing",
                                                    @"Bowling",
                                                    @"Cricket",
                                                    @"Cycling",
                                                    @"Fencing",
                                                    @"Football",
                                                    @"Field Hockey",
                                                    @"Golf",
                                                    @"Ice Hockey",
                                                    @"Soccer",
                                                    @"Softball",
                                                    @"Table Tennis",
                                                    @"Tennis",
                                                    @"Ultimate Frisbee",
                                                    @"Volleyball",
                                                    @"Water Polo",
                                                    @"Wrestling", nil];
    [sports addObjectsFromArray:sportsList];
    
    return [NSArray arrayWithArray:sports];
}

// Skill Level
+ (NSArray *)skillLevelsList:(BOOL)needAll {
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    if (needAll) [skillLevels addObject:[Strings defaultAll]];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    
    return [NSArray arrayWithArray:skillLevels];
}

// Session Scope
+ (NSArray *)sessionTypeList {
    NSMutableArray *sessionTypes = [[NSMutableArray alloc] init];
    [sessionTypes addObject:[Strings defaultAll]];
    [sessionTypes addObject:@"Friends"];
    [sessionTypes addObject:@"Own"];
    return [NSArray arrayWithArray:sessionTypes];
}

#pragma mark - Create Account Pickers

+ (NSArray *)gendersList {
    NSMutableArray *genders = [[NSMutableArray alloc] init];
    [genders addObject:@"Female"];
    [genders addObject:@"Male"];
    [genders addObject:@"Non-binary"];
    return (NSArray *)genders;
}


#pragma mark - Numbers

+ (int)buttonCornerRadius {
    return 20;
}

+ (int)smallButtonCornerRadius {
    return 12;
}

+ (int)tinyButtonCornerRadius {
    return 9;
}

+ (int)invitationsRowHeight {
    return 132;
}

#pragma mark - Colors

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

#pragma mark - Empty View Text Properties

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


#pragma mark - Gifs and Images

+ (UIImage *)profileImagePlaceholder {
    return [UIImage imageNamed:@"playmate_logo_fit"];
}

+ (UIImage *)smallPlaymateLogo {
    return [UIImage imageNamed:@"logo_small"];
}

+ (NSString *)getImageNameForSport:(NSString *)sport {
//    NSArray *imageNames = [NSArray arrayWithObjects:@"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent",
//                                                    @"playmate_logo_transparent", nil];
//
//    NSDictionary *sportToImageName = [[NSDictionary alloc] initWithObjects:imageNames forKeys:[Constants sportsList:NO]];
//
//    return sportToImageName[sport];
    return @"playmate_logo_transparent";
}

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
