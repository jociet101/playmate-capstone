//
//  SnappingCollectionView.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import "SnappingCollectionView.h"

@implementation SnappingCollectionView

#pragma mark - Have collection view cards snap to grid

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    const CGFloat dragOffset = 157.0;
    int itemIndex = round(proposedContentOffset.x / dragOffset);
    CGFloat xOffset = itemIndex * dragOffset;
    return CGPointMake(xOffset, 0.0);
}

@end
