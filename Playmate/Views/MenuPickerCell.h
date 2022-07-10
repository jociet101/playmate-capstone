//
//  MenuPickerCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MenuPickerCellDelegate

- (void)setSport:(NSString *)sport;
- (void)setDateTime:(NSDate *)date;
- (void)setDuration:(NSNumber *)duration;
- (void)setSkillLevel:(NSString *)level;
- (void)setNumberPlayers:(NSNumber *)players;

@end

@interface MenuPickerCell : UITableViewCell

@property (nonatomic, strong) NSNumber *rowNumber;

- (void)setRowNumber:(NSNumber *)rowNumber;

@property (nonatomic, weak) id<MenuPickerCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
