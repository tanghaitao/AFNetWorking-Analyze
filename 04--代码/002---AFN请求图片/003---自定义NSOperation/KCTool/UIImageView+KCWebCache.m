//
//  UIImageView+KCWebCache.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/10.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "UIImageView+KCWebCache.h"
#import "KCWebImageManager.h"
#import <objc/runtime.h>

const char *kcAssociatedKey_imageUrlString = "kcAssociatedKey_imageUrlString";
const char *kcAssociatedKey_title = "kcAssociatedKey_title";

@implementation UIImageView (KCWebCache)
/**
 给imageView 设置图片
 
 @param urlString 图片地址
 */
- (void)kc_setImageWithUrlString:(NSString *)urlString title:(NSString *)title indexPath:(NSIndexPath *)indexPath{
        
    if (!urlString) {
        NSLog(@"下载地址为空");
        return;
    }
    
    if ([self.kc_urlString isEqualToString:urlString]) {
        NSLog(@"%@ 两次下载地址一样的 没必要重复下载",title);
        return;
    }
    
    if (self.kc_urlString && self.kc_urlString.length>0 && ![self.kc_urlString isEqualToString:urlString]) {
//        NSLog(@"取消之前的下载操作 %@",title);
        NSLog(@"取消%@之前的下载操作:%@---%@ \n%@---%@",indexPath,self.kc_title,title,self.kc_urlString,urlString);
        [[KCWebImageManager sharedManager] cancelDownloadImageWithUrlString:self.kc_urlString];
    }
    //新操作要开始下载 就要记录
    self.kc_urlString = urlString;
    self.kc_title = title;
    self.image = nil;
    
    [[KCWebImageManager sharedManager] downloadImageWithUrlString:urlString completeHandle:^(UIImage *downloadImage,NSString *urlString) {
        //下载完成 要制空
        if ([urlString isEqualToString:self.kc_urlString]) {
            self.kc_urlString = nil;
            self.kc_title = nil;
            self.image = downloadImage;
        }
    } title:title];
}

- (void)setKc_urlString:(NSString *)kc_urlString{
    /**
     1: 绑定的对象
     2: 关联键,通过这个键去找
     3: 值
     4: 关联策略
     */
    objc_setAssociatedObject(self, kcAssociatedKey_imageUrlString, kc_urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)kc_urlString{
    return objc_getAssociatedObject(self, kcAssociatedKey_imageUrlString);
}

- (void)setKc_title:(NSString *)kc_title{
    objc_setAssociatedObject(self, kcAssociatedKey_title, kc_title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)kc_title{
    return objc_getAssociatedObject(self, kcAssociatedKey_title);
}

@end
