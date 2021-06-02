//
//  KCModel.h
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KCModel : NSObject
@property (nonatomic, copy) NSString  *imageUrl;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *money;
// 缓存下载的图片
@property (nonatomic, strong) UIImage *image;
@end
