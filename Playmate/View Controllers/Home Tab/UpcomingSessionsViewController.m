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
#import "SnappingCollectionView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface UpcomingSessionsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, HomeViewControllerDelegate, SessionCollectionCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sessionList;

@end

@implementation UpcomingSessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetSource = self;
//    self.collectionView.collectionViewLayout = [SnappingCollectionView new];
    // TODO: for prefetching
    self.collectionView.prefetchDataSource = self;
    self.collectionView.prefetchingEnabled = YES;

    self.sessionList = [[NSArray alloc] init];
}

- (void)loadSessionList:(NSArray *)sessionList {
    NSLog(@"load session list");
    self.sessionList = sessionList;
    [self.collectionView reloadData];
}

#pragma mark - Collection view protocol methods

// TODO: figure out how to prefetch!!!!!!!!!
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        SessionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCollectionCell" forIndexPath:indexPath];
        
        cell.session = self.sessionList[indexPath.row];
        cell.delegate = self;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SessionCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionCollectionCell" forIndexPath:indexPath];
    
    cell.session = self.sessionList[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)segueToFullSessionDetails:(Session *)session {
    [self performSegueWithIdentifier:@"upcomingToSessionDetails" sender:session];
}

#pragma mark - Collection view snap to grid

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    const CGFloat dragOffset = 157.0;
//    int itemIndex = round((*targetContentOffset).x / dragOffset);
//    CGFloat xOffset = itemIndex * dragOffset;
//    *targetContentOffset = CGPointMake(xOffset, 0.0);
    
    CGFloat minimumSnapVelocity = 1.5;
    
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    
    CGFloat horizontalPosition = (*targetContentOffset).x + (self.collectionView.bounds.size.width * 0.5);
    
    CGRect targetRect = CGRectMake((*targetContentOffset).x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *layoutAttributesArray = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesArray) {
        CGFloat itemHorizontalPosition = layoutAttributes.center.x;
        
        if (fabs(itemHorizontalPosition - horizontalPosition) < fabs(offsetAdjustment)) {
            if (fabs(velocity.x) < minimumSnapVelocity) {
                offsetAdjustment = itemHorizontalPosition - horizontalPosition;
            } else if (velocity.x > 0) {
                offsetAdjustment = itemHorizontalPosition - horizontalPosition + (layoutAttributes.bounds.size.width + 10.0);
            } else {
                offsetAdjustment = itemHorizontalPosition - horizontalPosition - (layoutAttributes.bounds.size.width + 10.0);
            }
        }
    }
    *targetContentOffset = CGPointMake((*targetContentOffset).x + offsetAdjustment, (*targetContentOffset).y);
}

#pragma mark - Empty collection view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage animatedImageWithImages:[Constants rollingPlaymateLogoGif] duration:1.8f];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Constants emptyCollectionLoadingSessionsTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"upcomingToSessionDetails"]) {
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = sender;
    }
}

@end
