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
#import "Invitation.h"
#import "Session.h"

@interface FriendsListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, FriendCellDelegate>

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
    
    PlayerConnection *playerConnection = [Helpers getPlayerConnectionForUser:self.thisUser];
    
    self.friendsList = playerConnection[@"friendsList"];
    
    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)fetchData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (BOOL)doesInvitationExist:(NSString *)userObjectId {
    PFQuery *query = [PFQuery queryWithClassName:@"Invitation"];
    [query whereKey:@"sessionObjectId" equalTo:self.sessionWithInvite];
    [query whereKey:@"invitationToId" equalTo:userObjectId];
    [query whereKey:@"invitationFromId" equalTo:self.thisUser.objectId];
        
    return [query getFirstObject] != nil;
}

- (BOOL)isAlreadyInSession:(NSString *)userObjectId {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    [query whereKey:@"objectId" equalTo:self.sessionWithInvite];
    Session *session = [[query getFirstObject] fetchIfNeeded];
    NSArray *playerList = session.playersList;
    for (PFUser *user in playerList) {
        if ([user.objectId isEqualToString:userObjectId]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    NSString *toUserId = self.friendsList[indexPath.row];
    cell.thisUserId = toUserId;
    cell.delegate = self;
    
    cell.isForInvitations = self.isForInvitations;
    cell.isAlreadyInSession = [self isAlreadyInSession:toUserId];
    cell.isAlreadyInvitedToSession = [self doesInvitationExist:toUserId];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyListPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyListPlaceholderMsg];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

#pragma mark - Friend cell delegate method

+ (void)handleAlert:(NSError * _Nullable)error
          withTitle:(NSString *)title
        withMessage:(NSString * _Nullable)message
  forViewController:(id)viewController {
    if (error != nil) {
        message = error.localizedDescription;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [viewController viewDidLoad];
    }];
    
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:YES completion: nil];
}

- (void)didTap:(FriendCell *)cell forName:(NSString *)name andId:(NSString *)userObjectId {
    if (self.isForInvitations) {
        // check if this invitation already exists
        const BOOL invitationExists = [self doesInvitationExist:userObjectId];
        const BOOL isAlreadyInSession = [self isAlreadyInSession:userObjectId];
        NSString *alertTitle = isAlreadyInSession ? [NSString stringWithFormat:@"@%@ is already in session.", name] : [NSString stringWithFormat:@"Already invited @%@ to session.", name];
        if (invitationExists || isAlreadyInSession) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];

            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Invite @%@ to session?", name]
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *inviteAction = [UIAlertAction actionWithTitle:@"Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Invitation saveInvitationTo:userObjectId forSession:self.sessionWithInvite];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];

        [alertController addAction:inviteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"friendsListToProfile" sender:cell];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friendsListToProfile"]) {
        PlayerProfileViewController *vc = [segue destinationViewController];
        PFQuery *query = [PFUser query];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PFUser *theFriend = [query getObjectWithId:self.friendsList[indexPath.row]];
        vc.user = theFriend;
    }
}

@end
