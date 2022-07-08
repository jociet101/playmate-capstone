//
//  CalendarViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/8/22.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    
    // make calendar view scroll vertically
    self.calendarView.scrollDirection = FSCalendarScrollDirectionVertical;
}

#pragma mark - Calendar view methods

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
