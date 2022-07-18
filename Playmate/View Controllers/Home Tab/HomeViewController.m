//
//  HomeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "HomeViewController.h"
#import "Session.h"
#import "SessionDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Constants.h"
#import "CalendarViewController.h"
#import "ProfileViewController.h"
#import "SessionCollectionCell.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sessionList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;

	self.sessionList = [[NSMutableArray alloc] init];

	PFUser *me = [[PFUser currentUser] fetchIfNeeded];

	NSString *greeting;
	NSDate *now = [NSDate now];
	if ([now hour] >= 17) {
		greeting = @"Good Evening, ";
	} else if ([now hour] >= 12) {
		greeting = @"Good Afternoon, ";
	} else {
		greeting = @"Good Morning, ";
	}

	self.welcomeLabel.text = [greeting stringByAppendingString:me[@"firstName"][0]];
}

- (void)viewDidAppear:(BOOL)animated {
	[self fetchData];
}

- (void)fetchData {
	PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
	query.limit = 20;

	[query orderByAscending:@"occursAt"];

	// fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            [self.sessionList removeAllObjects];
            [self filterSessions:sessions];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

// Filter out sessions that do not contain self
- (void)filterSessions:(NSArray *)sessions {
	NSMutableArray *tempList = (NSMutableArray *)sessions;
	PFUser *currUser = [[PFUser currentUser] fetchIfNeeded];

	for (Session *sesh in tempList) {

		for (PFUser *user in sesh[@"playersList"]) {
			[user fetchIfNeeded];

			NSDate *now = [NSDate date];
			NSComparisonResult result = [now compare:sesh.occursAt];

			if ([currUser.username isEqualToString:user.username] && result == NSOrderedAscending) {
				[self.sessionList addObject:sesh];
				break;
			}
		}
	}
}

#pragma mark - Collection view protocol methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SessionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCollectionCell" forIndexPath:indexPath];
    cell.session = self.sessionList[indexPath.row];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([sender isMemberOfClass:[SessionCollectionCell class]]) {
        NSLog(@"segue to session collection cell");
		NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
		Session* data = self.sessionList[indexPath.row];
		SessionDetailsViewController *vc = [segue destinationViewController];
		vc.sessionDetails = data;
	}

	if ([segue.identifier isEqualToString:@"toCalendar"]) {
		CalendarViewController *vc = [segue destinationViewController];
		vc.rawSessionList = self.sessionList;
	}
}

- (IBAction)goToProfile:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
	[tabBarController setSelectedIndex:3];
	self.view.window.rootViewController = tabBarController;
}

@end
