//
//  FiltersViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "FiltersViewController.h"
#import "Constants.h"

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
    
    self.applyButton.layer.cornerRadius = [Constants buttonCornerRadius];
    
    selectedSport2 = @"All";
    
    // Pull sports from an api later
    sports2 = [[NSMutableArray alloc] init];
    [sports2 addObject:@"All"];
    [sports2 addObject:@"Tennis"];
    [sports2 addObject:@"Basketball"];
    [sports2 addObject:@"Golf"];
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
    
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    [skillLevels addObject:@"All"];
    
    Filters *filters = [Filters new];
    
    filters.sport = selectedSport2;
    filters.skillLevel = skillLevels[self.skillLevelControl.selectedSegmentIndex];
//    filters.originLoc =
    filters.radius = [NSNumber numberWithInt:[self.radiusLabel.text intValue]];
        
    if ([filters.sport isEqualToString:@"All"]) {
        filters.sport = nil;
    }
    if ([filters.skillLevel isEqualToString:@"All"]) {
        filters.skillLevel = nil;
    }
    
    // call delegate method so filters save on search tab vc
    [self.delegate didApplyFilters:filters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sliderValueChanged:(id)sender {
    self.radiusLabel.text = [NSString stringWithFormat:@"%1.0f", self.radiusSlider.value];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
