//
//  CreateSessionViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "CreateSessionViewController.h"
#import "Session.h"
#import "Constants.h"
#import "SelectMapViewController.h"
#import "Location.h"

@interface CreateSessionViewController () <UIPickerViewDelegate, UIPickerViewDataSource, SelectMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *skillLevelControl;
@property (weak, nonatomic) IBOutlet UILabel *numPlayersLabel;
@property (weak, nonatomic) IBOutlet UIStepper *numPlayersStepper;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (nonatomic, strong) NSArray *sports;
@property (nonatomic, strong) NSString *selectedSport;
@property (nonatomic, strong) Location *selectedLoc;
@property (nonatomic, assign) int numPlayers;

@end

@implementation CreateSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sportPicker.delegate = self;
    self.sportPicker.dataSource = self;
    
    self.createButton.layer.cornerRadius = [Constants buttonCornerRadius];
    
    self.numPlayers = [Constants defaultNumPlayers];
    self.selectedSport = [Constants defaultSport];
    self.sports = [Constants sportsList:NO];
    
    // setup date time picker min date to current date
    // and max date to a month in advance
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setMonth:1];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];

    self.dateTimePicker.minimumDate = minDate;
    self.dateTimePicker.maximumDate = maxDate;
    
    // configure the stepper
    self.numPlayersStepper.minimumValue = 2;
    self.numPlayersStepper.maximumValue = 10;
    self.numPlayersStepper.wraps = YES;
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

#pragma mark - Buttons and actions

- (IBAction)didSelectCreateSession:(id)sender {
    
    NSArray *skillLevels = [Constants skillLevelsList:NO];
    NSDate *sessionDateTime = self.dateTimePicker.date;
    NSString *skillLevel = skillLevels[self.skillLevelControl.selectedSegmentIndex];
    NSNumber *selectedNumPlayers = [NSNumber numberWithInt:self.numPlayers];
    
    [Session createSession:[PFUser currentUser] withSport:self.selectedSport withLevel:skillLevel withDate:sessionDateTime withLocation:self.selectedLoc withCapacity:selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
            if (error) {
                NSLog(@"Error creating session: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully created the session");
            }
    }];
    
//    [Session createSession:[PFUser currentUser] withSport:self.selectedSport withLevel:skillLevel withDate:sessionDateTime withCapacity:selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
//
//        NSLog(@"inside create session");
//
//        if (error) {
//            NSLog(@"Error creating session: %@", error.localizedDescription);
//        }
//        else {
//            NSLog(@"Successfully created the session");
//        }
//    }];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.view.window.rootViewController = homeVC;
    
//    [self performSegueWithIdentifier:@"createdSession" sender:nil];
}

- (IBAction)stepperValueChanged:(id)sender {
    self.numPlayers = self.numPlayersStepper.value;
    self.numPlayersLabel.text = [NSString stringWithFormat:@"%d", self.numPlayers];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSelectLocation"]) {
        SelectMapViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
