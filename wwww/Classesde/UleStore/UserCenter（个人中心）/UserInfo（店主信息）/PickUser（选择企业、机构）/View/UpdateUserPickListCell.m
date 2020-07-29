//
//  UpdateUserPickListCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserPickListCell.h"
#import <UIView+SDAutoLayout.h>
#import "AttributionPickCellModel.h"

@interface UpdateUserPickListCell ()
@property (nonatomic, strong)UILabel        *titleLab;
@property (nonatomic, strong)UIView         *lineView;
@end

@implementation UpdateUserPickListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab,self.lineView]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0)
    .minHeightIs(40);
    self.lineView.sd_layout.topSpaceToView(self.titleLab, 0)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}

- (void)setModel:(AttributionPickCellModel *)model{
    self.titleLab.text=model.contentStr;
    self.titleLab.textColor=model.isContentSelected?[UIColor convertHexToRGB:@"EC3D3F"]:[UIColor convertHexToRGB:@"333333"];
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.numberOfLines=0;
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.font=[UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _lineView;
}
@end
