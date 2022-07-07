//
//  APIManager.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

- (void)getGeocodedLocation:(NSString *)address WithCompletion:(void(^)(NSDictionary *addys, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
