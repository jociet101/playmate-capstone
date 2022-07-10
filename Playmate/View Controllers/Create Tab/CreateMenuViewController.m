//
//  CreateMenuViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "CreateMenuViewController.h"
#import "MenuPickerCell.h"
#import "Constants.h"

@interface CreateMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CreateMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.layer.cornerRadius = [Constants buttonCornerRadius];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 6) {
//        // TODO: location cell
//    }
    MenuPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuPickerCell"];
                
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 7;
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
