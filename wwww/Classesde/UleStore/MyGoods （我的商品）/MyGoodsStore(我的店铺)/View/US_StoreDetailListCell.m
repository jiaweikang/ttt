//
//  US_StoreDetailListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/11.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_StoreDetailListCell.h"
#import <UIView+SDAutoLayout.h>
#import <NSString+Utility.h>
#import "USShareView.h"


@interface US_StoreDetailListCell ()
@property (nonatomic, strong) UIImageView * prdImageView;
@property (nonatomic, strong) UILabel * prdNameLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * saleNumLabel;
@property (nonatomic, strong) UILabel * profitLabel;
@property (nonatomic, strong) UIImageView *groupFlag; //拼团标签
@property (nonatomic, strong) UIButton * shareButton;
@end

@implementation US_StoreDetailListCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        self.backgroundColor=[UIColor whiteColor];
        UIView * horizeLine=[UIView new];
        horizeLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
        
        UIView * splitLine=[UIView new];
        splitLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
        
        [self.contentView sd_addSubviews:@[self.prdImageView,self.prdNameLabel,self.saleNumLabel,self.priceLabel,self.profitLabel,self.shareButton,self.groupFlag]];
        self.prdImageView.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightEqualToWidth();
        
        self.groupFlag.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, KScreenScale(15))
        .widthIs(KScreenScale(66)).heightIs(KScreenScale(40));
        
        self.prdNameLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdImageView, KScreenScale(10))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(35));
        
        self.priceLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .autoWidthRatio(0)
        .heightIs(KScreenScale(35));
        
        self.saleNumLabel.sd_layout.topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(35))
        .autoWidthRatio(0);
        
        self.profitLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.priceLabel, KScreenScale(15))
        .heightIs(KScreenScale(35))
        .widthIs(0);
        
        self.shareButton.sd_layout.rightSpaceToView(self.contentView, KScreenScale(15))
        .centerYEqualToView(self.profitLabel)
        .widthIs(KScreenScale(50))
        .heightEqualToWidth();
    }
    return self;
}
- (void)setModel:(USStoreDetailListingItem *)model{
    _model=model;
    [self.prdImageView yy_setImageWithURL:[NSURL URLWithString:model.defImgUrl] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    self.prdNameLabel.text=[NSString stringWithFormat:@"%@",NonEmpty(model.listName)];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:200];
    //佣金和拼团标签的显示逻辑
    NSString *commission = [model.commission description].length>0 ? [model.commission description] : @"0.00";
    self.profitLabel.text = [NSString stringWithFormat:@"赚¥%.2f", commission.floatValue];
    if ([US_UserUtility commisionTitle].length>0) {
        self.profitLabel.text = [[US_UserUtility commisionTitle] stringByReplacingOccurrencesOfString:@"XXX" withString:[NSString stringWithFormat:@"%.2f", commission.floatValue]];
    }
    [self.profitLabel setSingleLineAutoResizeWithMaxWidth:200];
    if ([model.groupFlag isEqualToString:@"1"]) { //团购商品 显示拼团标签且隐藏收益
        self.groupFlag.hidden = NO;
        self.profitLabel.hidden = YES;
    } else { //正常商品 若收益为0也隐藏收益
        self.groupFlag.hidden = YES;
        if ([[NSString stringWithFormat:@"%.2f", commission.floatValue] isEqualToString:@"0.00"]) {
            self.profitLabel.hidden = YES;
        } else {
            self.profitLabel.hidden = NO;
        }
    }

}
#pragma mark - <share Click>

- (void)shareClick:(id)sender{
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", _model.listId];
    shareModel.shareCommission=[USShareModel tranforCommitionStr:[NSString stringWithFormat:@"%@",_model.commission]];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",_model.sharePrice];
    shareModel.marketPrice=[NSString stringWithFormat:@"%@",_model.maxPrice];
    shareModel.listName=[NSString stringWithFormat:@"%@",_model.listName];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@",_model.defImgUrl];
    shareModel.isNeedSaveQRImage=YES;
    shareModel.logPageName=@"店铺详情";
    shareModel.logShareFrom=@"商品列表";
    shareModel.shareFrom=@"1";
    shareModel.shareChannel=@"1";
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
        
    }];
}

#pragma mark - <setter and getter>
- (UIImageView *)prdImageView{
    if (!_prdImageView) {
        _prdImageView=[[UIImageView alloc] init];
    }
    return _prdImageView;
}

- (UILabel *)prdNameLabel{
    if (!_prdNameLabel) {
        _prdNameLabel=[UILabel new];
        _prdNameLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _prdNameLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
    }
    return _prdNameLabel;
}
- (UILabel *)saleNumLabel{
    if (!_saleNumLabel) {
        _saleNumLabel=[UILabel new];
        _saleNumLabel.textAlignment=NSTextAlignmentRight;
        _saleNumLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _saleNumLabel.textColor=[UIColor convertHexToRGB:@"999999"];
    }
    return _saleNumLabel;
}
- (UILabel *)profitLabel{
    if (!_profitLabel) {
        _profitLabel=[UILabel new];
        _profitLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _profitLabel.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        _profitLabel.textAlignment=NSTextAlignmentLeft;        
    }
    return _profitLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel=[UILabel new];
        _priceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _priceLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
    }
    return _priceLabel;
}
- (UIImageView *)groupFlag{
    if (!_groupFlag) {
        _groupFlag=[UIImageView new];
        _groupFlag.image=[UIImage bundleImageNamed:@"myGoods_img_groupbuy"];
    }
    return _groupFlag;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton=[[UIButton alloc] initWithFrame:CGRectZero];
        [_shareButton setImage:[UIImage bundleImageNamed:@"goods_earnings_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
@end
