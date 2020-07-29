//
//  USDrawLotteryResultView.m
//  u_store
//
//  Created by xulei on 2019/2/25.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USDrawLotteryResultView.h"
#import "UIView+ShowAnimation.h"
//#import "ActivityUtility.h"
#import <UIView+SDAutoLayout.h>
#import "USRedPacketCashManager.h"

@implementation USDrawLotteryResultModel

@end

@interface USDrawLotteryResultView ()
@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) UILabel   *priceMoneyLab;
@property (nonatomic, strong) UILabel   *priceTypeLab;
@property (nonatomic, strong) UILabel   *promoteLab;
@property (nonatomic, strong) UILabel   *mainCongriLab;
@property (nonatomic, strong) UILabel   *subCongriLab;

@property (nonatomic, strong) UIButton  *toWalletBtn;

@end

@implementation USDrawLotteryResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, KScreenScale(667), KScreenScale(651)+KScreenScale(65))]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setImage:[UIImage bundleImageNamed:@"drawLottery_btn_close"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    dismissBtn.sd_layout.topSpaceToView(self, 0)
    .rightSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(60))
    .heightIs(KScreenScale(60));
    
    [self addSubview:self.imgView];
    [self.imgView addSubview:self.priceMoneyLab];
    [self.imgView addSubview:self.priceTypeLab];
    [self.imgView addSubview:self.promoteLab];
    [self.imgView addSubview:self.mainCongriLab];
    [self.imgView addSubview:self.subCongriLab];
    self.imgView.sd_layout.topSpaceToView(self, KScreenScale(65))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    self.priceMoneyLab.sd_layout.topSpaceToView(self.imgView, KScreenScale(45))
    .centerXEqualToView(self.imgView)
    .widthIs(0)
    .heightIs(KScreenScale(100));
    
    self.priceTypeLab.sd_layout.leftSpaceToView(self.priceMoneyLab, 3)
    .centerYEqualToView(self.priceMoneyLab)
    .widthIs(20)
    .heightIs(60);
    self.promoteLab.sd_layout.topSpaceToView(self.priceMoneyLab, KScreenScale(10))
    .leftSpaceToView(self.imgView, KScreenScale(120))
    .rightSpaceToView(self.imgView, KScreenScale(120))
    .heightIs(KScreenScale(40));
    self.mainCongriLab.sd_layout.topSpaceToView(self.promoteLab, KScreenScale(30))
    .leftEqualToView(self.promoteLab)
    .rightEqualToView(self.promoteLab)
    .heightRatioToView(self.promoteLab, 1.0);
    self.subCongriLab.sd_layout.topSpaceToView(self.mainCongriLab, KScreenScale(10))
    .leftEqualToView(self.promoteLab)
    .rightEqualToView(self.promoteLab)
    .heightRatioToView(self.promoteLab, 1.0);
   
    [self.imgView addSubview:self.toWalletBtn];
    self.toWalletBtn.sd_layout.bottomSpaceToView(self.imgView, KScreenScale(30))
    .centerXEqualToView(self.imgView)
    .widthIs(150)
    .heightIs(KScreenScale(80));
    UIButton *toHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toHomeBtn setImage:[UIImage bundleImageNamed:@"drawLottery_btn_toHome"] forState:UIControlStateNormal];
    [toHomeBtn setImage:[UIImage bundleImageNamed:@"drawLottery_btn_toHome"] forState:UIControlStateHighlighted];
    [toHomeBtn addTarget:self action:@selector(toHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:toHomeBtn];
    toHomeBtn.sd_layout.centerXEqualToView(self.imgView)
    .bottomSpaceToView(self.toWalletBtn, KScreenScale(10))
    .widthIs(KScreenScale(572))
    .heightIs(KScreenScale(112));
}

#pragma mark - <ACTION>
- (void)dismissAction{
    [self hiddenView];
}

- (void)toHomeAction{
    [self hiddenView];
    [[USRedPacketCashManager sharedManager] uleRedPacketGotoHomePage];
}

