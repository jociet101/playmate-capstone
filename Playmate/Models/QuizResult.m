//
//  QuizResult.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "QuizResult.h"

@implementation QuizResult

@dynamic userObjectId;
@dynamic playSportsList;
@dynamic dontPlaySportsList;
@dynamic gendersList;
@dynamic ageGroupsList;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([QuizResult class]);
}

+ (void)saveQuizResultWithSports:(NSArray *)sports
                    andNotSports:(NSArray *)notSports
                      andGenders:(NSArray *)genders
                         andAges:(NSArray *)ages
                  withCompletion:(void(^)(BOOL success, NSError *error))completion {
    QuizResult *result = [QuizResult new];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    result.userObjectId = user.objectId;
    result.playSportsList = sports;
    result.dontPlaySportsList = notSports;
    result.gendersList = genders;
    result.ageGroupsList = ages;
    
    [result saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            completion(YES, nil);
        } else {
            completion(nil, error);
        }
    }];
}

@end
