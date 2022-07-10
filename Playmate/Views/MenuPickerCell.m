//
//  MenuPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "MenuPickerCell.h"
#import "Constants.h"

@interface MenuPickerCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *pickerField;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSString *selectedData;

@end

@implementation MenuPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRowNumber:(NSNumber *)rowNumber {
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    
    _rowNumber = rowNumber;
    
    self.menuLabel.text = [Constants createMenuTitle:[rowNumber intValue]];
    self.pickerData = [Constants getData:NO forRow:[rowNumber intValue]];
    
    UIPickerView *pickerView = [UIPickerView new];
    self.pickerField.inputView = pickerView;
}

#pragma mark - Picker view methods

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedData = self.pickerData[row];
}

@end
