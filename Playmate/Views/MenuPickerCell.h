//
//  MenuPickerCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuPickerCell : UITableViewCell

@property (nonatomic, strong) NSNumber *rowNumber;

- (void)setRowNumber:(NSNumber *)rowNumber;

@end

NS_ASSUME_NONNULL_END
