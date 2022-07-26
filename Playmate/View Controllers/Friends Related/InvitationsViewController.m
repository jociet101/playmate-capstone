//
//  InvitationsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import "InvitationsViewController.h"
#import "SessionDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "InvitationCell.h"
#import "Session.h"
#import "Constants.h"
#import "Strings.h"
#import "Helpers.h"

@interface InvitationsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, InvitationCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *invitationsList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation InvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = [Constants invitationsRowHeight];
    
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
    PFQuery *query = [PFQuery queryWithClassName:@"Invitation"];
    query.limit = 20;
    
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    [query whereKey:@"invitationToId" equalTo:user.objectId];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *invitations, NSError *error) {
        if (invitations != nil) {
            self.invitationsList = invitations;
            [self.tableView reloadData];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    InvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationCell"];
    cell.invitation = self.invitationsList[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invitationsList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants smallPlaymateLogo];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Strings emptyInvitationsPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Strings emptyInvitationsPlaceholderMsg];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

- (void)viewSessionFromInvite:(Session *)session {
    [self performSegueWithIdentifier:@"invitationToSessionDetails" sender:session];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"invitationToSessionDetails"]) {
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = (Session *)sender;
    }
}

@end
