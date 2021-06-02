//
//  KCCollectionViewCell.m
//  003---自定义NSOperation
//
//  Created by Cooci on 2018/7/6.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "KCCollectionViewCell.h"

@implementation KCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.imageView.frame  = CGRectMake(0, 0, self.contentView.bounds.size.width, 200);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.contentView.bounds.size.width, 30);
    self.moneyLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.contentView.bounds.size.width, 30);
}

#pragma mark - lazy

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel               = [[UILabel alloc] init];
        _titleLabel.text          = @"千王之王";
        _titleLabel.textColor     = [UIColor grayColor];
        _titleLabel.font          = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel               = [[UILabel alloc] init];
        _moneyLabel.text          = @"1000";
        _moneyLabel.textColor     = [UIColor orangeColor];
        _moneyLabel.font          = [UIFont boldSystemFontOfSize:20];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}
@end
