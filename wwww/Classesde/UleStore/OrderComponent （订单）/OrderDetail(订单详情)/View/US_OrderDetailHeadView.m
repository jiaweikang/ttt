//
//  US_OrderDetailHeadView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailHeadView.h"
#import <UIView+SDAutoLayout.h>
#import "MyWaybillOrderInfo.h"
#import "US_OrderDetailSectionModel.h"
#import "US_LiveChatStatusModel.h"

#define kOrderDetailMargin 8
@implementation US_OrderDetailHeadViewModel



@end


@interface US_OrderDetailHeadView ()

@property (nonatomic, strong) UIImageView * statusImageView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;

@end

@implementation US_OrderDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor convertHexToRGB:@"fff4f4"];
        [self sd_addSubviews:@[self.statusImageView,self.statusLabel,self.subTitleLabel]];
        self.statusImageView.sd_layout.topSpaceToView(self, 15)
        .rightSpaceToView(self, self.width_sd/2.0)
        .widthIs(100)
        .heightIs(80);
        
        self.statusLabel.sd_layout.leftSpaceToView(self.statusImageView, 0)
        .topSpaceToView(self, 24)
        .rightSpaceToView(self, 20)
        .heightIs(20);
        
        self.subTitleLabel.sd_layout.leftEqualToView(self.statusLabel)
        .topSpaceToView(self.statusLabel, 3)
        .rightSpaceToView(self, 20)
        .heightIs(20);
        [self setupAutoHeightWithBottomView:self.statusImageView bottomMargin:0];
    }
    return self;
}

- (void)setModel:(US_OrderDetailHeadViewModel *)model{
    self.statusImageView.image=[UIImage bundleImageNamed:model.statuImageName];
    self.statusLabel.text=model.statuStr;
    self.subTitleLabel.text=model.subStatusStr;
}

#pragma mark - <setter and getter>
- (UIImageView *)statusImageView{
    if (!_statusImageView) {
        _statusImageView=[UIImageView new];
    }
    return _statusImageView;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel=[UILabel new];
        _statusLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _statusLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _statusLabel;
}
- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel=[UILabel new];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}
@end

#pragma mark - <SectionHeaderView>
@interface US_OrderDetailSectionHeadView ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * contactSale;
@end

@implementation US_OrderDetailSectionHeadView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatStatus:) name:NOTI_LiveChatStatus object:nil];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self.contentView sd_addSubviews:@[self.iconImageView,self.titleLabel,self.contactSale]];
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
    .centerYEqualToView(self.contentView)
    .widthIs(18).heightEqualToWidth();
    self.titleLabel.sd_layout.leftSpaceToView(self.iconImageView, kOrderDetailMargin)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(200);
    
    self.contactSale.sd_layout.centerYEqualToView(self.iconImageView)
    .rightSpaceToView(self.contentView, 5)
    .widthIs(90).heightIs(40);
}

- (void)setModel:(US_OrderDetailSectionModel *)model{
    _model=model;
    WaybillOrder * billOrder=(WaybillOrder *)model.headData;
    if ([billOrder.myOrder isEqualToString:@"1"]&&[NSString isNullToString:billOrder.customerService].length > 0) {
        self.contactSale.hidden=NO;
    }else{
        self.contactSale.hidden=YES;
    }
}

#pragma mark - notification
- (void)refreshChatStatus:(NSNotification *)noti{
    US_LiveChatStatusModel *chatStatusModel = (US_LiveChatStatusModel *)[noti object];
    if ([chatStatusModel.data.status isEqualToString:@"offline"]) {
        [_contactSale setImage:[UIImage bundleImageNamed:@"chat_offline"] forState:UIControlStateNormal];
    }
}

