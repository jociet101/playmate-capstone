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

// Error messages for session details
+ (NSString *)fullSessionErrorMsg;
+ (NSString *)alreadyInSessionErrorMsg;
+ (NSString *)noOpenSlotsErrorMsg;

// Information for session details
+ (NSString *)dateFormatString;
+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity;

// Information for home tab
+ (NSString *)emptyTablePlaceholderMsg;
+ (NSString *)emptyTablePlaceholderTitle;

// Information for profile tab
+ (NSString *)defaultBio;

// Some numbers
+ (int)buttonCornerRadius;

// Some colors
+ (UIColor *)playmateBlue;

@end

NS_ASSUME_NONNULL_END
