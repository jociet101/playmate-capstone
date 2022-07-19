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

+ (void)updateDictionaryWithSport:(NSString *)sport forSession:(NSString *)objectId andUser:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
