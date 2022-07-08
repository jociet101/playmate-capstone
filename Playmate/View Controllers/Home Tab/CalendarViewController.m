//
//  CalendarViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/8/22.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"
#import "Constants.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCalendar];
}

#pragma mark - Calendar view methods

- (void)setupCalendar {
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    // make calendar view scroll vertically
//    self.calendarView.scrollDirection = FSCalendarScrollDirectionVertical;
    
    // make calendar view weekly when scrolled
//    self.calendarView.scope = FSCalendarScopeWeek;
    
//    self.calendarView.scope =
    
    self.calendarView.swipeToChooseGesture.enabled = YES;
    
    UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(handleScopeGesture:)];
    [self.calendarView addGestureRecognizer:scopeGesture];
    
    // TODO: decide if i want to use event label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarView.frame)+10, self.view.frame.size.width, 50)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
//    [self.view addSubview:label];
//    self.eventLabel = label;
    
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    
    // TODO: decide if i want to keep event label
//    self.eventLabel.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+10, self.view.frame.size.width, 50);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[Constants formatDate:date]);
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
