//
//  FiltersMenuViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/10/22.
//

#import "FiltersMenuViewController.h"
#import "FiltersMenuPickerCell.h"
#import "LocationPickerCell.h"
#import "Constants.h"
#import "SelectMapViewController.h"
#import "Location.h"

@interface FiltersMenuViewController () <UITableViewDelegate, UITableViewDataSource, FiltersMenuPickerCellDelegate, SelectMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *createMenuIdentifiers;

// selected session details
@property (nonatomic, strong) NSString *selectedSport;
@property (nonatomic, strong) NSString *selectedSkillLevel;
@property (nonatomic, strong) NSNumber *selectedRadius;
@property (nonatomic, strong) Location *selectedLocation;
@property (nonatomic, strong) UIButton * _Nullable selectLocationButton;

@end

@implementation FiltersMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.layer.cornerRadius = [Constants buttonCornerRadius];
    
    self.createMenuIdentifiers = [Constants sportsList:NO];

    self.selectLocationButton = nil;
}

#pragma mark - Filters Menu Picker Cell and Location Picker Cell protocol methods

- (void)setSport:(NSString *)sport {
    self.selectedSport = sport;
}

- (void)setRadius:(NSNumber *)radius {
    self.selectedRadius = radius;
}

- (void)setSkillLevel:(NSString *)level {
    self.selectedSkillLevel = level;
}

- (void)getSelectedLocation:(Location *)location {
    self.selectedLocation = location;
    [self.selectLocationButton setTitle:@"Selected Location" forState:UIControlStateNormal];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        LocationPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationPickerCell"];
        return cell;
    }
    
    FiltersMenuPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FiltersMenuPickerCell"];
    cell.rowNumber = [NSNumber numberWithLong:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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

- (IBAction)didTapApply:(id)sender {
    Filters *filters = [Filters new];
    
    filters.location = self.selectedLocation;
    filters.sport = self.selectedSport;
    filters.skillLevel = self.selectedSkillLevel;
    filters.radius = self.selectedRadius;
        
    if ([filters.sport isEqualToString:@"All"]) {
        filters.sport = nil;
    }
    if ([filters.skillLevel isEqualToString:@"All"]) {
        filters.skillLevel = nil;
    }
    if (filters.radius == nil) {
        filters.radius = [NSNumber numberWithInt:5];
    }
    
    // call delegate method so filters save on search tab vc
    [self.delegate didApplyFilters:filters];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
