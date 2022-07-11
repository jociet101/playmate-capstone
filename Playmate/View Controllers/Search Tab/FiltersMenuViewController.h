//
//  FiltersMenuViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/10/22.
//

#import <UIKit/UIKit.h>
#import "Filters.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FiltersMenuViewControllerDelegate

- (void)didApplyFilters:(Filters *)filters;

@end

@interface FiltersMenuViewController : UIViewController

@property (nonatomic, weak) id<FiltersMenuViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
