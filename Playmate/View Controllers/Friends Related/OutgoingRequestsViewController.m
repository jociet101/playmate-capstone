//
//  OutgoingRequestsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "OutgoingRequestsViewController.h"
#import "OutgoingRequestCell.h"
#import "PlayerConnection.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"
#import "Helpers.h"

@interface OutgoingRequestsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, OutgoingRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *outgoingRequestList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation OutgoingRequestsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
    
    // fetch data for outoing request list
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:user];
    
    self.outgoingRequestList = playerConnection[@"pendingList"];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    OutgoingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutgoingRequestCell"];
    cell.userObjectId = self.outgoingRequestList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.outgoingRequestList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyOutgoingRequestsPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

#pragma mark - Outgoing Request cell delegate methods

- (void)didCancelRequest {
    [self.tableView reloadData];
}

@end
