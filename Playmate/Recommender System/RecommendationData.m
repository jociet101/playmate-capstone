//
//  RecommendationData.m
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import "RecommendationData.h"

@implementation RecommendationData

@dynamic userObjectId;
@dynamic suggestedList;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([RecommendationData class]);
}

+ (void)createRecommendationDataWithCompletion:(void(^)(BOOL success, NSError *error))completion {
    RecommendationData *data = [RecommendationData new];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    data.userObjectId = user.objectId;
    data.suggestedList = [[NSArray alloc] init];
    
    [data saveInBackgroundWithBlock:completion];
}

+ (void)update:(RecommendationData *)data suggestedList:(NSArray *)list {
    data.suggestedList = list;
    [data saveInBackground];
}

@end
