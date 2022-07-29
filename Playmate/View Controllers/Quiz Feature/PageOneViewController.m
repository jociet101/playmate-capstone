//
//  PageOneViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/28/22.
//

#import "PageOneViewController.h"

@interface PageOneViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation PageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progress setProgress:0.2 animated:YES];
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
