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
#import "Location.h"
#import "Session.h"
#import "SelectMapViewController.h"

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

@end

@implementation CreateMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.layer.cornerRadius = [Constants buttonCornerRadius];
    
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

- (void)handleAlert:(NSError * _Nullable)error withTitle:(NSString *)title andOk:(NSString *)ok {
    
    NSString *msg = [Constants selectLocationPlease];
    
    if (error != nil) {
        msg = error.localizedDescription;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self viewDidLoad];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated: YES completion: nil];
}

- (IBAction)didTapCreateSession:(id)sender {
    if (self.selectedLocation == nil) {
        [self handleAlert:nil withTitle:@"No location" andOk:@"Ok"];
        return;
    }

    [Session createSession:[PFUser currentUser] withSport:self.selectedSport withLevel:self.selectedSkillLevel withDate:self.selectedDateTime withDuration:self.selectedDuration withLocation:self.selectedLocation withCapacity:self.selectedNumPlayers withCompletion:^(BOOL succeeded, NSError* error) {
        
            if (error) {
                NSLog(@"Error creating session: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully created the session");
            }
    }];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.view.window.rootViewController = homeVC;
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
