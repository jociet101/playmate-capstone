//
//  HomeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "CalendarViewController.h"
#import "ProfileViewController.h"
#import "UpcomingSessionsViewController.h"
#import "SuggestedSessionsViewController.h"
#import "CreateMenuViewController.h"
#import "SessionDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SessionCollectionCell.h"
#import "NotificationHandler.h"
#import "Session.h"
#import "APIManager.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface HomeViewController () <CreateMenuViewControllerDelegate, SessionDetailsViewControllerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) NSMutableArray *sessionList;
@property (weak, nonatomic) IBOutlet UILabel *notifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeQuizLabel;

@property (weak, nonatomic) IBOutlet UIView *upcomingView;
@property (weak, nonatomic) IBOutlet UIView *suggestedView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [NotificationHandler setUpNotifications];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    self.upcomingView.layer.cornerRadius = [Constants buttonCornerRadius];
    self.suggestedView.layer.cornerRadius = [Constants buttonCornerRadius];
    self.upcomingView.alpha = 1;
    self.suggestedView.alpha = 0;
    
    self.notifierLabel.layer.cornerRadius = [Constants smallButtonCornerRadius];
    self.notifierLabel.layer.borderColor = [[Constants playmateBlue] CGColor];
    self.notifierLabel.layer.borderWidth = 0.8;
    
    self.sessionList = [[NSMutableArray alloc] init];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    self.notifierLabel.text = [Helpers getNotifierLabelString];
    self.welcomeLabel.text = [Helpers getGreeting];
    [self.delegate loadSessionList:@[]];
    [self fetchData];
}

#pragma mark - Notifications Configuration

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    // Parse notification information to get session id to segue to
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *sessionObjectId = userInfo[@"sessionObjectId"];
    
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    PFQuery *notifQuery = [PFQuery queryWithClassName:@"SessionNotification"];
    [notifQuery whereKey:@"sessionObjectId" equalTo:sessionObjectId];
    [notifQuery whereKey:@"userObjectId" equalTo:me.objectId];
    SessionNotification *notification = [notifQuery getFirstObject];
    [notification deleteInBackground];
    
    if ([response.actionIdentifier isEqualToString:@"OPEN_APPLE_MAP_ACTION"]) {
        PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
        Session *session = [[query getObjectWithId:sessionObjectId] fetchIfNeeded];
        [APIManager goToAddress:session.location onPlatform:@"Apple"];
    } else if ([response.actionIdentifier isEqualToString:@"OPEN_GOOGLE_MAP_ACTION"]) {
        PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
        Session *session = [[query getObjectWithId:sessionObjectId] fetchIfNeeded];
        [APIManager goToAddress:session.location onPlatform:@"Google"];
    } else {
        // user swiped to unlock or wants to view session details
        [self performSegueWithIdentifier:@"homeToSessionDetails" sender:(id)sessionObjectId];
    }
    
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}

- (void)reloadHomeTabSessions {
    [self fetchData];
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    [query orderByAscending:@"occursAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            [self.sessionList removeAllObjects];
            self.sessionList = [[NSMutableArray alloc] init];
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
    
    // Filter to only sessions self is in
    for (Session *session in sessions) {
        NSMutableSet *playersSet = [Helpers getPlayerObjectIdSet:session.playersList];
        NSComparisonResult result = [now compare:session.occursAt];
        if ([playersSet containsObject:me.objectId] && result == NSOrderedAscending) {
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

- (IBAction)didTapReload:(id)sender {
    [self fetchData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"toCalendar"]) {
		CalendarViewController *vc = [segue destinationViewController];
		vc.rawSessionList = self.sessionList;
    } else if ([segue.identifier isEqualToString:@"homeToUpcomingSessions"]) {
        
        UpcomingSessionsViewController *vc = [segue destinationViewController];
        self.delegate = (id)vc;
    } else if ([segue.identifier isEqualToString:@"homeToSessionDetails"]) {
        SessionDetailsViewController *vc = [segue destinationViewController];
        PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
        vc.sessionDetails = [query getObjectWithId:(NSString *)sender];
    }
}

- (IBAction)goToProfile:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
	[tabBarController setSelectedIndex:3];
	self.view.window.rootViewController = tabBarController;
}

- (IBAction)didTapViewNotifications:(id)sender {
    [self performSegueWithIdentifier:@"homeToFriendNotifications" sender:nil];
}

@end
