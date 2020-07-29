//
//  US_RewardDetailVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/19.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_RewardDetailVC.h"
#import "US_RewardCellModel.h"

@interface US_RewardDetailVC ()
@property (nonatomic, strong) UIView * backView2;
@property (nonatomic, strong) UIImageView *statusIconImg;
@property (nonatomic, strong) UILabel *incomeDescLab;
@property (nonatomic, strong) UILabel *amountLab;   //金额
@property (nonatomic, strong) UILabel *timeLab;     //时间
@property (nonatomic, strong) UILabel *orderIDLab;  //订水号
@property (nonatomic, strong) UILabel *timeTitleLab;
@property (nonatomic, strong) UILabel *orderIDTitleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) US_RewardCellModel * rewardDetailModel;
@end

@implementation US_RewardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"奖励金明细"];
    }
    self.rewardDetailModel = [self.m_Params objectForKey:@"RewardDetail"];
    [self setUI];
    [self setData];
}

- (void)setData{
    [self.statusIconImg yy_setImageWithURL:[NSURL URLWithString:self.rewardDetailModel.iconUrl] placeholder:nil];
    self.incomeDescLab.text = self.rewardDetailModel.incomeDesc;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",self.rewardDetailModel.amount]];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
    self.amountLab.attributedText = attributedStr;
    self.amountLab.textColor = [UIColor convertHexToRGB:self.rewardDetailModel.colorValue];
    self.timeLab.text = self.rewardDetailModel.detailTime;
    self.orderIDLab.text = self.rewardDetailModel.orderID;
    self.timeTitleLab.text = self.rewardDetailModel.timeTitle;
    self.orderIDTitleLab.text = @"流水号";

    NSString *str = [NSString stringWithFormat:@"%@",NonEmpty(self.rewardDetailModel.detailDesc)];
    if (self.rewardDetailModel.detailDesc.length>16) {
        NSString *frontStr = [self.rewardDetailModel.detailDesc substringToIndex:16];
        NSScanner *scanner = [NSScanner scannerWithString:frontStr];
        int val;
        if ([scanner scanInt:&val]&&[scanner isAtEnd]) {
            str = [NSString stringWithFormat:@"订单摘要\n%@", self.rewardDetailModel.detailDesc];
        }
    }
    
    self.detailLab.text = str;
    if (str.length == 0) {
        self.backView2.hidden=YES;
    }else{
        self.backView2.hidden=NO;
    }
}

- (void)setUI{
    self.view.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    UIView * backView1 = [UIView new];
    backView1.backgroundColor = [UIColor whiteColor];
    [self.view sd_addSubviews:@[self.incomeDescLab,self.statusIconImg,self.amountLab,backView1]];
    self.incomeDescLab.sd_layout
    .leftSpaceToView(self.view, __MainScreen_Width/2-20)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(self.uleCustemNavigationBar, 20)
    .heightIs(20);
    self.statusIconImg.sd_layout
    .rightSpaceToView(self.incomeDescLab, 3)
    .centerYEqualToView(self.incomeDescLab)
    .widthIs(20)
    .heightIs(20);
    self.amountLab.sd_layout
    .topSpaceToView(self.incomeDescLab, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(35);
    
    [backView1 sd_addSubviews:@[self.orderIDTitleLab,self.orderIDLab,self.timeTitleLab,self.timeLab]];
    self.orderIDTitleLab.sd_layout
    .leftSpaceToView(backView1, 10)
    .topSpaceToView(backView1, 10)
    .widthIs(80)
    .heightIs(25);
    self.orderIDLab.sd_layout
    .leftSpaceToView(self.orderIDTitleLab, 20)
    .rightSpaceToView(backView1, 10)
    .topEqualToView(self.orderIDTitleLab)
    .heightRatioToView(self.orderIDTitleLab, 1);
    self.timeTitleLab.sd_layout
    .leftEqualToView(self.orderIDTitleLab)
    .topSpaceToView(self.orderIDTitleLab, 3)
    .widthRatioToView(self.orderIDTitleLab, 1)
    .heightRatioToView(self.orderIDLab, 1);
    self.timeLab.sd_layout
    .leftEqualToView(self.orderIDLab)
    .rightEqualToView(self.orderIDLab)
    .topEqualToView(self.timeTitleLab)
    .heightRatioToView(self.timeTitleLab, 1);
    [backView1 setupAutoHeightWithBottomViewsArray:@[self.timeTitleLab,self.timeLab] bottomMargin:5];
    backView1.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.amountLab, 20);
    
    [self.view addSubview:self.backView2];
    [self.backView2 addSubview:self.detailLab];
    self.detailLab.sd_layout
    .leftSpaceToView(self.backView2, 10)
    .topSpaceToView(self.backView2, 10)
    .rightSpaceToView(self.backView2, 10)
    .autoHeightRatio(0);
    self.backView2.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(backView1, 10);
    [self.backView2 setupAutoHeightWithBottomView:self.detailLab bottomMargin:10];
}

#pragma mark - <setter and getter>
- (UIImageView *)statusIconImg{
    if (!_statusIconImg) {
        _statusIconImg=[UIImageView new];
    }
    return _statusIconImg;
}
- (UILabel *)incomeDescLab{
    if (!_incomeDescLab) {
        _incomeDescLab=[UILabel new];
        _incomeDescLab.font = [UIFont systemFontOfSize:18];
        _incomeDescLab.textColor = [UIColor blackColor];
    }
    return _incomeDescLab;
}
- (UILabel *)amountLab{
    if (!_amountLab) {
        _amountLab=[UILabel new];
        _amountLab.font = [UIFont systemFontOfSize:35];
        _amountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab=[UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textColor = [UIColor blackColor];
    }
    return _timeLab;
}
- (UILabel *)orderIDLab{
    if (!_orderIDLab) {
        _orderIDLab=[UILabel new];
        _orderIDLab.font = [UIFont systemFontOfSize:15];
        _orderIDLab.textColor = [UIColor blackColor];
        _orderIDLab.adjustsFontSizeToFitWidth=YES;
    }
    return _orderIDLab;
}
- (UILabel *)timeTitleLab{
    if (!_timeTitleLab) {
        _timeTitleLab=[UILabel new];
        _timeTitleLab.font = [UIFont systemFontOfSize:15];
        _timeTitleLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
        _timeTitleLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeTitleLab;
}
- (UILabel *)orderIDTitleLab{
    if (!_orderIDTitleLab) {
        _orderIDTitleLab=[UILabel new];
        _orderIDTitleLab.font = [UIFont systemFontOfSize:15];
        _orderIDTitleLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
        _orderIDTitleLab.textAlignment = NSTextAlignmentRight;
    }
    return _orderIDTitleLab;
}
- (UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab=[UILabel new];
        _detailLab.font = [UIFont systemFontOfSize:14];
        _detailLab.textColor = [UIColor blackColor];
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}
- (UIView *)backView2{
    if (!_backView2) {
        _backView2=[UIView new];
        _backView2.backgroundColor = [UIColor whiteColor];
    }
    return _backView2;
}
@end
