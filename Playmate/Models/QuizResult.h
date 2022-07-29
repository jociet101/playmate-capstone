//
//  QuizResult.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuizResult : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSArray *playSportsList;
@property (nonatomic, strong) NSArray *dontPlaySportsList;
@property (nonatomic, strong) NSArray *gendersList;
@property (nonatomic, strong) NSArray *ageGroupsList;

+ (void)saveQuizResultWithSports:(NSArray *)sports
                    andNotSports:(NSArray *)notSports
                      andGenders:(NSArray *)genders
                         andAges:(NSArray *)ages
                  withCompletion:(void(^)(BOOL success, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
