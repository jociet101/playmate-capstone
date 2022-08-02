//
//  RecommenderSystem.m
//  Playmate
//
//  Created by Jocelyn Tseng on 8/1/22.
//

#import "RecommenderSystem.h"
#import "QuizResult.h"
#import "Session.h"
#import "Helpers.h"
#import "Strings.h"

@implementation RecommenderSystem

+ (NSArray *)runRecommendationAlgorithm {
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    // query every single session
    __block NSArray *sessions;
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        } else {
            sessions = objects;
        }
    }];
    
    NSMutableArray *playSports = [[NSMutableArray alloc] init];
    
    NSString *resultId = [user objectForKey:@"quizResult"][0];
    // If user has completed quiz
    if (resultId != nil) {
        QuizResult *result = [[PFQuery getObjectOfClass:@"QuizResult" objectId:resultId] fetchIfNeeded];
        
        // filter by location
        Location *location = result.location;
        sessions = [RecommenderSystem filterSessions:sessions withLocation:location andRadius:[NSNumber numberWithInt:50]];
        
        NSArray *dontPlaySports = result.dontPlaySportsList;
        NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
        
        // filter out sports the user does not play
        for (Session *session in sessions) {
            if (![dontPlaySports containsObject:session.sport]) {
                [filteredSessions addObject:session];
            }
        }
        sessions = (NSArray *)filteredSessions;
        
        // Add sports the user wants to play according to quiz
        [playSports addObjectsFromArray:result.playSportsList];
    }
    
    // Viable sessions are in sessions now
    
    // find list of sports user has played in before and user says they play
    NSMutableDictionary *sportsCount = [[NSMutableDictionary alloc] init];
    
    // for session in viable sessions
        // get ranking for session
        // store somehow; dictionary? where key is value and value is list of sessions
    
    // get at most the top 8
    
    // return the array
    return [[NSArray alloc] init];
}

+ (NSArray *)filterSessions:(NSArray *)sessions withLocation:(Location *)location andRadius:(NSNumber *)radiusInMiles {
    float radiusInUnits = [radiusInMiles floatValue]/69;
    
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    
    for (Session *session in sessions) {
        float distance = [Helpers euclideanDistanceBetween:location and:session.location];
                
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:session.occursAt];
        
        if (distance <= radiusInUnits && result == NSOrderedAscending) {
            [filteredSessions addObject:session];
        }
    }
    return (NSArray *)filteredSessions;
}

+ (int)getRankingForSession:(Session *)session {
    return 0;
}

@end
