//
//  RecommenderSystem.m
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import "RecommenderSystem.h"
#import "Session.h"

@implementation RecommenderSystem

+ (NSArray *)runRecommendationAlgorithm {
    
    // query every single session
    // filter by location
    
    // check if user completed quiz
        // filter out dont play sports
        // filter in do play sports
    
    // should have smaller pool here
    
    // for session in viable sessions
        // get ranking for session
        // store somehow; dictionary? where key is value and value is list of sessions
    
    // get at most the top 8
    
    // return the array
    return [[NSArray alloc] init];
}

+ (int)getRankingForSession:(Session *)session {
    return 0;
}

@end
