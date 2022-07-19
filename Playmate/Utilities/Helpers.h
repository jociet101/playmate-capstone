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

@end

NS_ASSUME_NONNULL_END
