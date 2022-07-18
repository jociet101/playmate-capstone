//
//  Helpers.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpers : NSObject

+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension;
+ (NSString *)getTimeGivenDurationForSession:(Session *)session;

@end

NS_ASSUME_NONNULL_END
