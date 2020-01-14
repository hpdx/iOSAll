//
//  ViewController.m
//  03.OC-UICollectionView-Pinterest
//
//  Created by android_ls on 2020/1/14.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "ViewController.h"
#import "FlowLayoutViewController.h"
#import "PinterestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * btn = [self createButton:CGRectMake(30, 100, 120, 44) title:@"CollectionView基本用法"];
    // 单击事件处理
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    // 添加到视图中并显示
    [self.view addSubview:btn];
    
    
    UIButton * btn2 = [self createButton:CGRectMake(30, 170, 120, 44) title:@"瀑布流实现"];
    // 单击事件处理
    [btn2 addTarget:self action:@selector(pressBtnPinterest:) forControlEvents:UIControlEventTouchUpInside];
    // 添加到视图中并显示
    [self.view addSubview:btn2];
    
}

-(UIButton *) createButton:(CGRect)frame title:(NSString *)title
{
    UIButton * btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];//正常状态
    [btn setTitle:title forState:UIControlStateHighlighted];//正常状态高亮控制
    // 灰色背景颜色
    btn.backgroundColor = [UIColor greenColor];
    // 设置按钮文字颜色P1:颜色  P2:状态
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    // 设置按下状态的颜色
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    // 设置按钮的风格颜色
    [btn setTintColor:[UIColor whiteColor]];
    // titilelabel:UIlabel空间
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    return btn;
}

- (void) pressBtn:(UIButton *) btn
{
    FlowLayoutViewController *flowLayoutViewController= [[FlowLayoutViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:flowLayoutViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void) pressBtnPinterest:(UIButton *) btn
{
    PinterestViewController *pinterestViewController= [[PinterestViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:pinterestViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
