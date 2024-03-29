//
//  SearchViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/4/22.
//

#import "SearchViewController.h"
#import "SessionDetailsViewController.h"
#import "FiltersMenuViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SessionCell.h"
#import "Session.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, FiltersMenuViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sessionList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL appliedFilters;
@property (nonatomic, strong) Filters * _Nullable filters;
@property (weak, nonatomic) IBOutlet UIButton *clearFiltersButton;

@property (nonatomic, strong) NSTimer *timer;

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
        
    [self.clearFiltersButton setEnabled:NO];
    self.clearFiltersButton.tintColor = [UIColor lightGrayColor];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
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
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.appliedFilters) {
        return [Constants smallPlaymateLogo];
    }
    return [UIImage animatedImageWithImages:[Constants rollingPlaymateLogoGif] duration:1.8f];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Strings emptyCollectionLoadingSessionsTitle];
    if (self.appliedFilters) {
        text = [Strings emptyTablePlaceholderTitle];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Strings emptyTablePlaceholderMsg];
    if (self.appliedFilters) {
        text = [Strings emptySearchPlaceholderMsg];
    }
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
    [self clearFilters];
    [self fetchDataWithFilters:filter];
    [self.navigationController popToViewController:self
                                                  animated:YES];
}

- (NSArray *)filterSessions:(NSArray *)sessions withLocation:(Location *)location andRadius:(NSNumber *)radiusInMiles {
    float radiusInUnits = [radiusInMiles floatValue]/69;
    
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    
    for (Session *session in sessions) {
        float distance = [Helpers euclideanDistanceBetween:location and:session.location];
                
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:session.occursAt];
        
        if (distance <= radiusInUnits && result == NSOrderedAscending) {
            [filteredSessions addObject:session];
        }
    }
    return (NSArray *)filteredSessions;
}

- (NSArray *)filterSessionsByTime:(NSArray *)sessions {
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    
    for (Session *session in sessions) {
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:session.occursAt];
        
        if (result == NSOrderedAscending) {
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
            self.sessionList = (filter.location != nil) ? [self filterSessions:sessions
                                                                  withLocation:filter.location
                                                                     andRadius:filter.radius]
                                                        : [self filterSessionsByTime:sessions];
            
            [self.tableView reloadData];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)didTapClear:(id)sender {
    [self clearFilters];
}

- (void)clearFilters {
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
    } else if ([segue.identifier isEqualToString:@"searchToFilters"]) {
        FiltersMenuViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
}

@end
