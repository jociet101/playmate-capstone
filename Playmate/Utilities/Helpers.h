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
+ (void)roundCornersOfImage:(UIImageView *)image;

#pragma mark - Date Formatting
+ (NSString *)formatDate:(NSDate *)original;
+ (NSString *)formatDateShort:(NSDate *)original;
+ (NSString *)formatDateNoTime:(NSDate *)original;
+ (NSString *)appendAgoToTime:(NSDate *)timeAgo;

#pragma mark - Profile Tab and Friend Notifications
+ (NSString *)concatenateFirstName:(NSString *)first andLast:(NSString *)last;
+ (NSString *)getAgeInYears:(NSDate *)date;
+ (NSString *)outgoingRequestMessageFor:(PFUser *)user;
+ (NSString *)incomingRequestMessageFor:(PFUser *)user;

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

// Return capacity string fraction
+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity;

// String for empty events on given date
+ (NSString *)emptyCalendarTableForDate:(NSDate *)date;

// String for details label on player collection cell
+ (NSString *)getDetailsLabelForPlayerCell:(PFUser *)user;

#pragma mark - Retrieve Data for Filter/Create Menus
+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row;
+ (NSArray * _Nullable)getFilterData:(BOOL)needAll forRow:(int)row;

@end

NS_ASSUME_NONNULL_END
