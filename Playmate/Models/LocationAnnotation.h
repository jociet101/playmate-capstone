//
//  LocationAnnotation.h
//  
//
//  Created by Jocelyn Tseng on 7/16/22.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *locationName;

@end

NS_ASSUME_NONNULL_END
