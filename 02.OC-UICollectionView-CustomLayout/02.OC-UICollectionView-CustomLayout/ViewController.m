//
//  ViewController.m
//  02.OC-UICollectionView-CustomLayout
//
//  Created by android_ls on 2020/1/12.
//  Copyright © 2020 android_ls. All rights reserved.
//
// 自定义UICollectionViewFlowLayout示例

#import "ViewController.h"
#import "PhotoCell.h"
#import "GalleryLayout.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GalleryLayout *layout = ({
        GalleryLayout *layout = [[GalleryLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(120, 120);
        layout.minimumLineSpacing = 20;
        
//        CGFloat padding = (UIScreen.mainScreen.bounds.size.width - 120) *0.5;
//        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding); // 设置UICollectionView的左右padding
        
        layout;
    });
    
    UICollectionView *collectionView = ({
         UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor brownColor];
        collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 160);
        collectionView.center = self.view.center;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        
        collectionView;
    });
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:[PhotoCell ID]];
    
}


#pragma mark - UICollectionViewDataSource
// 返回section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回每个section里item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// 返回item对应的UICollectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"---------------------indexPath-------------------");
//    NSLog(@"section = %ld", indexPath.section);
//    NSLog(@"item = %ld", indexPath.item);
//    NSLog(@"row = %ld", indexPath.row);
//    NSLog(@"length = %ld", indexPath.length);
    
    PhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCell ID] forIndexPath:indexPath];
    photoCell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.item +1]];
    return photoCell;
}


#pragma mark - UICollectionViewDelegate
// item的单击事件处理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section = %ld  item = %ld", indexPath.section, indexPath.item);
    
}

@end
