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

+ (void)createRecommendationData {
    RecommendationData *data = [RecommendationData new];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    data.userObjectId = user.objectId;
    data.suggestedList = [[NSArray alloc] init];
    
    [data saveInBackground];
}

@end
