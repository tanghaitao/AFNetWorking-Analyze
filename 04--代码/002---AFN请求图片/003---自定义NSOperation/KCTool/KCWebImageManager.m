//
//  KCWebImageManager.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/7.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "KCWebImageManager.h"
#import "NSString+KCAdd.h"
#import "KCWebImageDownloadOperation.h"

@interface KCWebImageManager()
//下载队列
@property (nonatomic, strong) NSOperationQueue *queue;
//缓存图片字典----可用数据库替换
@property (nonatomic, strong) NSMutableDictionary *imageCacheDict;
//缓存操作字典
@property (nonatomic, strong) NSMutableDictionary *operationDict;
//记录之前没有进去的操作 回调
@property (nonatomic, strong) NSMutableDictionary *handleDict;
@property (nonatomic, copy)   KCCompleteHandleBlock completeHandle;

@end

@implementation KCWebImageManager

+ (instancetype)sharedManager{
    static KCWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KCWebImageManager alloc] init];
    });
    return manager;
}

// 只要调用单利,就会来到这里 那么我就可以在这里做一系列的初始化
- (instancetype)init{
    if (self=[super init]) {
        
        self.queue.maxConcurrentOperationCount = 2;
        // 注册内存警告通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


/**
 图片下载方法
 */
- (void)downloadImageWithUrlString:(NSString *)urlString completeHandle:(KCCompleteHandleBlock)completeHandle title:(NSString *)title{
    
    //内存获取图片
    UIImage *cacheImage = self.imageCacheDict[urlString];
    if (cacheImage) {
        NSLog(@"从内存缓存获取数据 %@",title);
        completeHandle(cacheImage,urlString);
        return;
    }
    
    //沙盒获取图片 为什么在后面: 因为读取沙盒的速度比内存慢,所以先读内存
    NSString *cachePath = [urlString getDowloadImagePath];
    cacheImage = [UIImage imageWithContentsOfFile:cachePath];
    if (cacheImage) {
        NSLog(@"从沙盒缓存获取数据 %@",title);
        //沙盒图片 存入缓存
        [self.imageCacheDict setObject:cacheImage forKey:urlString];
        completeHandle(cacheImage,urlString);
        return ;
    }
    
    
    //对当前下载图片判断,是否需要创建操作
    if (self.operationDict[urlString]) {
        NSLog(@"正在下载,让子弹飞会 %@",title);
        NSLog(@"正在下载的回调Block %@的%@",title,completeHandle);
        NSMutableArray *mArray = self.handleDict[urlString];
        if (mArray == nil) {
            mArray = [NSMutableArray arrayWithCapacity:1];
        }
        [mArray addObject:completeHandle];
        [self.handleDict setObject:mArray forKey:urlString];
        return;
    }
    
    // 下面就是创建操作 下载 --- 自定义
    KCWebImageDownloadOperation *downOp = [[KCWebImageDownloadOperation alloc] initWithDownloadImageUrl:urlString completeHandle:^(NSData *imageData,NSString *kc_urlString) {
    
        UIImage *downloadImage = [UIImage imageWithData:imageData];
        if (downloadImage) {
            
            [self.imageCacheDict setObject:downloadImage forKey:urlString];
            [self.operationDict removeObjectForKey:urlString];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                completeHandle(downloadImage,kc_urlString);
                //去取回调
                if (self.handleDict[kc_urlString]) {
                    NSMutableArray *mArray = self.handleDict[kc_urlString];
                    for (KCCompleteHandleBlock handleBlock in mArray) {
                        handleBlock(downloadImage,kc_urlString);
                    }
                    [self.handleDict removeObjectForKey:urlString];
                }
            }];
        }
    } title:title];

    // 操作加入队列
    [self.queue addOperation:downOp];
    // 操作缓存
    [self.operationDict setObject:downOp forKey:urlString];
    
}

// 下载操作取消
- (void)cancelDownloadImageWithUrlString:(NSString *)urlString{
    
    // 对于那些简约的dog 这个下载决定后面的下载 如果第一张取消,意味着后面就没了!
//    [self.operationDict removeObjectForKey:urlString];
//    [self.handleDict removeObjectForKey:urlString];
    
    // 下载好的资源
    KCWebImageDownloadOperation *op = self.operationDict[urlString];
    [op cancel];
    
//    // 对于那些简约的dog 这个下载决定后面的下载 如果第一张取消,意味着后面就没了!
    [self.operationDict removeObjectForKey:urlString];
    [self.handleDict removeObjectForKey:urlString];
}


#pragma mark - lazy

- (NSMutableDictionary *)imageCacheDict{
    if (!_imageCacheDict) {
        _imageCacheDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _imageCacheDict;
}

- (NSMutableDictionary *)operationDict{
    if (!_operationDict) {
        _operationDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _operationDict;
}

- (NSMutableDictionary *)handleDict{
    if (!_handleDict) {
        _handleDict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _handleDict;
}

- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

#pragma mark - memoryWarning
- (void)memoryWarning{
    NSLog(@"收到内存警告,你要清理内存了!!!");
    [self.imageCacheDict removeAllObjects];
    //已经有内存警告就不能在执行操作
    [self.queue cancelAllOperations];
    //清空操作
    [self.operationDict removeAllObjects];
    //操作缓存也清除
    [self.handleDict removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


@end
