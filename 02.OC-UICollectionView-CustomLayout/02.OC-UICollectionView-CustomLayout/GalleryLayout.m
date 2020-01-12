//
//  GalleryLayout.m
//  02.OC-UICollectionView-CustomLayout
//
//  Created by android_ls on 2020/1/12.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "GalleryLayout.h"

@implementation GalleryLayout

/**
 用来做布局的初始化操作
 必须调用[super prepareLayout ]
 */
- (void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"-->prepareLayout");
    
    // 设置内边距
    CGFloat padding = (self.collectionView.bounds.size.width - self.itemSize.width) *0.5;
    self.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding);
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 * prepareLayout
 * layoutAttributesForElementsInRect
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"-->shouldInvalidateLayoutForBoundsChange");
    return YES;
}

/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"-->layoutAttributesForElementsInRect");
    
    // 计算中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width*0.5;
    NSLog(@"centerX = %lf", centerX);
    
    // 获得super已经计算好的布局属性,返回的素组包括所有cell的布局属性
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attrs in array) {
        NSLog(@"attrs.center.x = %lf",  attrs.center.x);
        
        // cell的中心点x 和 collectionView中心点的x值 的间距
        CGFloat distance = ABS(attrs.center.x - centerX);
        // 根据间距值计算cell的缩放比例
        CGFloat scaleValue = 1 - distance/self.collectionView.bounds.size.width;
        
        NSLog(@"distance = %lf", distance);
        NSLog(@"scaleValue = %lf", scaleValue);
        
        attrs.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
    }
    return array;
}

/**
 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 proposedContentOffset：原本情况下，collectionView停止滚动时最终的偏移量
 velocity：滚动速率，通过这个参数可以了解滚动的方向
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSLog(@"-->targetContentOffsetForProposedContentOffset");
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end
