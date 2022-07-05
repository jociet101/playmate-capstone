//
//  CreateSessionViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "CreateSessionViewController.h"
#import "Session.h"

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
    
    numPlayers = 2;
    
    // Pull sports from an api later
    sports = [[NSMutableArray alloc] init];
    [sports addObject:@"Tennis"];
    [sports addObject:@"Basketball"];
    [sports addObject:@"Golf"];
    
    // setup date time picker min date to current date
    // and max date to a month in advance
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setMonth:1];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
//    [comps release];

    self.dateTimePicker.minimumDate = minDate;
    self.dateTimePicker.maximumDate = maxDate;
    
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
    
    NSLog(@"did select create session");
    
    NSMutableArray *skillLevels = [[NSMutableArray alloc] init];
    [skillLevels addObject:@"Leisure"];
    [skillLevels addObject:@"Amateur"];
    [skillLevels addObject:@"Competitive"];
    
    // selectedSport
    NSDate *sessionDateTime = self.dateTimePicker.date;
    NSString *skillLevel = skillLevels[self.skillLevelControl.selectedSegmentIndex];
    NSNumber *selectedNumPlayers = [NSNumber numberWithInt:numPlayers];
    
//    [Session createSession:[PFUser currentUser] withSport:selectedSport withLevel:skillLevel withDate:sessionDateTime withLocation:nil withCapacity:selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
//            if (error) {
//                NSLog(@"Error creating session: %@", error.localizedDescription);
//            }
//            else {
//                NSLog(@"Successfully created the session");
//            }
//    }];
    
    [Session createSession:[PFUser currentUser] withSport:selectedSport withLevel:skillLevel withDate:sessionDateTime withCapacity:selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
        
        NSLog(@"inside create session");
        
        if (error) {
            NSLog(@"Error creating session: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Successfully created the session");
        }
    }];
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
