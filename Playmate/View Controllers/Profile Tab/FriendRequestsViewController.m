//
//  FriendRequestsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import "FriendRequestsViewController.h"
#import "FriendRequest.h"
#import "FriendRequestCell.h"
#import "PlayerProfileViewController.h"
#import "PlayerConnection.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"

@interface FriendRequestsViewController () <UITableViewDelegate, UITableViewDataSource, FriendRequestCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friendRequestList;

@end

@implementation FriendRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self fetchData];
    
}

- (void)fetchData {
    
    // fetch data for friend request list
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    query.limit = 20;
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];

    [query whereKey:@"requestToId" equalTo:user.objectId];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests != nil) {
            
            self.friendRequestList = requests;
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSArray *)copyArray:(NSArray *)array {
    NSMutableArray *copyTo = [[NSMutableArray alloc] init];
    
    for (FriendRequest *item in array) {
        [copyTo addObject:item];
    }
    
    return (NSArray *)copyTo;
    
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
    NSLog(@"friend request list, %@", self.friendRequestList);
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

// TODO: add a notifications placeholder image
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [Constants resizeImage:[UIImage imageNamed:@"empty_friend_request"] withDimension:80];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyRequestsPlaceholderTitle];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [Constants emptyRequestsPlaceholderMsg];
    
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
    return [UIColor clearColor];
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
