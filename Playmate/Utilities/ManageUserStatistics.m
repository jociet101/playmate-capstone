//
//  ManageUserStatistics.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import "ManageUserStatistics.h"
#import "Helpers.h"

@implementation ManageUserStatistics

// Add one session object id to user's session dictionary's sport array
+ (void)updateDictionaryAddSession:(NSString *)objectId
                          forSport:(NSString *)sport
                           andUser:(PFUser *)user {
    
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    
    // check if user has sessions dictionary
    if (sessionsDictionary == nil) {
        // if not, initialize dictionary and array
        sessionsDictionary = [[NSMutableDictionary alloc] init];
        NSArray *sportListForDictionary = [NSArray arrayWithObject:objectId];
        [sessionsDictionary setObject:sportListForDictionary forKey:sport];
    } else {
        [user removeObjectForKey:@"sessionsDictionary"];
        NSMutableArray *sportListForDictionary = [sessionsDictionary objectForKey:sport];
        
        // check if user has participated in this sport before
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

+ (void)updateDictionaryRemoveSession:(NSString *)objectId
                             forSport:(NSString *)sport
                              andUser:(PFUser *)user {
    
    // Get dictionary, sport array from dictionary, remove object id, and save
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    [user removeObjectForKey:@"sessionsDictionary"];
    NSMutableArray *sportListForDictionary = [sessionsDictionary objectForKey:sport];
    [sessionsDictionary removeObjectForKey:sport];
    [sportListForDictionary removeObject:objectId];
    [sessionsDictionary setObject:sportListForDictionary forKey:sport];
    [user addObject:sessionsDictionary forKey:@"sessionsDictionary"];
    [user saveInBackground];
}

+ (long)getNumberTotalSessionsForUser:(PFUser *)user {
    NSMutableDictionary *sessionsDictionary = [user objectForKey:@"sessionsDictionary"][0];
    
    if (sessionsDictionary == nil) {
        return 0;
    } else {
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

+ (NSString *)getNumberDaysOnPlaymateForUser:(PFUser *)user {
    NSDate *joinedDate = user.createdAt;
    NSInteger timeAgo = [Helpers daysBetweenDate:joinedDate andDate:[NSDate now]];
    return [NSString stringWithFormat:@"%ld", timeAgo];
}

@end
