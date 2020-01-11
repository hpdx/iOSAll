//
//  ViewController.m
//  01.OC-UICollectionView
//
//  Created by android_ls on 2020/1/11.
//  Copyright © 2020 android_ls. All rights reserved.
//
// UICollectionView 基本使用示例

#import "ViewController.h"
#import "PhotoCell.h"

@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
   
    // 创建UICollectionViewFlowLayout对象
    CGFloat padding = (screenWidth - 120)*0.5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(120, 120); // itemView的x大小
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 设置为水平布局
    layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding); // 设置左右padding
    layout.minimumLineSpacing = 30; // 设置itemView间的最小间距
    
    // layout.minimumLineSpacing = 30; // 设置行之间的最小间距（网格式，竖直方向）
    // layout.minimumInteritemSpacing = 100; // 设置列之间的最小间距 （网格式，水平方向）
    
    // 创建UICollectionView对象
    CGRect collectionFrame = CGRectMake(0, 0, screenWidth, 160);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:collectionFrame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor blackColor]; // 设置背景色
    collectionView.center = self.view.center; // 设置UICollectionView处于屏幕中间
    collectionView.showsHorizontalScrollIndicator = NO; // 不显示水平方向的滚动条
    [self.view addSubview:collectionView];
    
    // 设置数据源
    collectionView.dataSource = self;
    // 注册cell
    [collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:[PhotoCell ID]];
    
}

// UICollectionViewDataSource的方法，返回一组有多少元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCell ID] forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.item +1]];
    return cell;
}

@end
