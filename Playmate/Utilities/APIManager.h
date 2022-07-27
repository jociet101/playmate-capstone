//
//  APIManager.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

// Decathalon API
- (void)getSportsListWithCompletion:(void(^)(NSDictionary *list, NSError *error))completion;
- (void)getSportWithId:(NSString *)sportId withCompletion:(void(^)(NSDictionary *sportData, NSError *error))completion ;

// Geocoding API
- (void)getGeocodedLocation:(NSString *)address withCompletion:(void(^)(Location *loc, NSError *error))completion;
- (void)getReverseGeocodedLocation:(Location *)location withCompletion:(void(^)(NSString *name, NSError *error))completion;

// Apple Maps Link
+ (void)goToAddress:(Location *)location;

@end

NS_ASSUME_NONNULL_END
