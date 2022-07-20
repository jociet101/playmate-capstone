//
//  MapFiltersViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "MapFilters.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MapFiltersViewControllerDelegate

- (void)didApplyFilters:(MapFilters *)filter;

@end

@interface MapFiltersViewController : UIViewController

@property (nonatomic, strong) id<MapFiltersViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
