//
//  Constants.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject

// For API
+ (NSString *)geoapifyBaseURLString;
+ (NSString *)decathalonSportsListString;

// For calendar
+ (NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                 fromDate:(NSDate *)date;

// Error messages for session details
+ (NSString *)fullSessionErrorMsg;
+ (NSString *)alreadyInSessionErrorMsg;
+ (NSString *)noOpenSlotsErrorMsg;

// Information for session details
+ (NSString *)dateFormatString;
+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity;
+ (NSString *)formatDate:(NSDate *)original;
+ (NSString *)formatDateShort:(NSDate *)original;

// Information for home tab
+ (NSString *)emptyTablePlaceholderMsg;
+ (NSString *)emptyTablePlaceholderTitle;

// Information for profile tab
+ (NSString *)defaultBio;

// Information for filters and create
+ (NSString *)createMenuTitle:(int)row;
+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row;
+ (NSArray *)durationListShort;
+ (NSNumber *)durationKeyToInteger:(int)key;

+ (NSString *)defaultAll;
+ (NSString *)defaultSport;
+ (NSArray *)sportsList:(BOOL)needAll;
+ (NSArray *)skillLevelsList:(BOOL)needAll;
+ (int)defaultNumPlayers;
+ (int)defaultSkillPickerIndex;

// Some numbers
+ (int)buttonCornerRadius;

// Some colors
+ (UIColor *)playmateBlue;

@end

NS_ASSUME_NONNULL_END
