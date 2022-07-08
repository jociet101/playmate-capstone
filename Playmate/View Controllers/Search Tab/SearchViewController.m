//
//  SearchViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/4/22.
//

#import "SearchViewController.h"
#import "SessionCell.h"
#import "SessionDetailsViewController.h"
#import "Session.h"
#import "FiltersViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sessionList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL appliedFilters;
@property (nonatomic, strong) Filters * _Nullable filters;
@property (weak, nonatomic) IBOutlet UIButton *clearFiltersButton;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appliedFilters = NO;
    self.filters = nil;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self fetchData];
    
    [self.clearFiltersButton setEnabled:NO];
    self.clearFiltersButton.tintColor = [UIColor lightGrayColor];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.appliedFilters == YES) {
        [self fetchDataWithFilters:self.filters];
    } else {
        [self fetchData];
    }
}

- (void)fetchData {
    
    if (self.appliedFilters == YES) {
        [self fetchDataWithFilters:self.filters];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;
    
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            self.sessionList = sessions;
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)fetchDataWithFilters:(Filters *)filter {
//    NSLog(@"%@", filter.radius);
    
    if (self.appliedFilters == NO) {
        
        [self.clearFiltersButton setEnabled:YES];
        self.clearFiltersButton.tintColor = [UIColor systemBlueColor];
        
        self.filters = filter;
        self.appliedFilters = YES;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;
    
    [query orderByDescending:@"createdAt"];
    
    if (filter.sport != nil) {
        [query whereKey:@"sport" equalTo:filter.sport];
    }
    if (filter.skillLevel != nil) {
        [query whereKey:@"skillLevel" equalTo:filter.skillLevel];
    }

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            self.sessionList = sessions;
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        
    cell.session = self.sessionList[indexPath.row];
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sessionList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Filter view controller configuration

- (void)didApplyFilters:(Filters *)filter {
    [self fetchDataWithFilters:filter];
}

- (IBAction)didTapClear:(id)sender {
    if (self.appliedFilters == YES) {
        [self.clearFiltersButton setEnabled:NO];
        self.clearFiltersButton.tintColor = [UIColor lightGrayColor];
        
        self.filters = nil;
        self.appliedFilters = NO;
        [self fetchData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isMemberOfClass:[SessionCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        Session* data = self.sessionList[indexPath.row];
        SessionDetailsViewController *VC = [segue destinationViewController];
        VC.sessionDeets = data;
    }
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        FiltersViewController *VC = [segue destinationViewController];
        VC.delegate = self;
    }
    
}

@end
