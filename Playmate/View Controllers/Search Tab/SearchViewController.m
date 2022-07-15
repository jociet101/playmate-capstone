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
#import "FiltersMenuViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, FiltersMenuViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self fetchData];
    
    [self.clearFiltersButton setEnabled:NO];
    self.clearFiltersButton.tintColor = [UIColor lightGrayColor];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                         action:@selector(fetchData)
                         forControlEvents:UIControlEventValueChanged];
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
            
            NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
            
            for (Session *session in sessions) {
                NSDate *now = [NSDate date];
                NSComparisonResult result = [now compare:session.occursAt];
                
                if (result == NSOrderedAscending) {
                    [filteredSessions addObject:session];
                }
            }
            
            
            self.sessionList = (NSArray *)filteredSessions;
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyTablePlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptySearchPlaceholderMsg];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        
    cell.session = self.sessionList[indexPath.section];
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sessionList.count;
}

- (CGFloat)tableView:(UITableView*)tableView
           heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

- (CGFloat)tableView:(UITableView*)tableView
           heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView
           viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView
           viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Filter view controller configuration

- (void)didApplyFilters:(Filters *)filter {
    [self fetchDataWithFilters:filter];
    [self.navigationController popToViewController:self
                                                  animated:YES];
}

- (float)euclideanDistanceBetween:(Location *)location1 and:(Location *)location2 {
    
    [location1 fetchIfNeeded];
    [location2 fetchIfNeeded];
    
    float latitude1 = [location1.lat floatValue];
    float latitude2 = [location2.lat floatValue];
    float longitude1 = [location1.lng floatValue];
    float longitude2 = [location2.lng floatValue];
    
    float sumSquaredDifferences = pow(latitude1-latitude2, 2) + pow(longitude1-longitude2, 2);
    
    return pow(sumSquaredDifferences, 0.5);
}

- (NSArray *)filterSessions:(NSArray *)sessions withLocation:(Location *)location andRadius:(NSNumber *)radiusInMiles {
        
    float radiusInUnits = [radiusInMiles floatValue]/69;
    
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    
    for (Session *session in sessions) {
        float distance = [self euclideanDistanceBetween:location and:session.location];
                
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:session.occursAt];
        
        if (distance <= radiusInUnits && result == NSOrderedAscending) {
            [filteredSessions addObject:session];
        }
    }
    
    return (NSArray *)filteredSessions;
}

- (void)fetchDataWithFilters:(Filters *)filter {
    
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
            
            self.sessionList = [self filterSessions:sessions withLocation:filter.location andRadius:filter.radius];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isMemberOfClass:[SessionCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        Session* data = self.sessionList[indexPath.section];
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = data;
    }
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        FiltersMenuViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
}

@end
