//
//  KCWebImageDownloadOperation.h
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/7.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KCCompleteHandle)(NSData *imageData,NSString *kc_urlString);

@interface KCWebImageDownloadOperation : NSOperation

@property (nonatomic, assign) NSInteger kc_maxConcurrentOperationCount;

- (instancetype)initWithDownloadImageUrl:(NSString *)imageUrlString completeHandle:(KCCompleteHandle)completeHandle title:(NSString *)title;
@end