#pragma mark - <action>
- (void)contactAction:(id)sender{
    WaybillOrder * billOrder=(WaybillOrder *)_model.headData;
    if ([billOrder.orderTag containsString:ownOrderStatus]) {
        //自有订单 联系商家
        if (self.model.clickActionBlock) {
            self.model.clickActionBlock();
        }
    }else{
        NSString *chatUrl;
        if (billOrder&&[NSString isNullToString:billOrder.customerService].length > 0) {
            chatUrl = [NSString stringWithFormat:@"%@", billOrder.customerService];
            NSMutableDictionary *dic = @{@"key":chatUrl,
                                         KNeedShowNav:billOrder.isShowBanner,
                                         @"title":billOrder.bannerName}.mutableCopy;
            [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        }
    }
}

#pragma mark - <setter and getter>
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
        _iconImageView.image=[UIImage bundleImageNamed:@"myOrder_icon_info"];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.text=@"订单信息";
    }
    return _titleLabel;
}
- (UIButton *)contactSale{
    if (!_contactSale) {
        _contactSale=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        [_contactSale setImage:[UIImage bundleImageNamed:@"chat_online"] forState:UIControlStateNormal];
        [_contactSale setTitle:@" 联系商家" forState:UIControlStateNormal];
        [_contactSale setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        _contactSale.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_contactSale addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactSale;
}

@end



#pragma mark - <SectionFooterView>
@interface US_OrderDetailSectionFootView ()
//@property (nonatomic, strong) UILabel * numberTitle;
//@property (nonatomic, strong) UILabel * priceTitle;
//@property (nonatomic, strong) UILabel * freightTitle;
@property (nonatomic, strong) UILabel * totoalPriceTitle;
@property (nonatomic, strong) UIView * splitLine;
//@property (nonatomic, strong) UILabel * numberLabel;
//@property (nonatomic, strong) UILabel * priceLabel;
//@property (nonatomic, strong) UILabel * freightLabel;
@property (nonatomic, strong) UILabel * totoalLabel;

@end

@implementation US_OrderDetailSectionFootView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self.contentView sd_addSubviews:@[self.splitLine, self.totoalPriceTitle, self.totoalLabel]];
        self.splitLine.sd_layout.leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 5.5)
        .heightIs(0.5);
        self.totoalPriceTitle.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
        .topSpaceToView(self.splitLine, 5)
        .widthIs(100).bottomSpaceToView(self.contentView, 5);
        self.totoalLabel.sd_layout.rightSpaceToView(self.contentView, kOrderDetailMargin)
        .topEqualToView(self.totoalPriceTitle)
        .bottomEqualToView(self.totoalPriceTitle)
        .autoWidthRatio(0);
    }
    return self;
}
- (void)setModel:(UleSectionBaseModel *)model{
    _model=model;
    WaybillOrder * billOrder=(WaybillOrder *)model.footData;
    self.totoalPriceTitle.text=@"实付金额";
    if ([billOrder.order_status intValue]==3) {
        self.totoalPriceTitle.text=@"待支付金额";
    }
    //详情接口返回userPayAmount 用userPayAmount
    if (billOrder.userPayAmount) {
        self.totoalLabel.text=[NSString stringWithFormat:@"¥%.2f", [billOrder.userPayAmount doubleValue]];
    }
    //老的逻辑：显示订单列表带过来的数据
    else{
        if ([billOrder.order_status intValue]==3) {
            self.totoalLabel.text=[NSString stringWithFormat:@"¥%.2f", [billOrder.order_amount doubleValue]-[billOrder.pay_amount doubleValue]];
        }else if ([billOrder.pay_amount floatValue] == 0.00) {
            self.totoalLabel.text = @"未支付";
        } else {
            self.totoalLabel.text = [NSString stringWithFormat:@"¥%.2f", [billOrder.pay_amount doubleValue]];
        }
    }

    [self.totoalLabel setSingleLineAutoResizeWithMaxWidth:300];

}
#pragma mark - <setter and getter>
- (UILabel *) buildTitleLabel:(NSString *)title{
    UILabel * label=[UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.text = title;
    label.textColor = [UIColor convertHexToRGB:@"666666"];
    return label;
}
- (UILabel *)totoalPriceTitle{
    if (!_totoalPriceTitle) {
        _totoalPriceTitle=[self buildTitleLabel:@""];
        _totoalPriceTitle.textColor=[UIColor redColor];
    }
    return _totoalPriceTitle;
}
- (UIView *)splitLine{
    if (!_splitLine) {
        _splitLine=[UIView new];
        _splitLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    }
    return _splitLine;
}
- (UILabel *)totoalLabel{
    if (!_totoalLabel) {
        _totoalLabel= [self buildTitleLabel:@""];
        _totoalLabel.textAlignment=NSTextAlignmentRight;
        _totoalLabel.textColor=[UIColor redColor];
        _totoalLabel.font=[UIFont boldSystemFontOfSize:15];
    }
    return _totoalLabel;
}

@end
