//
//  PageThreeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageThreeViewController.h"

@interface PageThreeViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation PageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    NSLog(@"yes = %@\nno = %@", self.playSportsList, self.dontPlaySportsList);
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapNext:(id)sender {
    [self performSegueWithIdentifier:@"twoToThree" sender:nil];
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
