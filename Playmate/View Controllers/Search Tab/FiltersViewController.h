//
//  FiltersViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FiltersViewControllerDelegate

- (void)didApplyFilters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
