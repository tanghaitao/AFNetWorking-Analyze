//
//  KCModel.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "KCModel.h"

@implementation KCModel
- (NSString *)description{
    return [NSString stringWithFormat:@"%@ 售价 : %@",self.title,self.money];
}
@end
