//
//  FiltersMenuPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/10/22.
//

#import "FiltersMenuPickerCell.h"
#import "Constants.h"

@interface FiltersMenuPickerCell () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *menuLabel;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSString *selectedData;
@property (assign, nonatomic) int thisRow;

@end

@implementation FiltersMenuPickerCell

- (void)setRowNumber:(NSNumber *)rowNumber {
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    self.thisRow = [rowNumber intValue];
    
    _rowNumber = rowNumber;
    
    self.menuLabel.text = [Constants createFiltersMenuTitle:self.thisRow];
    
    switch (self.thisRow) {
        case 3: // radius for normal filters
            [self radiusSetup];
            break;
        default: // sport and skill level and session scope
            [self pickerViewSetup];
    }
}

- (void)radiusSetup {
    self.pickerField.tintColor = [UIColor lightGrayColor];
    self.pickerField.returnKeyType = UIReturnKeyDone;
    self.pickerField.delegate = self;
    [self.pickerField setKeyboardType:UIKeyboardTypeNumberPad];
}

#pragma mark - Picker view methods

- (void)pickerViewSetup {
    
    UIPickerView *pickerView = [UIPickerView new];
    self.pickerField.inputView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    self.pickerData = [Constants getFilterData:YES forRow:self.thisRow];
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
    
    switch (self.thisRow) {
        case 0:
            [self.delegate setSport:self.selectedData];
            self.pickerField.text = self.selectedData;
            break;
        case 1:
            [self.delegate setSkillLevel:self.selectedData];
            self.pickerField.text = self.selectedData;
            break;
        case 4:
            [self.delegate setSessionType:self.selectedData];
            self.pickerField.text = self.selectedData;
            break;
    }
}

#pragma mark - Text field delegate method

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.thisRow == 3) {
        [self.delegate setRadius:[NSNumber numberWithInt:[self.pickerField.text intValue]]];
        [self.pickerField endEditing:YES];
    }
}

@end
