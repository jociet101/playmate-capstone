//
//  Location.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "Location.h"

@implementation Location

@dynamic lat;
@dynamic lng;
@dynamic locationName;

+ (nonnull NSString *)parseClassName {
    return NSStringFromClass([Location class]);
}

+ (void)saveLocation:(Location *)location {
    [location saveInBackground];
}

@end
