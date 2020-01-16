//
//  ViewController.m
//  SDWebImage-使用示例
//
//  Created by android_ls on 2020/1/16.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "UIImage+GIF.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)showImage:(id)sender {
    
    NSURL * url = [NSURL URLWithString:@"https://ww1.sinaimg.cn/large/0065oQSqly1fsoe3k2gkkj30g50niwla.jpg"];
    //        [self.photoView sd_setImageWithURL:url];
    
    //    [self.photoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"p"]];
    
    [self.photoView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"p"] options:0
                              progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"-->receivedSize = %ld   expectedSize = %ld", receivedSize, expectedSize);
        
    }
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"从网络下载");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            default:
                break;
        }
    }];
    
}

- (IBAction)downloadByShow:(id)sender {
    
    NSURL * imageURL = [NSURL URLWithString:@"https://ww1.sinaimg.cn/large/0065oQSqly1fsmis4zbe7j30sg16fq9o.jpg"];
    [[SDWebImageManager sharedManager] loadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"-->receivedSize = %ld   expectedSize = %ld", receivedSize, expectedSize);
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if(image) {
            NSLog(@"currentThread = %@" , [NSThread currentThread]);
            
            // 显示图片
            [self.photoView setImage:image];
            
            switch (cacheType) {
                case SDImageCacheTypeNone:
                    NSLog(@"从网络下载");
                    break;
                case SDImageCacheTypeDisk:
                    NSLog(@"磁盘缓存");
                    break;
                case SDImageCacheTypeMemory:
                    NSLog(@"内存缓存");
                    break;
                default:
                    break;
            }
        }
    }];
    
}


- (IBAction)download:(id)sender {
//    NSURL * imageURL = [NSURL URLWithString:@"https://ww1.sinaimg.cn/large/0065oQSqly1fsmis4zbe7j30sg16fq9o.jpg"];
//    [[[SDWebImageManager sharedManager] imageLoader] requestImageWithURL:imageURL options:0 context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        NSLog(@"currentThread = %@" , [NSThread currentThread]);
//
//    }];
    
    [self gif];
    
}

// 播放Gif图片
-(void)gif
{
    NSLog(@"%s", __func__);
    UIImage *image = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile:@"/Users/android_ls/Documents/github/iOSAll/SDWebImage-使用示例/SDWebImage-使用示例/k.gif"]];
    self.photoView.image = image;
}

@end
