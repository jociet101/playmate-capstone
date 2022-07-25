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

// For calendar
+ (NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                 fromDate:(NSDate *)date;

// Information for session details
+ (NSArray *)listOfSystemColors;

// Info for incoming friend notifications
+ (NSString *)acceptedConfirmationStringFor:(NSString *)name;
+ (NSString *)deniedConfirmationStringFor:(NSString *)name;

// Information for profile tab
+ (NSString *)defaultBio;

// Information for filters and create
+ (NSString *)createMenuTitle:(int)row;
+ (NSString *)createFiltersMenuTitle:(int)row;

+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row;
+ (NSArray * _Nullable)getFilterData:(BOOL)needAll forRow:(int)row;
+ (NSArray *)durationListShort;
+ (NSNumber *)durationKeyToInteger:(int)key;

+ (NSString *)defaultAll;
+ (NSString *)defaultSport;
+ (NSArray *)sportsListLarge:(BOOL)needAll;
+ (NSArray *)sportsList:(BOOL)needAll;
+ (NSArray *)skillLevelsList:(BOOL)needAll;
+ (NSArray *)sessionTypeList;

+ (int)defaultNumPlayers;
+ (int)defaultSkillPickerIndex;

// Some numbers
+ (int)buttonCornerRadius;
+ (int)smallButtonCornerRadius;

// Some colors
+ (UIColor *)playmateBlue;
+ (UIColor *)playmateBlueOpaque;
+ (UIColor *)playmateTealOpaque;
+ (UIColor *)playmateBlueSelected;

+ (UIImage *)profileImagePlaceholder;

+ (NSDictionary *)descriptionAttributes;
+ (NSDictionary *)titleAttributes;

// for home view
+ (NSString *)getImageNameForSport:(NSString *)sport;

// for uiimage gifs
+ (NSArray *)addressGifImages;
+ (NSArray *)manualGifImages;
+ (NSArray *)rollingPlaymateLogoGif;

@end

NS_ASSUME_NONNULL_END
