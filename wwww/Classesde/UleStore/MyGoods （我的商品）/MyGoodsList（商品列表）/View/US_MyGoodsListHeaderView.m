//
//  US_MyGoodsListHeaderView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsListHeaderView.h"
#import <UIView+SDAutoLayout.h>

@interface US_MyGoodsListHeaderView ()

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation US_MyGoodsListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return self;
}

- (void)setModel:(UleSectionBaseModel *)model{
    self.titleLabel.text=[NSString stringWithFormat:@"共%@件商品",(NSString *)model.sectionData];
}

#pragma mark - <setter and getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor=[UIColor grayColor];
        _titleLabel.font=[UIFont systemFontOfSize:13];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
