//
//  IncomingRequestsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "IncomingRequestsViewController.h"
#import "FriendRequest.h"
#import "FriendRequestCell.h"
#import "PlayerProfileViewController.h"
#import "PlayerConnection.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"
#import "Helpers.h"

@interface IncomingRequestsViewController () <UITableViewDelegate, UITableViewDataSource, FriendRequestCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friendRequestList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation IncomingRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self fetchData];
}

- (void)fetchData {
    
    // fetch data for friend request list
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    query.limit = 20;
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];

    [query whereKey:@"requestToId" equalTo:user.objectId];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests != nil) {
            
            self.friendRequestList = requests;
            
            [self.tableView reloadData];
        } else {
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
    cell.requestInfo = self.friendRequestList[indexPath.row];
    cell.delegate = self;
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendRequestList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyIncomingRequestsPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

#pragma mark - Friend Request cell delegate methods

- (void)didTap:(FriendRequestCell *)cell profileImage:(PFUser *)user {
    [self performSegueWithIdentifier:@"toProfile" sender:user];
}

- (void)didRespondToRequest {
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toProfile"]) {
        PlayerProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = sender;
    }
}

@end
