//
//  KCWebImageManager.h
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/7.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KCCompleteHandleBlock)(UIImage *downloadImage,NSString *urlString);

@interface KCWebImageManager : NSObject

/**
 单利方法
 @return 返回全局单利实例
 */
+ (instancetype)sharedManager;


/**
 图片下载方法

 @param urlString 图片下载地址
 @param completeHandle 下载后的回调
 */
- (void)downloadImageWithUrlString:(NSString *)urlString completeHandle:(KCCompleteHandleBlock)completeHandle title:(NSString *)title;


/**
 取消下载操作
 */
- (void)cancelDownloadImageWithUrlString:(NSString *)urlString;
@end
