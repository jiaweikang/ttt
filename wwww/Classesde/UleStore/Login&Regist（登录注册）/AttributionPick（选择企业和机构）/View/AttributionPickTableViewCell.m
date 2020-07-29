//
//  AttributionPickTableViewCell.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "AttributionPickTableViewCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleTableViewCellProtocol.h"
#import "AttributionPickCellModel.h"

@interface AttributionPickTableViewCell ()<UleTableViewCellProtocol>
@property (nonatomic, strong)UILabel        *contentLab;
@property (nonatomic, strong)UIImageView    *selImgView;
@property (nonatomic, strong)UIView         *lineView;

@end

@implementation AttributionPickTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f0f0f0"];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView sd_addSubviews:@[self.contentLab,self.selImgView,self.lineView]];
        self.contentLab.sd_layout.topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 15)
        .widthIs(0)
        .heightIs(30);
        self.selImgView.sd_layout.centerYEqualToView(self.contentLab)
        .leftSpaceToView(self.contentLab, 5)
        .widthIs(0)
        .heightIs(KScreenScale(40));
        self.lineView.sd_layout.topSpaceToView(self.contentLab, 10)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(1.0);
        
        [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
    }
    return self;
}

-(void)setModel:(AttributionPickCellModel *)model
{
    self.contentLab.text=[NSString stringWithFormat:@"%@", model.contentStr];
    CGFloat contentWidth=[self.contentLab.text widthForFont:self.contentLab.font]+5;
    self.contentLab.sd_layout.widthIs(contentWidth);
    if (model.isContentSelected) {
        self.selImgView.sd_layout.widthIs(KScreenScale(40));
    }else {
        self.selImgView.sd_layout.widthIs(0);
    }
    
    [self.selImgView updateLayout];
}

#pragma mark - <getters>
- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab=[[UILabel alloc]init];
        _contentLab.textColor = [UIColor convertHexToRGB:@"666666"];
        _contentLab.font = [UIFont systemFontOfSize:16.0];
    }
    return _contentLab;
}

- (UIImageView *)selImgView
{
    if (!_selImgView) {
        _selImgView = [[UIImageView alloc]init];
        [_selImgView setImage:[UIImage bundleImageNamed:@"regis_img_attribution_selected"]];
    }
    return _selImgView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
    }
    return _lineView;
}

@end
