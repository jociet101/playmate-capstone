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
#import "UIScrollView+EmptyDataSet.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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

- (void)viewWillAppear:(BOOL)animated {
    NSDate *dateToday = [Constants dateWithHour:0 minute:0 second:0 fromDate:[NSDate now]];
    [self fetchData:dateToday];
}

#pragma mark - Event Table view methods and fetch data

- (void)fetchData:(NSDate *)selectedDate {
    NSArray *filteredSessions = [self filterSessions:self.rawSessionList forDate:selectedDate];
    self.sessionList = (NSMutableArray *)filteredSessions;
    [self.tableView reloadData];
}

- (NSArray *)filterSessions:(NSArray *)sessions forDate:(NSDate *)date {
    NSMutableArray *filteredSessions = [[NSMutableArray alloc] init];
    PFUser *currUser = [[PFUser currentUser] fetchIfNeeded];
    
    for (Session *session in sessions) {

        NSDate *sessionDate = [Constants dateWithHour:0 minute:0 second:0 fromDate:session.occursAt];
        
        NSComparisonResult result = [date compare:sessionDate];

        if (result == NSOrderedSame) {
            [self.sessionList addObject:session];

            for (PFUser *user in session[@"playersList"]) {
                [user fetchIfNeeded];

                if ([currUser.username isEqualToString:user.username]) {
                    [filteredSessions addObject:session];
                    break;
                }
            }
        }
    }
    
    return (NSArray *)filteredSessions;
}

- (void)setupEventTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SessionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        
    cell.session = self.sessionList[indexPath.section];
            
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sessionList.count;
}

- (CGFloat)tableView:(UITableView*)tableView
           heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}

- (CGFloat)tableView:(UITableView*)tableView
           heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView
           viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView
           viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Empty table view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo_small"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = (self.calendarView.selectedDate == nil) ? [Constants emptyCalendarTableForDate:[NSDate now]]
                                                             : [Constants emptyCalendarTableForDate:self.calendarView.selectedDate];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

#pragma mark - Calendar view methods

- (void)setupCalendar {
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    self.calendarView.swipeToChooseGesture.enabled = YES;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self fetchData:date];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    if ([self filterSessions:self.rawSessionList forDate:date].count != 0) {
        return 1;
    }
    return 0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"calendarToSessionDetails"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         Session* data = self.sessionList[indexPath.section];
         SessionDetailsViewController *vc = [segue destinationViewController];
         vc.sessionDetails = data;
     }
 }

@end
