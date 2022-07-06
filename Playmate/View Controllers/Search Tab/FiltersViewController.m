//
//  FiltersViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "FiltersViewController.h"

@interface FiltersViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillLevelControl;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;

@end

@implementation FiltersViewController

NSMutableArray *sports2;
NSString *selectedSport2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    
    self.applyButton.layer.cornerRadius = 20;
    
    selectedSport2 = @"Tennis";
    
    // Pull sports from an api later
    sports2 = [[NSMutableArray alloc] init];
    [sports2 addObject:@"Tennis"];
    [sports2 addObject:@"Basketball"];
    [sports2 addObject:@"Golf"];
    
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    
    NSString *skillLevel = skillLevels[self.skillLevelControl.selectedSegmentIndex];
}

#pragma mark - Sport picker view

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return sports2.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return sports2[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedSport2 = sports2[row];
}

#pragma mark - Apply filters and send information to search vc

- (IBAction)didTapApply:(id)sender {
    // plan: call this once "apply filters" button is pressed
    // and search view controller is automatically brought to
    NSLog(@"calling apply filters %@", self.delegate);
    [self.delegate didApplyFilters];
}

- (IBAction)sliderValueChanged:(id)sender {
    self.radiusLabel.text = [NSString stringWithFormat:@"%1.0f", self.radiusSlider.value];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
