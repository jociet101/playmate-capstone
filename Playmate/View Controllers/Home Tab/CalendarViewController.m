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
#import "SessionDetailsViewController.h"

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

- (void)viewDidAppear:(BOOL)animated {
    
    [self fetchData:[NSDate now]];
}

#pragma mark - Event Table view methods and fetch data

- (void)fetchData:(NSDate *)selectedDate {
    
    NSArray *filteredSessions = [self filterSessions:self.rawSessionList forDate:selectedDate];
    self.sessionList = (NSMutableArray *)filteredSessions;
    [self.tableView reloadData];
}

- (NSArray *)filterSessions:(NSArray *)sessions forDate:(NSDate *)date {
    
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    PFUser *currUser = [PFUser currentUser];
    [currUser fetchIfNeeded];
    
    for (Session *sesh in sessions) {

        NSDate *sessionDate = [Constants dateWithHour:0 minute:0 second:0 fromDate:sesh.occursAt];
        
        NSComparisonResult result = [date compare:sessionDate];

        if (result == NSOrderedSame) {
            [self.sessionList addObject:sesh];

            for (PFUser *user in sesh[@"playersList"]) {
                [user fetchIfNeeded];

                if ([currUser.username isEqualToString:user.username]) {
                    [filteredSessions addObject:sesh];
                    break;
                }
            }
        }
    }
    
    NSLog(@"ASLKDFJALSDKFJASDLKJF %ld", filteredSessions.count);
    
    return (NSArray *)filteredSessions;
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
    
//    self.tableView.topAnchor
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[Constants formatDate:date]);
    [self fetchData:date];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    if ([self filterSessions:self.rawSessionList forDate:date].count != 0) {
        return 1;
    }
    
    return 0;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([sender isMemberOfClass:[SessionCell class]]) {
         
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         
         Session* data = self.sessionList[indexPath.row];
         SessionDetailsViewController *VC = [segue destinationViewController];
         VC.sessionDeets = data;
     }
     
 }

@end
