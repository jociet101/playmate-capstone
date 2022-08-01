//
//  RecommenderSystem.h
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import <Foundation/Foundation.h>
#import "RecommendationData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommenderSystem : NSObject

+ (NSArray *)runRecommendationAlgorithm;

@end

NS_ASSUME_NONNULL_END
