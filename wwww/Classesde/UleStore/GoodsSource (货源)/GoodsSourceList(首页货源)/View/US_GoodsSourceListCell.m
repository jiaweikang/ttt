//
//  US_GoodsSourceListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceListCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"
#import "US_GoodsCatergoryListData.h"
#import <NSString+Utility.h>
#import "US_CommisionLabel.h"
#import "USShareView.h"
#import <YYLabel.h>
@interface US_GoodsSourceListCell ()

@property (nonatomic, strong) YYAnimatedImageView * prdImageView;
@property (nonatomic, strong) YYAnimatedImageView * cornerImageView;
@property (nonatomic, strong) YYLabel * prdNameLabel;
@property (nonatomic, strong) YYLabel * priceLabel;
@property (nonatomic, strong) UILabel * saleNumLabel;
@property (nonatomic, strong) YYLabel * profitLabel;
@property (nonatomic, strong) UIButton * shareButton;
@end


@implementation US_GoodsSourceListCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        _cornerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(6, 0, KScreenScale(96), KScreenScale(79))];
        [self.contentView sd_addSubviews:@[self.prdImageView,self.prdNameLabel,self.saleNumLabel,self.priceLabel,self.profitLabel,self.shareButton,_cornerImageView]];
        self.prdImageView.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightEqualToWidth();
        
        _cornerImageView.sd_layout.leftSpaceToView(self.contentView, 6)
        .topSpaceToView(self.contentView, 0)
        .widthIs(KScreenScale(96))
        .heightIs(KScreenScale(79));
        
        self.prdNameLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdImageView, KScreenScale(10))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(35));
        
        self.priceLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .widthRatioToView(self.prdNameLabel, 0.5)
        .heightIs(KScreenScale(35));
        
        self.saleNumLabel.sd_layout.topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(35))
        .widthRatioToView(self.prdNameLabel, 0.5);
        
        self.shareButton.sd_layout.topSpaceToView(self.priceLabel, KScreenScale(15))
        .rightSpaceToView(self.contentView, 10)
        .widthIs(KScreenScale(50))
        .heightIs(KScreenScale(50));
        
        self.profitLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.priceLabel, KScreenScale(15))
        .heightIs(KScreenScale(35))
        .rightSpaceToView(self.shareButton, KScreenScale(15));
    }
    return self;
}

- (void)setModel:(US_GoodsCellModel *)model{
    _model=model;
    NSString *imgUrlStr=[NSString stringWithFormat:@"%@", model.imgeUrl];
    if ([imgUrlStr rangeOfString:@"ule.com"].location!=NSNotFound) {
        imgUrlStr = [NSString getImageUrlString:kImageUrlType_L withurl:imgUrlStr];
    }
    [self.prdImageView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    [self.cornerImageView yy_setImageWithURL:[NSURL URLWithString:model.iconImage] placeholder:nil];
    
    self.prdNameLabel.text=[NSString stringWithFormat:@"%@", model.listingName];
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f", [model.minPrice floatValue]];
    NSString * soldstr=[NSString stringWithFormat:@"已售%@件", model.totalSold];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:soldstr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(2, soldstr.length-3)];
    self.saleNumLabel.attributedText = attributedStr;
    NSString *commission = (model.commission) ? ([NSString stringWithFormat:@"%@", model.commission]) : (model.commission ? [NSString stringWithFormat:@"%@", model.commission] : @"0.00");
    if ([[NSString stringWithFormat:@"%.2f", [commission floatValue]] isEqualToString:@"0.00"]) {
        self.profitLabel.sd_layout.widthIs(0);
    }else{
        self.profitLabel.text = [NSString stringWithFormat:@"赚:¥%.2f", [commission floatValue]];
        if ([US_UserUtility commisionTitle].length>0) {
            self.profitLabel.text = [[US_UserUtility commisionTitle] stringByReplacingOccurrencesOfString:@"XXX" withString:[NSString stringWithFormat:@"%.2f", [commission floatValue]]];
        }
    }

}
#pragma mark - <button action>
- (void)didShareClick:(id)sender{
    US_GoodsCatergoryListItem * item=(US_GoodsCatergoryListItem *)self.model.data;
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", item.listingId];
    shareModel.shareCommission=[USShareModel tranforCommitionStr:[NSString stringWithFormat:@"%@",item.commission]];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",item.minPrice];
    shareModel.marketPrice=[NSString stringWithFormat:@"%@",item.maxPrice];
    shareModel.listName=[NSString stringWithFormat:@"%@", item.listingName];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", item.imgUrl];
    shareModel.isNeedSaveQRImage=YES;
    shareModel.logPageName=self.model.logPageName;
    shareModel.logShareFrom=self.model.logShareFrom;
    shareModel.shareChannel=self.model.shareChannel;
    shareModel.shareFrom=self.model.shareFrom;
    shareModel.srcid=Srcid_Index_TabPrd;
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
        
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShareGoodsWithListId:)]) {
        [self.delegate didShareGoodsWithListId:item.listingId];
    }
}

#pragma mark  <setter and getter>
- (YYAnimatedImageView *)prdImageView{
    if (!_prdImageView) {
        _prdImageView=[[YYAnimatedImageView alloc] init];
        _prdImageView.userInteractionEnabled=YES;
        _prdImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _prdImageView;
}

- (YYLabel *)prdNameLabel{
    if (!_prdNameLabel) {
        _prdNameLabel=[YYLabel new];
        _prdNameLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _prdNameLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _prdNameLabel.displaysAsynchronously=NO;
    }
    return _prdNameLabel;
}
- (UILabel *)saleNumLabel{
    if (!_saleNumLabel) {
        _saleNumLabel=[UILabel new];
        _saleNumLabel.textAlignment=NSTextAlignmentRight;
        _saleNumLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _saleNumLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _saleNumLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _saleNumLabel;
}
- (YYLabel *)profitLabel{
    if (!_profitLabel) {
        _profitLabel=[YYLabel new];
        _profitLabel.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        _profitLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _profitLabel.backgroundColor=[UIColor whiteColor];
        _profitLabel.textAlignment=NSTextAlignmentLeft;
        //        _profitLabel.clipsToBounds=YES;
        
    }
    return _profitLabel;
}
- (YYLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel=[YYLabel new];
        _priceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _priceLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        //        _priceLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _priceLabel;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton=[[UIButton alloc] init];
        [_shareButton setImage:[UIImage bundleImageNamed:@"goods_earnings_share"] forState:UIControlStateNormal];
        [_shareButton setBackgroundColor:[UIColor clearColor]];
        [_shareButton addTarget:self action:@selector(didShareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end



