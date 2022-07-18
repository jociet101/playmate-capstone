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

@interface HomeViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) NSMutableArray *sessionList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];

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
    
    self.sessionList = [[NSMutableArray alloc] init];
    
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
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
