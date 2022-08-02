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
#import "QuizHelpers.h"
#import "Strings.h"

@implementation RecommenderSystem

+ (NSArray *)runRecommendationAlgorithm {
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    // Query every single session
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    NSArray *sessions = [query findObjects];
    NSLog(@"ALL SESSIONS: %@", sessions);
    
    // Filter out sessions the user is already part of
    sessions = [RecommenderSystem filterOutSessions:sessions userIsInAlready:user];
    
    NSLog(@"USER IS NOT IN SESSIONS: %@", sessions);
    
    NSMutableArray *playSports = [[NSMutableArray alloc] init];
    NSArray * _Nullable genders = nil;
    NSArray * _Nullable ageGroups = nil;
    
    NSString *resultId = [user objectForKey:@"quizResult"][0];
    // If user has completed quiz
    if (resultId != nil) {
        QuizResult *result = [[PFQuery getObjectOfClass:@"QuizResult" objectId:resultId] fetchIfNeeded];
        
        // get genders and age groups list
        genders = [NSArray arrayWithArray:result.gendersList];
        ageGroups = [NSArray arrayWithArray:result.ageGroupsList];
        
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
    
    NSLog(@"VIABLE SESSIONS: %@", sessions);
    NSLog(@"PREFERRED SPORTS: %@", playSports);
    // Viable sessions are in sessions now
    
    // Preprocessing for weights for each sport based on user history and quiz preferences
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
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:user];
    NSArray *friendsList = playerConnection.friendsList;
    
    NSMutableDictionary *weightToSession = [[NSMutableDictionary alloc] init];
    
    // Iterate through all viable sessions
    for (Session *session in sessions) {
        float ranking = [RecommenderSystem getRankingForSession:session
                                                withSportWeight:[[sportWeights objectForKey:session.sport] intValue]
                                                     andGenders:genders
                                                   andAgeGroups:ageGroups
                                                     andFriends:friendsList];
        // Put session into dictionary with key being ranking
        NSNumber *number = [NSNumber numberWithFloat:ranking];
        if ([weightToSession objectForKey:number] == nil) {
            [weightToSession setObject:[[NSMutableArray alloc] init] forKey:number];
        } else {
            NSMutableArray *array = [weightToSession objectForKey:number];
            [array addObject:session.objectId];
        }
    }
    
    NSLog(@"session and rankings = %@", weightToSession);
    
    return sessions;
    
    // TODO: fine tune heuristic
//    // Get and sort the rankings (keys to the dictionary)
//    NSArray *numberKeys = [weightToSession allKeys];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
//    numberKeys = [numberKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
//
//    // Get the list of sessions
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    for (NSNumber *key in numberKeys) {
//        if (result.count >= 8) {
//            break;
//        }
//        NSArray *sessionsForThisKey = [weightToSession objectForKey:key];
//        result = (NSMutableArray *)[result arrayByAddingObjectsFromArray:sessionsForThisKey];
//    }
//
//    const long numberSessionsToFetch = MIN(8, result.count);
//
//    // return the top 8 ranked sessions
//    return (NSArray *)[result subarrayWithRange:NSMakeRange(0, numberSessionsToFetch)];
}

+ (NSArray *)filterOutSessions:(NSArray *)sessions userIsInAlready:(PFUser *)user {
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    for (Session *session in sessions) {
        NSArray *playerList = session.playersList;
        BOOL userIsNotIn = YES;
        for (PFUser *player in playerList) {
            if ([player.objectId isEqualToString:user.objectId]) {
                userIsNotIn = NO;
            }
            break;
        }
        if (userIsNotIn) {
            [filteredSessions addObject:session];
        }
    }
    return (NSArray *)filteredSessions;
}

+ (float)getRankingForSession:(Session *)session
              withSportWeight:(int)sportWeight
                   andGenders:(NSArray * _Nullable)genders
                 andAgeGroups:(NSArray * _Nullable)ageGroups
                   andFriends:(NSArray *)friends {
    NSArray *playerList = session.playersList;
    int numberFriendsInSession = 0;
    int numberPlayersInPreferredGenders = 0;
    int numberPlayersInPreferredAgeGroups = 0;
    
    // Calculate gender counts and age groups counts
    for (PFUser *player in playerList) {
        [player fetchIfNeeded];
        
        // Check if this player is a friend of user
        if ([friends containsObject:player.objectId]) {
            numberFriendsInSession += 1;
        }
        
        // See if gender is in preferred
        NSString *gender = player[@"gender"][0];
        if (genders != nil && [genders containsObject:gender]) {
            numberPlayersInPreferredGenders += 1;
        }
        
        // See if age is in preferred group
        int playerAge = [[Helpers getAgeInYears:player[@"birthday"][0]] intValue];
        if (ageGroups != nil && [RecommenderSystem ageIsInAGroup:playerAge givenGroups:ageGroups]) {
            numberPlayersInPreferredAgeGroups += 1;
        }
    }
    
    float ranking = 5.2 * sportWeight + 2.3 * numberFriendsInSession + 1.2 * numberPlayersInPreferredGenders + 1.9 * numberPlayersInPreferredAgeGroups;
    return ranking;
}

+ (BOOL)ageIsInAGroup:(int)age givenGroups:(NSArray *)ageGroups {
    NSString * _Nullable ageGroup = nil;
    NSArray *allAgeGroups = [QuizHelpers ageGroupList];
    
    if (age < 12) {
        ageGroup = allAgeGroups[0];
    } else if (age < 18) {
        ageGroup = allAgeGroups[1];
    } else if (age < 25) {
        ageGroup = allAgeGroups[2];
    } else if (age < 35) {
        ageGroup = allAgeGroups[3];
    } else if (age < 45) {
        ageGroup = allAgeGroups[4];
    } else if (age < 55) {
        ageGroup = allAgeGroups[5];
    } else if (age < 65) {
        ageGroup = allAgeGroups[6];
    } else if (age < 75) {
        ageGroup = allAgeGroups[7];
    } else {
        ageGroup = allAgeGroups[8];
    }
    
    return [ageGroups containsObject:ageGroup];
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
