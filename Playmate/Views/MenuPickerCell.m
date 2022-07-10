//
//  MenuPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "MenuPickerCell.h"
#import "Constants.h"

@interface MenuPickerCell () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

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
    self.pickerField.returnKeyType = UIReturnKeyDone;
    self.pickerField.delegate = self;
    [self.pickerField setKeyboardType:UIKeyboardTypeNumberPad];
}

- (void)dateTimePickerSetup {
    UIDatePicker *pickerView = [UIDatePicker new];
    [pickerView setPreferredDatePickerStyle:UIDatePickerStyleWheels];
    [pickerView setMinuteInterval:15];
    
    // set minimum and maximum dates for picker
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setMonth:1];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];

    pickerView.minimumDate = minDate;
    pickerView.maximumDate = maxDate;
    
    // setup detection in change of value
    [pickerView addTarget:self action:@selector(dateIsSelected:) forControlEvents:UIControlEventValueChanged];
    
    self.pickerField.inputView = pickerView;
}

- (void)dateIsSelected:(id)sender {
    // send date data back to create menu vc
    UIDatePicker *picker = sender;
    
    NSDate *selectedDate = picker.date;
    self.pickerField.text = [Constants formatDateShort:selectedDate];
    
    [self.delegate setDateTime:picker.date];
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
    
    switch (self.thisRow) {
        case 2:
            self.pickerField.text = [Constants durationListShort][row-1];
            [self.delegate setDuration:[Constants durationKeyToInteger:(int)(row-1)]];
            break;
        case 3:
            [self.delegate setSkillLevel:self.selectedData];
            self.pickerField.text = self.selectedData;
            break;
        case 0:
            [self.delegate setSport:self.selectedData];
            self.pickerField.text = self.selectedData;
            break;
    }
}

#pragma mark - Text field delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.thisRow == 4) {
        [self.delegate setNumberPlayers:[NSNumber numberWithInt:[self.pickerField.text intValue]]];
        [self.pickerField endEditing:YES];
    }
    return YES;
}

@end
