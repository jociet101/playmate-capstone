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
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    NSArray *sessions = [query findObjects];
    NSLog(@"ALL SESSIONS: %@", sessions);
    
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
        
        NSLog(@"VIABLE SESSIONS: %@", sessions);
        
        // Add sports the user wants to play according to quiz
        [playSports addObjectsFromArray:result.playSportsList];
    }
    
    NSLog(@"PREFERRED SPORTS: %@", playSports);
    // Viable sessions are in sessions now
    
    // find list of sports user has played in before and user says they play
    NSMutableDictionary *sportWeights = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *sessionsDictionary = user[@"sessionsDictionary"][0];
    
    NSArray *sportList = [sessionsDictionary allKeys];
    for (NSString *sport in sportList) {
        NSArray *list = sessionsDictionary[sport];
        long weight = list.count;
        if ([playSports containsObject:sport]) {
            // Give higher weight to sport if user is part of it
            weight += 10;
        }
        [sportWeights setObject:[NSNumber numberWithLong:weight] forKey:sport];
    }
    
    
    // for session in viable sessions
        // get ranking for session
        // store somehow; dictionary? where key is value and value is list of sessions
    
    for (Session *session in sessions) {
        
    }
    
    // get at most the top 8
    
    // return the array
    return sessions;
}

+ (int)getRankingForSession:(Session *)session {
    return 0;
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

@end
