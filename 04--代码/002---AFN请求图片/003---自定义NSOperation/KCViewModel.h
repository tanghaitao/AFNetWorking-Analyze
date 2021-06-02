//
//  KCViewModel.h
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCModel.h"
typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(id data);

@interface KCViewModel : NSObject
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailBlock failBlock;

- (instancetype)initWithBlock:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
@end
