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
#import "Helpers.h"
#import "Strings.h"
#import "CalendarViewController.h"
#import "ProfileViewController.h"
#import "SessionCollectionCell.h"
#import "UpcomingSessionsViewController.h"
#import "SuggestedSessionsViewController.h"
#import "CreateMenuViewController.h"

@interface HomeViewController () <CreateMenuViewControllerDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) NSMutableArray *sessionList;

@property (weak, nonatomic) IBOutlet UIView *upcomingView;
@property (weak, nonatomic) IBOutlet UIView *suggestedView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.upcomingView.layer.cornerRadius = [Constants buttonCornerRadius];
    self.suggestedView.layer.cornerRadius = [Constants buttonCornerRadius];
    
    self.upcomingView.alpha = 1;
    self.suggestedView.alpha = 0;
    
    self.sessionList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *greeting;
    NSDate *now = [NSDate now];
    if ([now hour] >= 17) {
        greeting = @"Good Evening, ";
    } else if ([now hour] >= 12) {
        greeting = @"Good Afternoon, ";
    } else {
        greeting = @"Good Morning, ";
    }
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    self.welcomeLabel.text = [greeting stringByAppendingString:me[@"firstName"][0]];
    
    [self fetchData];
}

- (void)reloadHomeTabSessions {
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
            [self.delegate loadSessionList:(NSArray *)self.sessionList];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

// Filter out sessions that do not contain self
- (void)filterSessions:(NSArray *)sessions {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    NSDate *now = [NSDate date];
    
    NSMutableSet *selfSet = [NSMutableSet setWithObject:me.objectId];
    // Filter to only sessions self is in
    for (Session *session in sessions) {
        NSMutableSet *playersSet = [Helpers getPlayerObjectIdSet:session.playersList];
        
        [playersSet intersectSet: selfSet];
        NSArray *resultArray = [playersSet allObjects];
        
        NSComparisonResult result = [now compare:session.occursAt];
        if (resultArray.count > 0 && result == NSOrderedAscending) {
            [self.sessionList addObject:session];
        }
    }
}

- (IBAction)switchViewController:(id)sender {
    UISegmentedControl *switcher = sender;
    
    const BOOL isSegmentZeroIndex = (switcher.selectedSegmentIndex == 0);
    self.upcomingView.alpha = isSegmentZeroIndex ? 1 : 0;
    self.suggestedView.alpha = isSegmentZeroIndex ? 0 : 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"toCalendar"]) {
		CalendarViewController *vc = [segue destinationViewController];
		vc.rawSessionList = self.sessionList;
    } else if ([segue.identifier isEqualToString:@"homeToUpcomingSessions"]) {
        UpcomingSessionsViewController *vc = [segue destinationViewController];
        self.delegate = (id)vc;
    }
}

- (IBAction)goToProfile:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
	[tabBarController setSelectedIndex:3];
	self.view.window.rootViewController = tabBarController;
}

@end
