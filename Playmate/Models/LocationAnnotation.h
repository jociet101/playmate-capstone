//
//  LocationAnnotation.h
//  
//
//  Created by Jocelyn Tseng on 7/16/22.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) Session *session;

@end

NS_ASSUME_NONNULL_END
