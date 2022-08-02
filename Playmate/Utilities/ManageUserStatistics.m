//
//  ManageUserStatistics.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import "ManageUserStatistics.h"
#import "Helpers.h"

@implementation ManageUserStatistics

// Add the session to the user's session history dictionary
+ (void)updateDictionaryAddSession:(NSString *)objectId
                          forSport:(NSString *)sport
                           andUser:(PFUser *)user {
    
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    
    // Check if user has sessions dictionary
    if (sessionsDictionary == nil) {
        // If not, initialize dictionary and array and add session to that sport
        sessionsDictionary = [[NSMutableDictionary alloc] init];
        NSArray *sportListForDictionary = [NSArray arrayWithObject:objectId];
        [sessionsDictionary setObject:sportListForDictionary forKey:sport];
    } else {
        // If so, retrieve dictionary
        [user removeObjectForKey:@"sessionsDictionary"];
        NSMutableArray *sportListForDictionary = [sessionsDictionary objectForKey:sport];
        
        // Check if user has participated in this sport before
        // Then add session to sport list and to dictionary corresponding to key sport
        if (sportListForDictionary == nil) {
            sportListForDictionary = [NSMutableArray arrayWithObject:objectId];
        } else {
            [sessionsDictionary removeObjectForKey:sport];
            [sportListForDictionary addObject:objectId];
        }
        [sessionsDictionary setObject:sportListForDictionary forKey:sport];
    }
    
    [user addObject:sessionsDictionary forKey:@"sessionsDictionary"];
    [user saveInBackground];
}

// Remove the session from the user's session history dictionary
+ (void)updateDictionaryRemoveSession:(NSString *)objectId
                             forSport:(NSString *)sport
                              andUser:(PFUser *)user {
    
    // Get dictionary to be edited
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    [user removeObjectForKey:@"sessionsDictionary"];
    
    // Get array to be edited according to key sport
    NSMutableArray *sportListForDictionary = [sessionsDictionary objectForKey:sport];
    [sessionsDictionary removeObjectForKey:sport];
    
    // Remove the session's objectid from list
    [sportListForDictionary removeObject:objectId];
    
    // Reverse operations and put objects back into dictionary
    [sessionsDictionary setObject:sportListForDictionary forKey:sport];
    [user addObject:sessionsDictionary forKey:@"sessionsDictionary"];
    [user saveInBackground];
}

// Calculate total number of past and upcoming sessions user has for profile tab
+ (long)getNumberTotalSessionsForUser:(PFUser *)user {
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    
    // If no sessions, return 0 automatically
    if (sessionsDictionary == nil) {
        return 0;
    }
    // Iterate through array of dictionaries and array at each sport
    else {
        long count = 0;
        NSArray *sportsKeys = [sessionsDictionary allKeys];
        
        for (NSString *sport in sportsKeys) {
            NSMutableArray *sportList = sessionsDictionary[sport];
            count += sportList.count;
        }
        return count;
    }
    return 0;
}

// Calculate number of days user has been on playmate for profile tab
+ (NSString *)getNumberDaysOnPlaymateForUser:(PFUser *)user {
    NSDate *joinedDate = user.createdAt;
    // Add 1 since we want to include current day as one day
    // Ex. if user joins today, we want to display 1 instead of 0
    NSInteger timeAgo = [Helpers daysBetweenDate:joinedDate andDate:[NSDate now]]+1;
    return [NSString stringWithFormat:@"%ld", timeAgo];
}

// Used when deleting session
+ (void)removeSession:(NSString *)sessionId ofSport:(NSString *)sport fromUser:(PFUser *)user {
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    NSMutableArray *sportArray = [sessionsDictionary objectForKey:sport];
    [sessionsDictionary removeObjectForKey:sport];
    [sportArray removeObject:sessionId];
    [sessionsDictionary setObject:sportArray forKey:sport];
}

// Given a user, returns list of a max size three of most frequent sports for sessions the user attends
+ (NSArray *)getTopSportsFor:(PFUser *)user {
    NSMutableDictionary *sportsCountDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *sportsDictionary = user[@"sessionsDictionary"][0];
    NSArray *sportsList = [sportsDictionary allKeys];
    
    for (NSString *sport in sportsList) {
        NSNumber *count = [NSNumber numberWithLong:((NSArray *)sportsDictionary[sport]).count];
        NSMutableArray *sportsListForCount = [sportsCountDictionary objectForKey:count];
        if (sportsListForCount == nil) {
            sportsListForCount = [NSMutableArray arrayWithObject:sport];
            [sportsCountDictionary setObject:sportsListForCount forKey:count];
        } else {
            [sportsCountDictionary removeObjectForKey:count];
            [sportsListForCount addObject:sport];
            [sportsCountDictionary setObject:sportsListForCount forKey:count];
        }
    }
    
    NSArray *countKeys = [sportsCountDictionary allKeys];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    countKeys = [countKeys sortedArrayUsingDescriptors:@[sortDescriptor]];
        
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSNumber *count in countKeys) {
        if (result.count >= 3) {
            break;
        }
        NSArray *sportsForThisCount = [sportsCountDictionary objectForKey:count];
        result = (NSMutableArray *)[result arrayByAddingObjectsFromArray:sportsForThisCount];
    }
    
    const long numberSportsToFetch = MIN(3, result.count);
    
    return [result subarrayWithRange:NSMakeRange(0, numberSportsToFetch)];
}

@end
