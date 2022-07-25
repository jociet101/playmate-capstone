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

#pragma mark - Dates
+ (NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
                 fromDate:(NSDate *)date;

#pragma mark - Strings with parameters
+ (NSString *)acceptedConfirmationStringFor:(NSString *)name;
+ (NSString *)deniedConfirmationStringFor:(NSString *)name;

#pragma mark - Filter Menu Labels
+ (NSString *)createMenuTitle:(int)row;
+ (NSString *)createFiltersMenuTitle:(int)row;
// Duration
+ (NSArray *)durationList;
+ (NSArray *)durationListShort;
+ (NSNumber *)durationKeyToInteger:(int)key;
// Sport
+ (NSArray *)sportsListLarge:(BOOL)needAll;
+ (NSArray *)sportsList:(BOOL)needAll;
// Skill level
+ (NSArray *)skillLevelsList:(BOOL)needAll;
// Session scope
+ (NSArray *)sessionTypeList;

#pragma mark - Numbers
+ (int)buttonCornerRadius;
+ (int)smallButtonCornerRadius;

#pragma mark - Colors
+ (NSArray *)listOfSystemColors;
+ (UIColor *)playmateBlue;
+ (UIColor *)playmateBlueOpaque;
+ (UIColor *)playmateTealOpaque;
+ (UIColor *)playmateBlueSelected;

#pragma mark - Empty View Text Properties
+ (NSDictionary *)descriptionAttributes;
+ (NSDictionary *)titleAttributes;

#pragma mark - Gifs and Images
+ (UIImage *)profileImagePlaceholder;
+ (NSString *)getImageNameForSport:(NSString *)sport;
+ (NSArray *)addressGifImages;
+ (NSArray *)manualGifImages;
+ (NSArray *)rollingPlaymateLogoGif;

@end

NS_ASSUME_NONNULL_END
