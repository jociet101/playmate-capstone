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
    self.pickerField.tintColor = [UIColor lightGrayColor];
}

- (void)dateTimePickerSetup {
    UIDatePicker *pickerView = [UIDatePicker new];
    [pickerView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [pickerView setMinuteInterval:15];
    
    // setup detection in change of value
    [pickerView addTarget:self action:@selector(dateIsSelected:) forControlEvents:UIControlEventValueChanged];
    
    self.pickerField.inputView = pickerView;
}

- (void)dateIsSelected:(id)sender {
    // send date data back to create menu vc
    UIDatePicker *picker = sender;
    
    NSDate *selectedDate = picker.date;
    self.pickerField.text = [Constants formatDateShort:selectedDate];
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
    return self.pickerData.count + 1;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        return @"";
    }
    
    return self.pickerData[row-1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
        self.pickerField.text = @"";
        return;
    }
    
    self.selectedData = self.pickerData[row-1];
    
    if (self.thisRow == 2) {
        self.pickerField.text = [Constants durationListShort][row-1];
        
    } else {
        self.pickerField.text = self.selectedData;
    }
}

#pragma mark - Text field delegate method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIPickerView *pickerView = [UIPickerView new];
    textField.inputView = pickerView;
}

@end
