//
//  MenuPickerCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MenuPickerCellDelegate <NSObject>

- (void)setSport:(NSString *)sport;
- (void)setDateTime:(NSDate *)date;
- (void)setDuration:(NSInteger *)durationKey;
- (void)setSkillLevel:(NSString *)level;
- (void)setNumberPlayers:(NSInteger *)players;

@end

@interface MenuPickerCell : UITableViewCell

@property (nonatomic, strong) NSNumber *rowNumber;

- (void)setRowNumber:(NSNumber *)rowNumber;

@end

NS_ASSUME_NONNULL_END
