//
//  ViewController.m
//  AFNetworking-基本使用
//
//  Created by android_ls on 2020/1/16.
//  Copyright © 2020 android_ls. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(void) get
{
      NSString * url = @"https:www.jukeyuw.com/login";
      
      NSDictionary *paramDict = @{
                                  @"username":@"红果果",
                                  @"pwd":@"123456",
                                  @"type":@"JSON"
                                  };
      /* 发送GET请求
          第一个参数:请求路径(不包含参数).NSString
          第二个参数:字典(发送给服务器的数据~参数)
          第三个参数:progress 进度回调
          第四个参数:success 成功回调
                     task:请求任务
                     responseObject:响应体信息(JSON--->OC对象)
          第五个参数:failure 失败回调
                     error:错误信息
          响应头:task.response
          */
      [[AFHTTPSessionManager manager] GET:url parameters:paramDict progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
           NSLog(@"task.response = %@", task.response); // 请求头信息
           NSLog(@"%@---%@",[responseObject class], responseObject);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"请求失败--%@",error);
      }];
}


-(void) post
{
      NSString * url = @"https:www.jukeyuw.com/login";
      
      NSDictionary *paramDict = @{
                                  @"username":@"红果果",
                                  @"pwd":@"123456",
                                  @"type":@"JSON"
                                  };
      /* 发送POST请求
          第一个参数:请求路径(不包含参数).NSString
          第二个参数:字典(发送给服务器的数据~参数)
          第三个参数:progress 进度回调
          第四个参数:success 成功回调
                     task:请求任务
                     responseObject:响应体信息(JSON--->OC对象)
          第五个参数:failure 失败回调
                     error:错误信息
          响应头:task.response
          */
      [[AFHTTPSessionManager manager] POST:url parameters:paramDict progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
           NSLog(@"task.response = %@", task.response); // 请求头信息
           NSLog(@"%@---%@",[responseObject class], responseObject);
          
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"请求失败--%@",error);
      }];
}


-(void)download
{
    // 1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2.下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调 downloadProgress
     第三个参数:destination 回调(目标位置)
                有返回值
                targetPath:临时文件路径
                response:响应头信息
     第四个参数:completionHandler 下载完成之后的回调
                filePath:最终的文件路径
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f", 1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
    }];
    
    // 3.执行Task
    [download resume];
    
}


-(void)upload
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    NSDictionary *dictM = @{}
    //2.发送post请求上传文件
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject:响应体信息
     第六个参数:失败回调
     */
    [manager POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
       [formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        
        // [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
    }];
    
}

@end
