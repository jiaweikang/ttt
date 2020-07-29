//
//  AttributionPickTableHeaderView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "AttributionPickTableHeaderView.h"
#import "UleTableViewCellProtocol.h"
#import <UIView+SDAutoLayout.h>
#import "AttributionPickHeaderModel.h"


@interface AttributionPickTableHeaderView ()<UleTableViewCellProtocol>
@property (nonatomic, strong)UILabel    *titleLab;

@end

@implementation AttributionPickTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f0f0f0"];
    [self.contentView addSubview:self.titleLab];
    self.titleLab.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 15, 0, 15));
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"d9d9d9"];
    [self.contentView addSubview:lineView];
    lineView.sd_layout.topSpaceToView(self.titleLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(1.0);
}

-(void)setModel:(AttributionPickHeaderModel *)model
{
    self.titleLab.text=model.headTitle;
}

#pragma mark - <getter>
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, __MainScreen_Width-30, KScreenScale(60)-1)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
    }
    return _titleLab;
}

@end
