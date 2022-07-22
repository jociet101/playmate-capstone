//
//  InvitationsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import "InvitationsViewController.h"
#import "InvitationCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"

@interface InvitationsViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *invitationsList;

@end

@implementation InvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    InvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationCell"];
            
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
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyInvitationsPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyInvitationsPlaceholderMsg];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
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
