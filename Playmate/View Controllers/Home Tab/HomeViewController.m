//
//  HomeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "HomeViewController.h"
#import "SessionCell.h"
#import "Session.h"
#import "SessionDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"
#import "CalendarViewController.h"
#import "ProfileViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sessionList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.sessionList = [[NSMutableArray alloc] init];
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    
    NSString *greeting;
    NSDate *now = [NSDate now];
    if ([now hour] >= 17) {
        greeting = @"Good Evening, ";
    } else if ([now hour] >= 12) {
        greeting = @"Good Afternoon, ";
    } else {
        greeting = @"Good Morning, ";
    }
    
    self.welcomeLabel.text = [greeting stringByAppendingString:me[@"firstName"][0]];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;
    
    [query orderByAscending:@"occursAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            
            [self.sessionList removeAllObjects];
            [self filterSessions:sessions];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

// Filter out sessions that do not contain self
- (void)filterSessions:(NSArray *)sessions {
    
    NSMutableArray *tempList = (NSMutableArray *)sessions;
    PFUser *currUser = [[PFUser currentUser] fetchIfNeeded];
    
    for (Session *sesh in tempList) {
        
        for (PFUser *user in sesh[@"playersList"]) {
            [user fetchIfNeeded];
            
            NSDate *now = [NSDate date];
            NSComparisonResult result = [now compare:sesh.occursAt];
            
            if ([currUser.username isEqualToString:user.username] && result == NSOrderedAscending) {
                [self.sessionList addObject:sesh];
                break;
            }
        }
    }
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyTablePlaceholderTitle];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyTablePlaceholderMsg];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([sender isMemberOfClass:[SessionCell class]]) {
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         
         Session* data = self.sessionList[indexPath.section];
         SessionDetailsViewController *VC = [segue destinationViewController];
         VC.sessionDetails = data;
     }
     
     if ([segue.identifier isEqualToString:@"toCalendar"]) {
         CalendarViewController *VC = [segue destinationViewController];
         VC.rawSessionList = self.sessionList;
     }
     
 }

- (IBAction)goToProfile:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    [tabBarController setSelectedIndex:3];
    self.view.window.rootViewController = tabBarController;
}

@end
