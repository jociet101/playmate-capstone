//
//  MapFiltersViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/20/22.
//

#import "MapFiltersViewController.h"

@interface MapFiltersViewController ()

@end

@implementation MapFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.delegate didApplyFilters:[MapFilters new]];
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
