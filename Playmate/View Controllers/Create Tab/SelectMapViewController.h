//
//  SelectMapViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectMapViewControllerDelegate

- (void)getSelectedLocation:(Location *)location;

@end

@interface SelectMapViewController : UIViewController

@property (weak, nonatomic) id<SelectMapViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
