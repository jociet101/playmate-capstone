//
//  RecommenderSystem.h
//
//  ***Information about Playmate's Recommender System lies in MORE_README.md***
//
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "RecommendationData.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommenderSystem : NSObject

+ (NSArray *)runRecommendationAlgorithm;

@end

NS_ASSUME_NONNULL_END
