//
//  ViewController.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"
#import "KCCollectionViewCell.h"
#import "NSString+KCAdd.h"
#import "KCViewModel.h"
#import "KCWebImageManager.h"
#import "UIImageView+KCWebCache.h"
#import <UIImageView+AFNetworking.h>

#define KCScreenW [UIScreen mainScreen].bounds.size.width
#define KCScreenH [UIScreen mainScreen].bounds.size.height

static NSString *reuseID = @"reuseID";


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) KCViewModel       *viewModel;
//下载队列
@property (nonatomic, strong) NSOperationQueue *queue;
//缓存图片字典----可用数据库替换
@property (nonatomic, strong) NSMutableDictionary *imageCacheDict;
//缓存操作字典
@property (nonatomic, strong) NSMutableDictionary *operationDict;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    //添加到视图
    [self.view addSubview:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.viewModel = [[KCViewModel alloc] initWithBlock:^(id data) {
        [weakSelf.dataArray addObjectsFromArray:(NSArray *)data];
        [weakSelf.collectionView reloadData];
    } fail:nil];
        
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KCCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    KCModel *model        = self.dataArray[indexPath.row];
    cell.titleLabel.text  = model.title;
    cell.moneyLabel.text  = model.money;
//    [cell.imageView kc_setImageWithUrlString:model.imageUrl title:model.title indexPath:indexPath];
    // imageView.image = placehold
    // 延迟 跟sdwebimage不同，自己写了沙盒机制，其实sdwebimage同一个url可以刷新内存，保证服务器返回的图片是最新的
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.imageUrl]];

    //[cell.imageView cancelImageDownloadTask]; // task -- recep
    return cell;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //创建一个流水布局
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection              = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing      = 5;
        layout.minimumLineSpacing           = 5;
        layout.itemSize                     = CGSizeMake((KCScreenW-15)/2.0, 260);
        
        //初始化collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, KCScreenW-10, KCScreenH) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollsToTop    = NO;
        _collectionView.pagingEnabled   = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces         = YES;
        _collectionView.dataSource      = self;
        _collectionView.delegate        = self;
        [_collectionView registerClass:[KCCollectionViewCell class] forCellWithReuseIdentifier:reuseID];
   
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        // 解释一波关于数组 capacity 每次都是开辟10单位内存
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}

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

- (void)didReceiveMemoryWarning{
    NSLog(@"收到内存警告,你要清理内存了!!!");
    [self.imageCacheDict removeAllObjects];
    //已经有内存警告就不能在执行操作
    [self.queue cancelAllOperations];
    //清空操作
    [self.operationDict removeAllObjects];
    
}
@end


