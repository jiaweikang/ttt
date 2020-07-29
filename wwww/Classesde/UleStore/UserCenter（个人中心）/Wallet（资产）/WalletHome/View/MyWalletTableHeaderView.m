//
//  MyWalletTableHeaderView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/9/25.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyWalletTableHeaderView.h"
#import <UIView+SDAutoLayout.h>

@interface MyWalletTableHeaderView ()
@property (nonatomic, strong)UILabel    * titleLab;
@end

@implementation MyWalletTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView sd_addSubviews:@[self.titleLab]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _titleLab.font=[UIFont systemFontOfSize:14];
    }
    return _titleLab;
}

@end
