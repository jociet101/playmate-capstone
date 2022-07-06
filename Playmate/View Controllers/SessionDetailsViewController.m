//
//  SessionDetailsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionDetailsViewController.h"

@interface SessionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;

@end

@implementation SessionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"session deets = %@", self.sessionDeets);
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
