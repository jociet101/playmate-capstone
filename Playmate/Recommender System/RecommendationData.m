//
//  RecommendationData.m
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import "RecommendationData.h"
#import "RecommenderSystem.h"
#import "ManageUserStatistics.h"
#import "Helpers.h"
#import "Strings.h"

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
    // Determine if user already has recommendation object
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    if ([me objectForKey:@"recommendation"] == nil) {
        // If not, need to create and save to user
        [RecommendationData createRecommendationDataWithCompletion:^(BOOL success, NSError * _Nonnull error) {
            if (error != nil) {
                [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
            } else {
                PFQuery *query = [PFQuery queryWithClassName:@"RecommendationData"];
                [query whereKey:@"userObjectId" equalTo:me.objectId];
                RecommendationData *data = [[query getFirstObject] fetchIfNeeded];
                [me addObject:data.objectId forKey:@"recommendation"];
                [me saveInBackground];
                [RecommendationData run:tookQuiz onData:data];
            }
        }];
    } else {
        // If so, fetch from user's dictionary and get object id of recommendation object
        RecommendationData *data = [[PFQuery getObjectOfClass:@"RecommendationData" objectId:me[@"recommendation"][0]] fetchIfNeeded];
        [RecommendationData run:tookQuiz onData:data];
    }
}

+ (void)run:(BOOL)tookQuiz onData:(RecommendationData *)data {
    if (!tookQuiz) {
        data.sessionCount = [NSNumber numberWithInt:([data.sessionCount intValue] + 1)];
    }
    
    // Check if user just joined a multiple of five session
    // If user just took quiz run algorithm regardless of which numbered session
    if ([data.sessionCount intValue] % 5 != 0 && !tookQuiz) {
        return;
    }
    
    // If so, we must run recommender algorithm to keep session suggestions updated
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
          ^{
              data.suggestedList = [RecommenderSystem runRecommendationAlgorithm];
              [data saveInBackground];
           });
}

@end
