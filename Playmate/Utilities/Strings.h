//
//  Strings.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/25/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Strings : NSObject

#pragma mark - API Endpoints
+ (NSString *)geoapifyBaseURLString;
+ (NSString *)decathalonSportsListString;
+ (NSString *)decathalonOneSportString;

#pragma mark - Session Details
// Error messages
+ (NSString *)fullSessionErrorMsg;
+ (NSString *)alreadyInSessionErrorMsg;
+ (NSString *)noOpenSlotsErrorMsg;
// Strings based on value
+ (NSString *)dateFormatString;
+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity;

#pragma mark -

@end

NS_ASSUME_NONNULL_END
