//
//  FiltersViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/6/22.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // plan: call this once "apply filters" button is pressed
    // and search view controller is automatically brought to
    NSLog(@"calling apply filters %@", self.delegate);
    [self.delegate didApplyFilters];
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
