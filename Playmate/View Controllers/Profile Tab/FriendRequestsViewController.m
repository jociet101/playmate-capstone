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

@interface FriendRequestsViewController () <UITableViewDelegate, UITableViewDataSource, FriendRequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friendRequestList;

@end

@implementation FriendRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
}

- (void)fetchData {
    
    // fetch data for friend request list
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    query.limit = 20;
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    [query whereKey:@"toObjectId" equalTo:user[@"objectId"]];

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

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell"];
        
    cell.requestInfo = self.friendRequestList[indexPath.section];
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.friendRequestList.count;
}

#pragma mark - Friend Request cell delegate method

- (void)didTap:(FriendRequestCell *)cell profileImage:(PFUser *)user {
    
    [self performSegueWithIdentifier:@"toProfile" sender:user];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
    if ([segue.identifier isEqualToString:@"toProfile"]) {
        PlayerProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = sender;
    }
    
}

@end
