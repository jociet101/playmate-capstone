//
//  PageTwoViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/28/22.
//

#import "PageTwoViewController.h"

@interface PageTwoViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation PageTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
