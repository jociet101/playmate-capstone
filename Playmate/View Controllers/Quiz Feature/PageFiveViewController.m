//
//  PageFiveViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageFiveViewController.h"
#import "Constants.h"
#import "QuizHelpers.h"

@interface PageFiveViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation PageFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)didTapClose:(id)sender {
    [QuizHelpers giveCloseWarningforViewController:self];
}

- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }

@end
