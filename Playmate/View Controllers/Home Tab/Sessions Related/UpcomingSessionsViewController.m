//
//  UpcomingSessionsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "UpcomingSessionsViewController.h"
#import "SessionDetailsViewController.h"
#import "HomeViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SessionCollectionCell.h"
#import "Session.h"
#import "Constants.h"
#import "Strings.h"

@interface UpcomingSessionsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HomeViewControllerDelegate, SessionCollectionCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sessionList;

@property (nonatomic, strong) NSTimer *timer;

@end

BOOL isLoading;

@implementation UpcomingSessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetSource = self;
    
    self.sessionList = [[NSArray alloc] init];
    
    isLoading = YES;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(stopLoading) userInfo:nil repeats:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    HomeViewController *vc = [[homeVC viewControllers][0] childViewControllers][0];
    vc.delegate = self;
}

- (void)stopLoading {
    isLoading = NO;
    [self.collectionView reloadData];
}

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
    if (isLoading) {
        return [UIImage animatedImageWithImages:[Constants rollingPlaymateLogoGif] duration:1.8f];
    } else {
        return [Constants smallPlaymateLogo];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [[NSString alloc] init];
    if (isLoading) {
        text = [Strings emptyCollectionLoadingSessionsTitle];
    } else {
        text = [Strings emptyTablePlaceholderTitle];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (!isLoading) {
        NSString *text = [Strings emptyTablePlaceholderMsg];
        return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
    }
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"upcomingToSessionDetails"]) {
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = sender;
    }
}

@end
