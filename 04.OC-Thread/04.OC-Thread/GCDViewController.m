//
//  GCDViewController.m
//  04.OC-Thread
//
//  Created by android_ls on 2020/1/16.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"-----------viewDidLoad-------------");
    // 等待2秒后开始执行
    // [self performSelector:@selector(delayTask) withObject:nil afterDelay:2.0];
    
    // repeats:YES，表示重复调用，每隔两秒执行一次
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delayTask) userInfo:nil repeats:YES];
    
    // dispatch_get_main_queue() 在主线程执行
    // 等待3秒后执行，时间单位可以精确到纳秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"-->dispatch_after %@", [NSThread currentThread]);
        
    });
    
    // 在子线程执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"--2--->dispatch_after %@", [NSThread currentThread]);
        
    });
    
    
}


-(void) delayTask
{
    NSLog(@"-->delayTask %@", [NSThread currentThread]);
    
    // 在整个应用程序生命周体内，只会执行一次，主要用于单例模式
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"-------dispatch_once-----------");
    });
    
}


- (IBAction)onClick:(id)sender {
    NSLog(@"可以工作了");
    
    //    [self asyncConcurrent];
    
    //    [self asyncSerial];
    
    //    [self syncConcurrent];
    
    //    [self syncSerial];
    
    //    [self getGlobalQueue];
    
    //    [self getMainQueue];
    
    //     [self dwonloadImage];
    
    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(work) object:nil];
    [thread start];
}


#pragma mark 在子线程下载图片，在主线程显示
-(void) dwonloadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"-->downloadImage  currentThread = %@", [NSThread currentThread]);
        
        // 在子线程下载图片数据
        NSString *urlStr = @"https://ww1.sinaimg.cn/large/0065oQSqly1g2pquqlp0nj30n00yiq8u.jpg";
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        // 切换到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"-->showImage  currentThread = %@", [NSThread currentThread]);
            self.photoView.image = image;
        });
    });
}


#pragma mark - 在子线程中任务执行完了，将结果在主线程中显示
-(void) work
{
    // 当前是子线程中执行的
    NSLog(@"-->work %@", [NSThread currentThread]);
    [self switchMainThread:@"我的活干完了"];
}

-(void) switchMainThread:(NSString *) data
{
    // 获取主队列(串行队列)，凡是放入主队列中的异步函数，都是在主线程执行的
    dispatch_queue_main_t queue_main = dispatch_get_main_queue();
    dispatch_sync(queue_main, ^{
        NSLog(@"%@ currentThread = %@", data, [NSThread currentThread]);
        // 当前是在主线程
        
    });
}


#pragma mark - 凡是放入主队列中的异步函数，都是在主线程执行的
-(void) getMainQueue
{
    // 获取主队列(串行队列)，凡是放入主队列中的异步函数，都是在主线程执行的
    // 在主线程中调用该函数，若将(dispatch_sync)同步函数放入主队列，运行时会报EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
    dispatch_queue_main_t queue_main = dispatch_get_main_queue();
    dispatch_async(queue_main, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    dispatch_async(queue_main, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    dispatch_async(queue_main, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
}


#pragma mark - 在并发队列里，开启异步g函数，有n个任务会开启n条子线程吗？答案是否定的
#pragma mark - 具体需要开启几条子线程来执行任务，是由系统来决定的
- (void)getGlobalQueue {
    // 获取全局的并发队列
    // DISPATCH_QUEUE_PRIORITY_DEFAULT指的是队列中任务的优先级
    dispatch_queue_global_t queue_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建异步函数，会开子线程
    dispatch_async(queue_global, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue_global, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue_global, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue_global, ^{
        NSLog(@"工作线程D %@", [NSThread currentThread]);
    });
}


#pragma mark - 并发队列，异步函数：开多个子线程执行任务，无序
-(void)asyncConcurrent {
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    // 创建异步函数，会开子线程
    dispatch_async(queue, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
}


#pragma mark - 串行队列，异步函数：会开线程，开一个线程，顺序执行任务（有序）
-(void)asyncSerial {
    // 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);
    // 创建异步函数，会开子线程
    dispatch_async(queue, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
}


#pragma mark - 并发队列，同步函数：不会开新的线程
-(void)syncConcurrent {
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    // 创建同步函数， dispatch_sync特点：立刻马上执行，如果我没执行完毕，后面就都等着吧
    dispatch_sync(queue, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
}


#pragma mark - 串行队列，同步函数：不会开新的线程
-(void)syncSerial {
    // 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);
    // 创建同步函数， dispatch_sync特点：立刻马上执行，如果我没执行完毕，后面就都等着吧
    dispatch_sync(queue, ^{
        NSLog(@"工作线程A %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"工作线程B %@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"工作线程C %@", [NSThread currentThread]);
    });
}


@end
