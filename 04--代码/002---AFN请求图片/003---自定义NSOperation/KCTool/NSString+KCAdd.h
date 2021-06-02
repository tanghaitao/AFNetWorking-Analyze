//
//  NSString+KCAdd.h
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KCAdd)
/**
 下载图片的路径
 
 @return MD5加密的图片下载地址
 */
- (NSString *)getDowloadImagePath;
@end
