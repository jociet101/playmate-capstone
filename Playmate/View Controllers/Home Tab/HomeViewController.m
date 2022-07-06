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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sessionList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.sessionList = [[NSMutableArray alloc] init];
    
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
    PFUser *currUser = [PFUser currentUser];
    [currUser fetchIfNeeded];
    
    for (Session *sesh in tempList) {
        
        for (PFUser *user in sesh[@"playersList"]) {
            [user fetchIfNeeded];
            
            if ([currUser.username isEqualToString:user.username]) {
                
                [self.sessionList addObject:sesh];
                break;
            }
        }
        
    }
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     if ([sender isMemberOfClass:[SessionCell class]]) {
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         
         Session* data = self.sessionList[indexPath.row];
         SessionDetailsViewController *VC = [segue destinationViewController];
         VC.sessionDeets = data;
     }
     
 }

@end
