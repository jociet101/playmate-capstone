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

@end

NS_ASSUME_NONNULL_END
