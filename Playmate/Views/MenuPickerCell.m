//
//  MenuPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "MenuPickerCell.h"
#import "Constants.h"

@interface MenuPickerCell () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pickerField;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSString *selectedData;
@property (assign, nonatomic) int thisRow;

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
    self.thisRow = [rowNumber intValue];
    
    _rowNumber = rowNumber;
    
    /*
     [titles addObject:@"Sport"];
     [titles addObject:@"Date and Time"];
     [titles addObject:@"Duration"];
     [titles addObject:@"Skill Level"];
     [titles addObject:@"Number of Players"];
     [titles addObject:@"Location"];
     */
    
    self.menuLabel.text = [Constants createMenuTitle:self.thisRow];
    
    switch (self.thisRow) {
        case 1: // date and time
            [self dateTimePickerSetup];
            break;
        case 4: // number of players
            [self numPlayersSetup];
            break;
        default: // sport, duration, skill level
            [self pickerViewSetup];
        }
}

- (void)numPlayersSetup {
    
}

- (void)dateTimePickerSetup {
    UIDatePicker *pickerView = [UIDatePicker new];
    [pickerView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    self.pickerField.inputView = pickerView;
}

#pragma mark - Picker view methods

- (void)pickerViewSetup {
    UIPickerView *pickerView = [UIPickerView new];
    self.pickerField.inputView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    self.pickerData = [Constants getData:NO forRow:self.thisRow];
}

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

#pragma mark - Text field delegate method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIPickerView *pickerView = [UIPickerView new];
    textField.inputView = pickerView;
}

@end
