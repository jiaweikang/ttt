//
//  US_OrderListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListCell.h"
#import <UIView+SDAutoLayout.h>
#import "MyWaybillOrderInfo.h"
#import "OrderCellButton.h"
#define kOrderListCellMargin 8
#define kOrderListImgSize  KScreenScale(190)

@interface US_OrderListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;   //规格
@property (nonatomic, strong) UILabel *priceLabel;  //价格
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) OrderCellButton * replaceBtn;
@property (nonatomic, strong) UIImageView *prdImageView;
@property (nonatomic, strong) UILabel *deliveryTimeLabel;
@end

@implementation US_OrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor= [UIColor convertHexToRGB:@"fafafa"];
    [self.contentView sd_addSubviews:@[self.titleLabel,self.numberLabel,self.sizeLabel,self.priceLabel,self.prdImageView,self.deliveryTimeLabel,self.replaceBtn]];
    self.prdImageView.sd_layout.leftSpaceToView(self.contentView, kOrderListCellMargin)
    .topSpaceToView(self.contentView, kOrderListCellMargin)
    .widthIs(kOrderListImgSize)
    .heightEqualToWidth();
    
    self.titleLabel.sd_layout.leftSpaceToView(self.prdImageView, kOrderListCellMargin)
    .topSpaceToView(self.contentView, kOrderListCellMargin)
    .rightSpaceToView(self.contentView, kOrderListCellMargin)
    .heightIs(KScreenScale(70));
    
    self.priceLabel.sd_layout.leftEqualToView(self.titleLabel)
    .bottomEqualToView(self.prdImageView)
    .heightIs(KScreenScale(30)).autoWidthRatio(0);
    
    self.numberLabel.sd_layout.rightSpaceToView(self.contentView, kOrderListCellMargin)
    .bottomEqualToView(self.prdImageView)
    .heightIs(KScreenScale(30)).autoWidthRatio(0);
    
    self.deliveryTimeLabel.sd_layout.leftEqualToView(self.priceLabel)
    .topSpaceToView(self.priceLabel, 0)
    .rightSpaceToView(self.contentView, kOrderListCellMargin)
    .heightIs(0);
    
    self.replaceBtn.sd_layout.rightSpaceToView(self.contentView, kOrderListCellMargin)
    .topSpaceToView(self.deliveryTimeLabel, 5)
    .widthIs(60).heightIs(25);
    
    self.sizeLabel.sd_layout.leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, KScreenScale(10))
    .heightIs(KScreenScale(30)).autoWidthRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.prdImageView,self.deliveryTimeLabel] bottomMargin:kOrderListCellMargin];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(US_OrderListCellModel *)model{
    _model=model;
    PrdInfo * prdInfo=(PrdInfo *)self.model.data;
    [self.prdImageView yy_setImageWithURL:[NSURL URLWithString:model.imageUrlStr] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    self.titleLabel.text=model.listNameStr;
    self.sizeLabel.text=model.sizeStr;
    self.priceLabel.text=model.priceStr;
    self.numberLabel.text=model.numberStr;
    [self.sizeLabel setSingleLineAutoResizeWithMaxWidth:__MainScreen_Width-kOrderListImgSize];
    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:300];
    [self.numberLabel setSingleLineAutoResizeWithMaxWidth:200];
    if (self.model.isOrdeDetailList) {
        if (prdInfo.estimatedDeliveryTime.length>0) {
            self.deliveryTimeLabel.text=prdInfo.estimatedDeliveryTime;
            self.deliveryTimeLabel.sd_layout.heightIs(25);
        }else{
            self.deliveryTimeLabel.text=@"";
            self.deliveryTimeLabel.sd_layout.heightIs(0);
        }
        BOOL canreplace=[self.model.isCanReplace isEqualToString:@"1"]?YES:NO;
        self.replaceBtn.hidden=!canreplace;
        if (canreplace) {
            [self setupAutoHeightWithBottomView:self.replaceBtn bottomMargin:kOrderListCellMargin];
        }else{
            [self setupAutoHeightWithBottomViewsArray:@[self.prdImageView,self.deliveryTimeLabel] bottomMargin:kOrderListCellMargin];
        }
    }
}

- (void)orderCellButtonClick:(id)sender{
    if ([self.model.order_tag containsString:sameCityOrderStatus] && ![NonEmpty([UleStoreGlobal shareInstance].config.clientType) isEqualToString:@"ylxdsq"]) {
        if (self.model.replaceBtnSameCityBlock) {
            self.model.replaceBtnSameCityBlock();
        }
    }else {
        PrdInfo * prdInfo=(PrdInfo *)self.model.data;
        NSString * url = [NSString stringWithFormat:@"%@/myReturnOrderWapWeb/mobileSelectReturn.do?escOrderid=%@&deleveryOrderid=%@&itemid=%@", [UleStoreGlobal shareInstance].config.commodityDomain, NonEmpty(self.model.esc_orderId), NonEmpty(self.model.deleveryOrderid), NonEmpty(prdInfo.item_id)];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:url forKey:@"key"];
        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    }
}

#pragma mark - <setter and getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _titleLabel;
}
- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel=[UILabel new];
        _numberLabel.textAlignment=NSTextAlignmentRight;
        _numberLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _numberLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
    }
    return _numberLabel;
}
- (UILabel *)sizeLabel{
    if (!_sizeLabel) {
        _sizeLabel=[UILabel new];
        _sizeLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _sizeLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
    }
    return _sizeLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel=[UILabel new];
        _priceLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _priceLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
    }
    return _priceLabel;
}
- (UIImageView *)prdImageView{
    if (!_prdImageView) {
        _prdImageView=[UIImageView new];
    }
    return _prdImageView;
}
- (OrderCellButton *)replaceBtn{
    if (!_replaceBtn) {
        _replaceBtn=[[OrderCellButton alloc] init];
        _replaceBtn.buttonState=OrderButtonStateReturnGoods;
        _replaceBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _replaceBtn.sd_cornerRadiusFromHeightRatio = @(0.5);
        [_replaceBtn addTarget:self action:@selector(orderCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _replaceBtn.hidden=YES;
    }
    return _replaceBtn;
}
- (UILabel *)deliveryTimeLabel{
    if (!_deliveryTimeLabel) {
        _deliveryTimeLabel=[UILabel new];
        _deliveryTimeLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _deliveryTimeLabel.adjustsFontSizeToFitWidth=YES;
        _deliveryTimeLabel.textColor = _priceLabel.textColor;
    }
    return _deliveryTimeLabel;
}
@end
