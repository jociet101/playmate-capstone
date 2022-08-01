//
//  RecommendationData.m
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import "RecommendationData.h"
#import "RecommenderSystem.h"
#import "ManageUserStatistics.h"

@implementation RecommendationData

@dynamic userObjectId;
@dynamic suggestedList;
@dynamic sessionCount;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([RecommendationData class]);
}

+ (void)createRecommendationDataWithCompletion:(void(^)(BOOL success, NSError *error))completion {
    RecommendationData *data = [RecommendationData new];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    data.userObjectId = user.objectId;
    data.suggestedList = [[NSArray alloc] init];
    data.sessionCount = [NSNumber numberWithInt:1];
    
    [data saveInBackgroundWithBlock:completion];
}

+ (void)runRecommenderSystemJustTookQuiz:(BOOL)tookQuiz {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    RecommendationData *data = [[PFQuery getObjectOfClass:@"RecommendationData" objectId:me[@"recommendationObjectId"] error:nil] fetchIfNeeded];
    
    if (!tookQuiz) {
        data.sessionCount = [NSNumber numberWithInt:([data.sessionCount intValue] + 1)];
    }
    
    // Check if user just joined a multiple of five session
    if ([data.sessionCount intValue] % 5 != 0 && !tookQuiz) {
        return;
    }
    
    // If so, we must run recommender algorithm to keep session suggestions updated
    data.suggestedList = [RecommenderSystem runRecommendationAlgorithm];
    [data saveInBackground];
}

@end
