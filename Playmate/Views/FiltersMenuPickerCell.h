//
//  FiltersMenuPickerCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FiltersMenuPickerCellDelegate

- (void)setSport:(NSString *)sport;
- (void)setSkillLevel:(NSString *)level;
- (void)setRadius:(NSNumber *)radius;

@end

@interface FiltersMenuPickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *pickerField;
@property (nonatomic, strong) NSNumber *rowNumber;

- (void)setRowNumber:(NSNumber *)rowNumber;

@property (nonatomic, weak) id<FiltersMenuPickerCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
