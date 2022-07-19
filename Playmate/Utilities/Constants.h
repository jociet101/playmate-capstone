//
//  Constants.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject

// For API
+ (NSString *)geoapifyBaseURLString;
+ (NSString *)decathalonSportsListString;
+ (NSString *)decathalonOneSportString;

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
+ (NSArray *)listOfSystemColors;

// Information for profile tab
+ (NSString *)defaultBio;
+ (NSString *)concatenateFirstName:(NSString *)first andLast:(NSString *)last;
+ (NSString *)getAgeInYears:(NSDate *)date;

// Information for filters and create
+ (NSString *)createMenuTitle:(int)row;
+ (NSString *)createFiltersMenuTitle:(int)row;

+ (NSString *)selectLocationPlease;
+ (NSString *)selectDurationPlease;
+ (NSString *)selectSportPlease;
+ (NSString *)selectDateTimePlease;
+ (NSString *)selectSkillLevelPlease;
+ (NSString *)selectNumberOfPlayersPlease;

+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row;
+ (NSArray * _Nullable)getFilterData:(BOOL)needAll forRow:(int)row;
+ (NSArray *)durationListShort;
+ (NSNumber *)durationKeyToInteger:(int)key;

+ (NSString *)defaultAll;
+ (NSString *)defaultSport;
+ (NSArray *)sportsListLarge:(BOOL)needAll;
+ (NSArray *)sportsList:(BOOL)needAll;
+ (NSArray *)skillLevelsList:(BOOL)needAll;
+ (int)defaultNumPlayers;
+ (int)defaultSkillPickerIndex;

// Some numbers
+ (int)buttonCornerRadius;
+ (int)smallButtonCornerRadius;

// Some colors
+ (UIColor *)playmateBlue;

+ (UIImage *)profileImagePlaceholder;

// for empty table views
+ (NSString *)emptyTablePlaceholderMsg;
+ (NSString *)emptyTablePlaceholderTitle;
+ (NSString *)emptySearchPlaceholderMsg;
+ (NSString *)emptyListPlaceholderMsg;
+ (NSString *)emptyListPlaceholderTitle;
+ (NSString *)emptyIncomingRequestsPlaceholderTitle;
+ (NSString *)emptyOutgoingRequestsPlaceholderTitle;
+ (NSDictionary *)descriptionAttributes;
+ (NSDictionary *)titleAttributes;

// for home view
+ (NSString *)getImageNameForSport:(NSString *)sport;

// for select location help view
+ (NSArray *)addressGifImages;
+ (NSArray *)manualGifImages;

@end

NS_ASSUME_NONNULL_END