- (void)toWalletAction:(UIButton *)sender{
    [self hiddenView];
    if ([sender.titleLabel.text isEqualToString:@"查看我的资产"]) {
        //跳转我的资产
        [[UIViewController currentViewController] pushNewViewController:@"US_MyWalletVC" isNibPage:NO withData:nil];
    }else if ([sender.titleLabel.text isEqualToString:@"查看中奖记录"]) {
        if ([NSString isNullToString:_model.text_url].length>0) {
            NSMutableDictionary * dic  = @{@"key":[NSString isNullToString:_model.text_url]}.mutableCopy;
            [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        }
    }
}

- (void)setModel:(USDrawLotteryResultModel *)model{
    if (!model) {
        return;
    }
    
    _model=model;
    NSString *priceMoneyStr=@"";
    NSString *prizeTypeStr=@"";
    NSString *promoteStr=@"";
    NSString *mainCongriStr=@"";
    NSString *subCongriStr=@"";
    CGFloat priceMoneyMaxWidth=KScreenScale(420);
    NSString *expiredEndDateStr = [NSString isNullToString:model.expiredEndDate];
    if (expiredEndDateStr.length>0) {
        NSArray *sepArray=[expiredEndDateStr componentsSeparatedByString:@"-"];
        if (sepArray.count>2) {
            promoteStr=[NSString stringWithFormat:@"%@月%@日24点失效", sepArray[1], sepArray[2]];
        }
    }
    if ([model.prizeType isEqualToString:@"优惠券"]) {
        self.priceMoneyLab.font=[UIFont systemFontOfSize:KScreenScale(70)];
        priceMoneyStr=[NSString stringWithFormat:@"￥%@",model.prizeMoney];
        prizeTypeStr=@"优惠券";
        mainCongriStr=@"恭喜您！抢到一个红包！";
        subCongriStr=@"预计半小时内到账请至“我的优惠券“查看";
        priceMoneyMaxWidth-=23;
        self.priceMoneyLab.sd_layout.centerXEqualToView(self.imgView).offset(-11.5);
    }else if ([model.prizeType isEqualToString:@"奖励金"]) {
        self.priceMoneyLab.font=[UIFont systemFontOfSize:KScreenScale(70)];
        priceMoneyStr=[NSString stringWithFormat:@"￥%@",model.prizeMoney];
        prizeTypeStr=@"奖励金";
        mainCongriStr=@"恭喜您！抢到一个红包！";
        subCongriStr=@"下单可直接当现金使用哦";
        priceMoneyMaxWidth-=23;
        self.priceMoneyLab.sd_layout.centerXEqualToView(self.imgView).offset(-11.5);
    }else if ([model.prizeType isEqualToString:@"文本券"]) {
        priceMoneyStr=[NSString stringWithFormat:@"%@",model.collectionName];
        prizeTypeStr=@"";
        promoteStr=[NSString stringWithFormat:@"%@",model.prizeDesc];
        mainCongriStr=@"恭喜您！获得一份奖励";
        self.mainCongriLab.sd_layout.topSpaceToView(self.promoteLab, KScreenScale(50));
        [self.toWalletBtn setTitle:@"查看中奖记录" forState:UIControlStateNormal];
    }
    
    self.priceMoneyLab.text = priceMoneyStr;
    self.priceTypeLab.text = prizeTypeStr;
    self.promoteLab.text = promoteStr;
    self.mainCongriLab.text = mainCongriStr;
    self.subCongriLab.text = subCongriStr;
    
    CGFloat priceMoneyWidth=[self.priceMoneyLab.text widthForFont:self.priceMoneyLab.font]+5;
    priceMoneyWidth=priceMoneyWidth>priceMoneyMaxWidth?priceMoneyMaxWidth:priceMoneyWidth;
    self.priceMoneyLab.sd_layout.widthIs(priceMoneyWidth);
}


#pragma mark - <getters>
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        _imgView.image = [UIImage bundleImageNamed:@"drawLottery_img_Background"];
    }
    return _imgView;
}

- (UILabel *)priceMoneyLab
{
    if (!_priceMoneyLab) {
        _priceMoneyLab = [[UILabel alloc]init];
        _priceMoneyLab.textAlignment=NSTextAlignmentCenter;
        _priceMoneyLab.textColor=[UIColor convertHexToRGB:@"fe3411"];
//        _priceMoneyLab.adjustsFontSizeToFitWidth=YES;
        _priceMoneyLab.font=[UIFont boldSystemFontOfSize:KScreenScale(40)];
    }
    return _priceMoneyLab;
}

- (UILabel *)priceTypeLab
{
    if (!_priceTypeLab) {
        _priceTypeLab=[[UILabel alloc] initWithFrame:CGRectZero];
        _priceTypeLab.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _priceTypeLab.numberOfLines=0;
        _priceTypeLab.textColor=[UIColor convertHexToRGB:@"cb901d"];
    }
    return _priceTypeLab;
}

- (UILabel *)promoteLab
{
    if (!_promoteLab) {
        _promoteLab = [[UILabel alloc]init];
        _promoteLab.textAlignment = NSTextAlignmentCenter;
//        _promoteLab.adjustsFontSizeToFitWidth=YES;
        _promoteLab.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _promoteLab.textColor=[UIColor colorWithRed:254/255.0 green:49/255.0 blue:65/255.0 alpha:1.0];
    }
    return _promoteLab;
}

- (UILabel *)mainCongriLab
{
    if (!_mainCongriLab) {
        _mainCongriLab = [[UILabel alloc]init];
        _mainCongriLab.textAlignment = NSTextAlignmentCenter;
        _mainCongriLab.adjustsFontSizeToFitWidth=YES;
        _mainCongriLab.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _mainCongriLab.textColor=[UIColor convertHexToRGB:@"cb901d"];
    }
    return _mainCongriLab;
}

- (UILabel *)subCongriLab
{
    if (!_subCongriLab) {
        _subCongriLab = [[UILabel alloc]init];
        _subCongriLab.textAlignment = NSTextAlignmentCenter;
        _subCongriLab.adjustsFontSizeToFitWidth=YES;
        _subCongriLab.font=[UIFont systemFontOfSize:KScreenScale(28)];
        _subCongriLab.textColor=[UIColor convertHexToRGB:@"cb901d"];
    }
    return _subCongriLab;
}

- (UIButton *)toWalletBtn
{
    if (!_toWalletBtn) {
        _toWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toWalletBtn setTitle:@"查看我的资产" forState:UIControlStateNormal];
        [_toWalletBtn setImage:[UIImage bundleImageNamed:@"drawLottery_img_arrow_right"] forState:UIControlStateNormal];
        [_toWalletBtn setImage:[UIImage bundleImageNamed:@"drawLottery_img_arrow_right"] forState:UIControlStateHighlighted];
        [_toWalletBtn addTarget:self action:@selector(toWalletAction:) forControlEvents:UIControlEventTouchUpInside];
        _toWalletBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_toWalletBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 110, 0, -110)];
    }
    return _toWalletBtn;
}

@end
