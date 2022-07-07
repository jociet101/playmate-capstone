//
//  FiltersViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "FiltersViewController.h"
#import "Constants.h"
#import "SelectMapViewController.h"
#import "Location.h"

@interface FiltersViewController () <UIPickerViewDelegate, UIPickerViewDataSource, SelectMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillLevelControl;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) NSArray *sports;
@property (nonatomic, strong) NSString *selectedSport;
@property (nonatomic, strong) Location *selectedLoc;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    
    self.applyButton.layer.cornerRadius = [Constants buttonCornerRadius];
    
    self.selectedSport = [Constants defaultAll];
    self.sports = [Constants sportsList:YES];
    
    self.skillLevelControl.selectedSegmentIndex = [Constants defaultSkillPickerIndex];
}

#pragma mark - Location map protocol method

- (void)getSelectedLocation:(Location *)location {
    self.locationLabel.text = location.locationName;
    
    self.selectedLoc = location;
}

#pragma mark - Sport picker view

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.sports.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.sports[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedSport = self.sports[row];
}

#pragma mark - Apply filters and send information to search vc

- (IBAction)didTapApply:(id)sender {
    
    NSArray *skillLevels = [Constants skillLevelsList:YES];
    
    Filters *filters = [Filters new];
    
    filters.location = self.selectedLoc;
    filters.sport = self.selectedSport;
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

//- (IBAction)didTapClose:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSelectLocation"]) {
        SelectMapViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
