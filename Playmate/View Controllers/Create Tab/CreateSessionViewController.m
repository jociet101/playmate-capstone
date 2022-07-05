//
//  CreateSessionViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "CreateSessionViewController.h"

@interface CreateSessionViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillLevelControl;
@property (weak, nonatomic) IBOutlet UILabel *numPlayersLabel;
@property (weak, nonatomic) IBOutlet UIStepper *numPlayersStepper;

@end

@implementation CreateSessionViewController

NSMutableArray *sports;
NSString *selectedSport;
int numPlayers;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    
    // Pull sports from an api later
    sports = [[NSMutableArray alloc] init];
    [sports addObject:@"Tennis"];
    [sports addObject:@"Basketball"];
    [sports addObject:@"Golf"];
    
    self.numPlayersStepper.minimumValue = 2;
    self.numPlayersStepper.maximumValue = 10;
    self.numPlayersStepper.wraps = YES;
}

#pragma mark - Sport picker view

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return sports.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return sports[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedSport = sports[row];
    
    // TODO: consider adding feature such that according to selected sport
    // TODO: set default number of players
}

#pragma mark - Buttons and actions

- (IBAction)didTapSelectMap:(id)sender {
    [self performSegueWithIdentifier:@"selectOnMap" sender:nil];
}

- (IBAction)didSelectCreateSession:(id)sender {
    
    NSArray *skillLevels = {@"Leisure", @"Amateur", @"Competitive"};
    
    // selectedSport
    NSDate *sessionDateTime = self.dateTimePicker.date;
    NSString *skillLevel = skillLevels[self.skillLevelControl.selectedSegmentIndex];
}

- (IBAction)stepperValueChanged:(id)sender {
    numPlayers = self.numPlayersStepper.value;
    self.numPlayersLabel.text = [NSString stringWithFormat:@"%d", numPlayers];
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
