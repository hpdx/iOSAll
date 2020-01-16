//
//  ViewController.m
//  04.OC-Thread
//
//  Created by android_ls on 2020/1/15.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// nonatomic 非原子的，非线程安全的
// atomic 原子的，线程安全的
@property (nonatomic, assign) NSInteger totalCount; // 车票总数

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 获得主线程
    NSThread *mainThread = [NSThread mainThread];
    NSLog(@"mainThread = %@", mainThread);
    
    // 获取当前线程
    NSThread * currentThread = [NSThread currentThread];
    NSLog(@"currentThread = %@", currentThread);
    
    // 判断线程是否为主线程
    Boolean isMainThread = [NSThread isMainThread];
    NSLog(@"isMainThread = %d", isMainThread);
    
    // 可以判断任意一个线程，是否为主线程
    Boolean isMainThread2 = [currentThread isMainThread];
    NSLog(@"isMainThread2 = %d", isMainThread2);
    
}


- (IBAction)onClick:(id)sender {
    NSLog(@"-->onClick");
    
    //    [self createThread];
    
    //    [self createThread2];
    
    //    [self createThread3];
    
    //    [self createThread4];
    
    //    [self threadLock];
    
    [self createThread5];
    
}


#pragma mark - 线程间的通信
-(void) createThread5
{
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage) object:nil];
    thread.name = @"任务线程（子线程）";
    [thread start];
}

/**
 下载图片数据
 */
-(void) downloadImage
{
    NSThread * currentThread = [NSThread currentThread];
    NSLog(@"-->downloadImage  currentThread = %@", currentThread);
    
    NSString *urlStr = @"https://ww1.sinaimg.cn/large/0065oQSqly1g2pquqlp0nj30n00yiq8u.jpg";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    
    // 切换到主线程，第三个参数waitUntilDone：后面的代码块是否需要等待showImage方法执行完毕后，再执行
    // performSelectorOnMainThread 是NSObject的扩展方法，意味着任意对象都有该方法
    [self performSelectorOnMainThread:@selector(showImage:) withObject:image waitUntilDone:YES];
    
    // [self.photoView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    NSLog(@"------------downloadImage 结束了------------");
}

/**
 显示图片
 */
-(void) showImage:(UIImage *)image
{
    NSThread * currentThread = [NSThread currentThread];
    NSLog(@"-->showImage  currentThread = %@", currentThread);
    
    _photoView.image = image;
}


#pragma mark - @synchronized 能有效防止因多线程抢夺资源导致的数据安全问题
/**
 互斥锁
 */
-(void) threadLock
{
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket:) object:@"售票员A"];
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket:) object:@"售票员B"];
    NSThread *threadC = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket:) object:@"售票员C"];
    
    self.totalCount = 10000;
    [threadA start];
    [threadB start];
    [threadC start];
}

/**
 售票员卖车票
 */
-(void)saleTicket:(NSString *) param
{
    while (1) {
        // 锁：必须全局唯一，注意加锁的位置
        // 前提条件：多个线程共享（访问）同一资源（读、写）
        // 加锁需要付出代价：耗费性能、线程同步（排队一个一个来）
        // 加互斥锁解决的问题：能有效防止因多线程抢夺资源导致的数据安全问题
        
        // NSLog(@"%@，正在等待...", param);
        @synchronized (self) {
            if(self.totalCount > 0) {
                NSLog(@"%@，正在卖出%ld张票", param, self.totalCount);
                self.totalCount = self.totalCount - 1;
                
                // [NSThread sleepForTimeInterval:1.0]; // 暂停1秒
                // [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]]; // 暂停5秒
            } else {
                NSLog(@"%@，老板票已经卖完了", param);
                break;
            }
        }
    }
}


#pragma mark - NSThread基础

-(void) createThread4
{
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(task) object:@"异步任务"];
    [thread start];
}

-(void) createThread
{
    // 线程的生命周期：新建、就绪、运行、阻塞、死亡
    // 1、新建->就绪->运行->死亡
    // 2、新建->就绪->运行->阻塞->就绪->运行->死亡
    
    // 创建一个子线程(管生不管死)，当线程中的任务被完成后，生命周期结束（被系统回收）
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(run:) object:@"newThread"];
    thread.name = @"创建子线程";
    thread.threadPriority = 1.0; // 优先级，取值范围[0.0~1.0]，默认优先级0.5
    // 启动线程
    [thread start];
}

-(void) createThread2
{
    // 无返回值，意味着不能设置线程的属性
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"分离子线程"];
}

-(void) createThread3
{
    // 无返回值，意味着不能设置线程的属性
    [self performSelectorInBackground:@selector(run:) withObject:@"开启后台线程"];
}

-(void) run:(NSString *) param
{
    NSThread * currentThread = [NSThread currentThread];
    NSLog(@"param = %@  currentThread = %@", param, currentThread);
    
    // 使线程进入阻塞状态
    // [NSThread sleepForTimeInterval:2.0]; // 暂停2秒
    
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]]; // 暂停5秒
    NSLog(@"-->我睡醒了[sleepForTimeInterval]");
    
}

-(void) task {
    NSLog(@"---------------task--------------");
    for(int i = 0; i< 1000; i++) {
        NSThread * currentThread = [NSThread currentThread];
        NSLog(@"i= %d   currentThread = %@", i, currentThread);
        
        if(i == 33) {
            [NSThread exit]; // 强制结束，退出当前线程【被迫死亡】
            // break; // 任务结束，结束当前线程【正常死亡】
        }
    }
}


@end
