//
//  CreateMenuViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "CreateMenuViewController.h"
#import "MenuPickerCell.h"
#import "LocationPickerCell.h"
#import "Constants.h"
#import "Helpers.h"
#import "Location.h"
#import "Session.h"
#import "SelectMapViewController.h"
#import "ManageUserStatistics.h"
#import "HomeViewController.h"

@interface CreateMenuViewController () <UITableViewDelegate, UITableViewDataSource, MenuPickerCellDelegate, SelectMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *createMenuIdentifiers;
@property (nonatomic, strong) NSMutableArray *tableCells;

// selected session details
@property (nonatomic, strong) NSString *selectedSport;
@property (nonatomic, strong) NSDate *selectedDateTime;
@property (nonatomic, assign) NSNumber *selectedDuration;
@property (nonatomic, strong) NSString *selectedSkillLevel;
@property (nonatomic, assign) NSNumber *selectedNumPlayers;
@property (nonatomic, strong) Location *selectedLocation;
@property (nonatomic, strong) UIButton * _Nullable selectLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *createSessionButton;

@end

@implementation CreateMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [Constants playmateBlue];

    self.tableView.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [Helpers setCornerRadiusAndColorForButton:self.createSessionButton andIsSmall:NO];
    
    self.createMenuIdentifiers = [Constants sportsList:NO];

    self.tableCells = [[NSMutableArray alloc] init];
    self.selectLocationButton = nil;
}

#pragma mark - Menu Picker Cell and Location Picker Cell protocol methods

- (void)setSport:(NSString *)sport {
    self.selectedSport = sport;
}

- (void)setDateTime:(NSDate *)date {
    self.selectedDateTime = date;
}

- (void)setDuration:(NSNumber *)duration {
    self.selectedDuration = duration;
}

- (void)setSkillLevel:(NSString *)level {
    self.selectedSkillLevel = level;
}

- (void)setNumberPlayers:(NSNumber *)players {
    self.selectedNumPlayers = players;
}

- (void)getSelectedLocation:(Location *)location {
    self.selectedLocation = location;
    [self.selectLocationButton setTitle:@"Selected Location" forState:UIControlStateNormal];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        LocationPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationPickerCell"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    MenuPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuPickerCell"];
    cell.rowNumber = [NSNumber numberWithLong:indexPath.row];
    [self.tableCells addObject:cell];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)didTapDone:(id)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Create session action

- (IBAction)didTapCreateSession:(id)sender {
    [self.createSessionButton setBackgroundColor:[Constants playmateBlueSelected]];
    if (self.selectedLocation == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"No location selected"
                 withMessage:[Constants selectLocationPlease]
           forViewController:self];
        return;
    } else if (self.selectedSport == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"No sport selected"
                 withMessage:[Constants selectSportPlease]
           forViewController:self];
        return;
    } else if (self.selectedDateTime == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"No date or time selected"
                 withMessage:[Constants selectDateTimePlease]
           forViewController:self];
        return;
    } else if (self.selectedDuration == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"No duration selected"
                 withMessage:[Constants selectDurationPlease]
           forViewController:self];
        return;
    } else if (self.selectedNumPlayers == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"Number of players not selected"
                 withMessage:[Constants selectNumberOfPlayersPlease]
           forViewController:self];
        return;
    } else if (self.selectedSkillLevel == nil) {
        [Helpers handleAlert:nil
                   withTitle:@"No skill level selected"
                 withMessage:[Constants selectSkillLevelPlease]
           forViewController:self];
        return;
    }
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    // create SportsSession parse object and save
    [Session createSession:me withSport:self.selectedSport withLevel:self.selectedSkillLevel withDate:self.selectedDateTime withDuration:self.selectedDuration withLocation:self.selectedLocation withCapacity:self.selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
        if (error) {
            [Helpers handleAlert:error withTitle:@"Could not create session." withMessage:nil forViewController:self];
        } else {
            [ManageUserStatistics updateDictionaryAddSession:[self fetchMostRecentSessionId]
                                                    forSport:self.selectedSport
                                                     andUser:me];
            [self returnToHome];
        }
    }];
}

- (void)returnToHome {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    HomeViewController *vc = [[homeVC viewControllers][0] childViewControllers][0];
    self.delegate = (id)vc;
    [self.delegate reloadHomeTabSessions];
    self.view.window.rootViewController = homeVC;
}

- (NSString *)fetchMostRecentSessionId {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    [query orderByDescending:@"updatedAt"];
    
    Session *session = [[query getFirstObject] fetchIfNeeded];
    return session.objectId;
}

- (IBAction)didTapCancel:(id)sender {
    if (self.selectLocationButton != nil) {
        self.selectedLocation = nil;
        [self.selectLocationButton setTitle:@"Select Location" forState:UIControlStateNormal];
    }
    
    // reset text fields
    for (MenuPickerCell *cell in self.tableCells) {
        cell.pickerField.text = @"";
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSelectLocation"]) {
        SelectMapViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        self.selectLocationButton = sender;
    }
}

@end
