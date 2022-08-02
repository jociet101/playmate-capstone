//
//  ManageUserStatistics.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageUserStatistics : NSObject

// Add the session to the user's session history dictionary
+ (void)updateDictionaryAddSession:(NSString *)objectId
                          forSport:(NSString *)sport
                           andUser:(PFUser *)user;

// Remove the session from the user's session history dictionary
+ (void)updateDictionaryRemoveSession:(NSString *)objectId
                             forSport:(NSString *)sport
                              andUser:(PFUser *)user;

// Calculate total number of past and upcoming sessions user has for profile tab
+ (long)getNumberTotalSessionsForUser:(PFUser *)user;

// Calculate number of days user has been on playmate for profile tab
+ (NSString *)getNumberDaysOnPlaymateForUser:(PFUser *)user;

// Used when deleting session
+ (void)removeSession:(NSString *)sessionId ofSport:(NSString *)sport fromUser:(PFUser *)user;

// Given a user, returns list of a max size three of most frequent sports for sessions the user attends
+ (NSArray *)getTopSportsFor:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
