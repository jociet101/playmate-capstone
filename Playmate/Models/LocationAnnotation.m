//
//  LocationAnnotation.m
//  
//
//  Created by Jocelyn Tseng on 7/16/22.
//

#import "LocationAnnotation.h"

@interface LocationAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation LocationAnnotation

- (NSString *)title {
    return self.locationName;
}

@end
