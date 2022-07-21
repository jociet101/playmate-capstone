//
//  Helpers.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Session.h"
#import "PlayerConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpers : NSObject

// For Parse
+ (PlayerConnection *)getPlayerConnectionForUser:(PFUser *)user;

// For API endpoints
+ (NSString *)geoapifyGeocodingURLWithKey:(NSString *)geoapify andCraftedLink:(NSString *)craftedLink;
+ (NSString *)geoapifyReverseGeocodingURLWithKey:(NSString *)geoapify andLongitutde:(NSString *)longitutde andLatitude:(NSString *)latitude;

+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension;
+ (NSString *)getTimeGivenDurationForSession:(Session *)session;

// For handling alerts
+ (void)handleAlert:(NSError * _Nullable)error
          withTitle:(NSString *)title
        withMessage:(NSString * _Nullable)message
  forViewController:(id)viewController;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime
                     andDate:(NSDate*)toDateTime;

// for buttons
+ (void)setCornerRadiusAndColorForButton:(UIButton *)button andIsSmall:(BOOL)isSmall;

// For rotating an image
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees;

@end

NS_ASSUME_NONNULL_END
