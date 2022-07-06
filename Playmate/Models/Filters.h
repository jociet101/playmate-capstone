//
//  Filters.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import <Foundation/Foundation.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Filters : NSObject

@property (nonatomic, strong) NSString * _Nullable sport;
@property (nonatomic, strong) Location *originLoc;
@property (nonatomic, strong) NSString * _Nullable skillLevel;
@property (nonatomic, strong) NSNumber *radius;

@end

NS_ASSUME_NONNULL_END
