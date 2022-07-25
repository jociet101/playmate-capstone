//
//  Helpers.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Session.h"
#import "PlayerConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpers : NSObject

#pragma mark - Parse Related
+ (PlayerConnection *)getPlayerConnectionForUser:(PFUser *)user;

#pragma mark - API Endpoints
+ (NSString *)geoapifyGeocodingURLWithKey:(NSString *)geoapify andCraftedLink:(NSString *)craftedLink;
+ (NSString *)geoapifyReverseGeocodingURLWithKey:(NSString *)geoapify andLongitutde:(NSString *)longitutde andLatitude:(NSString *)latitude;

#pragma mark - Handling Alerts
+ (void)handleAlert:(NSError * _Nullable)error
          withTitle:(NSString *)title
        withMessage:(NSString * _Nullable)message
  forViewController:(id)viewController;

#pragma mark - Button UI
+ (void)setCornerRadiusAndColorForButton:(UIButton *)button andIsSmall:(BOOL)isSmall;

#pragma mark - Image Manipulation
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees;
+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension;

#pragma mark - Miscellaneous Helper Methods

// Given a list of players that are PFUsers, returns set of object id strings for those players
+ (NSMutableSet *)getPlayerObjectIdSet:(NSArray *)playerList;

// Given a user, returns list of a max size three of most frequent sports for sessions the user attends
+ (NSArray *)getTopSportsFor:(PFUser *)user;

// Returns number of days between two dates
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime
                     andDate:(NSDate*)toDateTime;

// Return time string interval for a session given start time and duration
+ (NSString *)getTimeGivenDurationForSession:(Session *)session;

@end

NS_ASSUME_NONNULL_END
