//
//  UpcomingSessionsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "UpcomingSessionsViewController.h"
#import "Session.h"
#import "SessionDetailsViewController.h"
#import "SessionCollectionCell.h"
#import "Constants.h"
#import "HomeViewController.h"

@interface UpcomingSessionsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sessionList;

@end

@implementation UpcomingSessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.sessionList = [[NSArray alloc] init];
}
g
- (void)loadSessionList:(NSArray *)sessionList {
    self.sessionList = sessionList;
    [self.collectionView reloadData];
}

#pragma mark - Collection view protocol methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SessionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCollectionCell" forIndexPath:indexPath];
    cell.session = self.sessionList[indexPath.row];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isMemberOfClass:[SessionCollectionCell class]]) {
        NSLog(@"segue to session collection cell");
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Session* data = self.sessionList[indexPath.row];
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = data;
    }
}

@end
