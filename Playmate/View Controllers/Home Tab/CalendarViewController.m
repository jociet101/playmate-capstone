//
//  CalendarViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/8/22.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"
#import "Constants.h"
#import "SessionCell.h"
#import "Session.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sessionList;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCalendar];
    [self setupEventTable];
}

#pragma mark - Event Table view methods and fetch data

- (void)fetchData:(NSDate *)selectedDate {
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
    query.limit = 20;
    
    [query orderByAscending:@"occursAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *sessions, NSError *error) {
        if (sessions != nil) {
            
//            [self filterSessions:sessions forDate:selectedDate];
            self.sessionList = (NSMutableArray *)sessions;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)filterSessions:(NSArray *)sessions forDate:(NSDate *)date {
    
    NSMutableArray *tempList = (NSMutableArray *)sessions;
    PFUser *currUser = [PFUser currentUser];
    [currUser fetchIfNeeded];
    
    for (Session *sesh in tempList) {
        
//        NSLog(@"session %@", sesh);
        
        for (PFUser *user in sesh[@"playersList"]) {
            [user fetchIfNeeded];
            
            NSDate *sessionDate = [Constants dateWithHour:12 minute:0 second:0 fromDate:sesh.occursAt];
            
            NSComparisonResult result = [date compare:sessionDate];
            
//            NSLog(@"comparison result %ld", result);
            
//            if ([currUser.username isEqualToString:user.username] && result == NSOrderedSame) {
                if ([currUser.username isEqualToString:user.username]) {
                [self.sessionList addObject:sesh];
                break;
            }
        }
    }
}

- (void)setupEventTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchData:[NSDate now]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"bloop");
    
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        
    cell.session = self.sessionList[indexPath.row];
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"size %lu", self.sessionList.count);
    
    return self.sessionList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Calendar view methods

- (void)setupCalendar {
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    self.calendarView.swipeToChooseGesture.enabled = YES;
    
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(handleScopeGesture:)];
    [self.calendarView addGestureRecognizer:scopeGesture];
    
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[Constants formatDate:date]);
    [self fetchData:date];
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    return YES;
}

//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
//{
//    self.calendarHeightConstraint.constant = CGRectGetHeight(bounds);
//    // Do other updates here
//    [self.view layoutIfNeeded];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
