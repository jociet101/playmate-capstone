//
//  LocationPickerCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import <UIKit/UIKit.h>
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LocationPickerCellDelegate

- (void)setLocation:(Location *)location;

@end

@interface LocationPickerCell : UITableViewCell

@property (nonatomic, strong) NSNumber *rowNumber;

- (void)setRowNumber:(NSNumber *)rowNumber;

@property (nonatomic, weak) id<LocationPickerCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
