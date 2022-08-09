//
//  SuggestedSessionsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "SuggestedSessionsViewController.h"
#import "SessionDetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SessionCollectionCell.h"
#import "RecommendationData.h"
#import "Session.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface SuggestedSessionsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SessionCollectionCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sessionList;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SuggestedSessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetSource = self;
    
    self.sessionList = [[NSArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchData];
}

- (void)fetchData {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    if (me[@"recommendation"] == nil) {
        return;
    }
    
    RecommendationData *data = [[PFQuery getObjectOfClass:@"RecommendationData" objectId:me[@"recommendation"][0]] fetchIfNeeded];
    NSMutableArray *temporaryList = [[NSMutableArray alloc] init];
    for (NSString *sessionId in data.suggestedList) {
        Session *session = [PFQuery getObjectOfClass:@"SportsSession" objectId:sessionId];
        NSComparisonResult result = [[NSDate now] compare:session.occursAt];
        if (result == NSOrderedAscending) {
            [temporaryList addObject:session];
        }
    }
    self.sessionList = (NSArray *)temporaryList;
    
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
    [self performSegueWithIdentifier:@"suggestedToSessionDetails" sender:session];
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
    return [Constants smallPlaymateLogo];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No session suggestions";
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Take the preferences quiz and join a few sessions to get suggestions!";
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants descriptionAttributes]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"suggestedToSessionDetails"]) {
        SessionDetailsViewController *vc = [segue destinationViewController];
        vc.sessionDetails = sender;
    }
}

@end
