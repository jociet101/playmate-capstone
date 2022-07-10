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
@property (nonatomic, strong) NSArray *createMenuIdentifiers;
@property (nonatomic, strong) NSMutableArray *menuCells;

@end

@implementation CreateMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;

    self.tableView.layer.cornerRadius = [Constants buttonCornerRadius];
    
    self.createMenuIdentifiers = [Constants sportsList:NO];
    
    self.menuCells = [[NSMutableArray alloc] init];
}

#pragma mark - Table view protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self.menuCells removeAllObjects];
    }
    
//    if (indexPath.row == 6) {
//        // TODO: location cell
//    }
    MenuPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuPickerCell"];
    
    cell.rowNumber = [NSNumber numberWithLong:indexPath.row];
    
    [self.menuCells addObject:cell];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    MenuPickerCell *thisCell = self.menuCells[indexPath.row];
//
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)didTapDone:(id)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
