//
//  OutgoingRequestsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "OutgoingRequestsViewController.h"
#import "OutgoingRequestCell.h"
#import "PlayerConnection.h"

@interface OutgoingRequestsViewController () <UITableViewDelegate, UITableViewDataSource>

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
    
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    
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

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.outgoingRequestList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
