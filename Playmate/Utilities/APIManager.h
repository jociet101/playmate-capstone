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

- (void)getSportsListWithCompletion:(void(^)(NSDictionary *list, NSError *error))completion;
- (void)getGeocodedLocation:(NSString *)address withCompletion:(void(^)(Location *loc, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
