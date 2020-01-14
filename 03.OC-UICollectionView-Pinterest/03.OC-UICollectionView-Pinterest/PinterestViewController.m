//
//  PinterestViewController.m
//  03.OC-UICollectionView-Pinterest
//
//  Created by android_ls on 2020/1/14.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "PinterestViewController.h"
#import "PinterestCellLayout.h"

@interface PinterestViewController ()<UICollectionViewDataSource>

@end

@implementation PinterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PinterestCellLayout * layout = [[PinterestCellLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemCount = 100;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:collectionView];
    
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"pinterestCellID"];
    
}


#pragma mark - UICollectionViewDataSource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pinterestCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

@end
