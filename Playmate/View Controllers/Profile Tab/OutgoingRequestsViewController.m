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

@interface OutgoingRequestsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, OutgoingRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *outgoingRequestList;

@end

@implementation OutgoingRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"outgoing requests view did load");
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self fetchData];
}

- (void)fetchData {
    
    // fetch data for outoing request list
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    PlayerConnection *myPc = user[@"playerConnection"][0];
    [myPc fetchIfNeeded];
    
    self.outgoingRequestList = myPc[@"pendingList"];
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

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [Constants resizeImage:[UIImage imageNamed:@"empty_friend_request"] withDimension:80];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyOutgoingRequestsPlaceholderTitle];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

#pragma mark - Outgoing Request cell delegate methods

- (void)didCancelRequest {
    [self.tableView reloadData];
}

@end
