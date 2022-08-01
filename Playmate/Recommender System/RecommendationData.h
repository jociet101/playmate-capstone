//
//  RecommendationData.h
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendationData : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSArray *suggestedList;

+ (void)createRecommendationData;

@end

NS_ASSUME_NONNULL_END
