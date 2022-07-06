//
//  SessionDetailsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionDetailsViewController.h"
#import "SessionCell.h"

@interface SessionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SessionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"session deets = %@", self.sessionDeets);
    
    [self initializeDetails];
}

- (void)initializeDetails {
    
    self.sportLabel.text = self.sessionDeets.sport;
    
    // Form the fraction into a string
    NSString *capacityString = [[NSString stringWithFormat:@"%d", [self.sessionDeets.capacity intValue] - [self.sessionDeets.occupied intValue]] stringByAppendingString:[@"/" stringByAppendingString:[[NSString stringWithFormat:@"%@", self.sessionDeets.capacity] stringByAppendingString:@" open slots"]]];
    
    self.capacityLabel.text = capacityString;
    self.levelLabel.text = self.sessionDeets.skillLevel;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss yyyy";
    NSString *originalDate = [formatter stringFromDate:self.sessionDeets.occursAt];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    self.dateTimeLabel.text = [formatter stringFromDate:date];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
