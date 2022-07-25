//
//  Location.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : PFObject<PFSubclassing>

@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSString *locationName;

+ (void)saveLocation:(Location *)location;

@end

NS_ASSUME_NONNULL_END
