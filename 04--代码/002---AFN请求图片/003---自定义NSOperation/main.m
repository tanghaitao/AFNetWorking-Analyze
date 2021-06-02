//
//  main.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    /**
     
     和谐学习,不急不躁,我是Cooci
     
     @autoreleasepool 使用场景,作用
        * 延长生命周期
        * 大量临时变量的产生
        * 自定义线程管理
     */
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
