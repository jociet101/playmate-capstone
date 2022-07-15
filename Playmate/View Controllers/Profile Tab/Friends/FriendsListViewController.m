//
//  FriendsListViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "FriendsListViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"
#import "PlayerConnection.h"
#import "FriendCell.h"
#import "PlayerProfileViewController.h"
#import "Helpers.h"

@interface FriendsListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friendsList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.thisUser fetchIfNeeded];
    
    PlayerConnection *playerConnection = [Constants getPlayerConnectionForUser:self.thisUser];
    
    self.friendsList = playerConnection[@"friendsList"];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)fetchData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    cell.thisUserId = self.friendsList[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [Helpers resizeImage:[UIImage imageNamed:@"empty_friend_request"] withDimension:80];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyListPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyListPlaceholderMsg];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor clearColor];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toProfile"]) {
        PlayerProfileViewController *vc = [segue destinationViewController];
        PFQuery *query = [PFUser query];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *theFriend = [query getObjectWithId:self.friendsList[indexPath.row]];
        vc.user = theFriend;
    }
}

@end
