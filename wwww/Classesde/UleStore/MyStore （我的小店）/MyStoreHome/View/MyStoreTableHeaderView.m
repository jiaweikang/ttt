//
//  MyStoreTableHeaderView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/20.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreTableHeaderView.h"
#import <UIView+SDAutoLayout.h>
#import <UIButton+YYWebImage.h>
#import "UleControlView.h"
#import "US_HomeBtnData.h"
#import "UleModulesDataToAction.h"
#import "NSDate+USAddtion.h"
#import "UserDefaultManager.h"
#import "UIView+Shade.h"
@interface USTitleAndValueLabel : UIView
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * valueLabel;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIView   * verticalLine;
@property (nonatomic, assign) BOOL isHasRightButton;
@property (nonatomic, assign) BOOL isHideVerticalLine;
@property (nonatomic, strong) NSString * mValue;

@end

@implementation USTitleAndValueLabel

- (instancetype) initWithTitle:(NSString *)title value:(NSString *)value {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled=YES;
        self.titleLabel.text=title;
        self.valueLabel.text=value;
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        [self setAttrinbutedLabel:self.valueLabel];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_addSubviews:@[self.titleLabel,self.valueLabel,self.rightButton,self.verticalLine]];
        [self layoutCustemSubViews]; 
    }
    return self;
}

- (void)layoutCustemSubViews{
    self.titleLabel.sd_layout.topSpaceToView(self, 0)
    .centerXEqualToView(self.valueLabel)
    .heightIs(KScreenScale(30)).autoWidthRatio(1);
    self.valueLabel.sd_layout.topSpaceToView(self.titleLabel, 0)
    .leftSpaceToView(self, 0).rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
    self.rightButton.sd_layout.centerYEqualToView(self.titleLabel)
    .leftSpaceToView(self.titleLabel, 5)
    .widthIs(KScreenScale(28)).heightIs(KScreenScale(32));
    self.verticalLine.sd_layout.centerYEqualToView(self)
    .rightSpaceToView(self, 0)
    .widthIs(0.5)
    .heightIs(KScreenScale(28));
    
    [self setupAutoHeightWithBottomView:self.valueLabel bottomMargin:0];
}

- (void)setMValue:(NSString *)mValue{
    _mValue=mValue;
    self.valueLabel.text=mValue;
    [self setAttrinbutedLabel:self.valueLabel];
}

-(void)setAttrinbutedLabel:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    if ([label.text rangeOfString:@"￥"].location!=NSNotFound) {
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(20)] range:NSMakeRange(0, 1)];
    }
    label.attributedText = attributedStr;
}

- (void)setIsHasRightButton:(BOOL)isHasRightButton{
    _isHasRightButton=isHasRightButton;
    if (_isHasRightButton) {
        self.rightButton.hidden=NO;
        [self.titleLabel updateLayout];
    }else{
        self.rightButton.hidden=YES;
        self.titleLabel.sd_layout.centerXEqualToView(self.valueLabel);
        [self.titleLabel updateLayout];
        self.valueLabel.textAlignment=NSTextAlignmentCenter;
    }
}

- (void)setIsHideVerticalLine:(BOOL)isHideVerticalLine{
    _isHideVerticalLine=isHideVerticalLine;
    self.verticalLine.hidden=isHideVerticalLine;
}

- (void)showEyeButton{
    BOOL isShowCloseEye=[UserDefaultManager getLocalDataBoolen:[NSString stringWithFormat:@"%@_isHideEye",[US_UserUtility sharedLogin].m_userId]];
    self.rightButton.selected=isShowCloseEye;
    NSString * newValueStr=isShowCloseEye?@"****":_mValue;
    self.valueLabel.text=newValueStr;
    [self setAttrinbutedLabel:self.valueLabel];
}

#pragma mark - <action>
- (void)rightBtnAction:(UIButton *)btn{
    btn.selected=!btn.selected;
    [UserDefaultManager setLocalDataBoolen:btn.selected key:[NSString stringWithFormat:@"%@_isHideEye",[US_UserUtility sharedLogin].m_userId]];
    [self showEyeButton];
}
#pragma mark - <setter and getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
    }
    return _titleLabel;
}
- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel=[UILabel new];
        _valueLabel.textColor=[UIColor whiteColor];
        _valueLabel.textAlignment=NSTextAlignmentCenter;
        _valueLabel.font=[UIFont systemFontOfSize:KScreenScale(40)];
    }
    return _valueLabel;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UIButton alloc] init];
        [_rightButton setImage:[UIImage bundleImageNamed:@"mystore_btn_eye_open_white"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage bundleImageNamed:@"mystore_btn_eye_close_white"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.hidden=YES;
    }
    return _rightButton;
}
- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine=[[UIView alloc]init];
        _verticalLine.backgroundColor=[UIColor whiteColor];
    }
    return _verticalLine;
}
@end


@interface MyStoreTableHeaderView ()
@property (nonatomic, strong) UIView * mTopBgView;//上方bgView
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) USTitleAndValueLabel * withdrawLabel;//收益提现
@property (nonatomic, strong) USTitleAndValueLabel * commisionLabel;//收益
@property (nonatomic, strong) USTitleAndValueLabel * visitorLabel;//访客
@property (nonatomic, strong) USTitleAndValueLabel * orderNumberlabel;//订单量
@property (nonatomic, strong) UILabel   * cancelCommissionLab;//当日取消收益
@property (nonatomic, strong) UIImageView * promoteView;//没有订单的提示攻略
@property (nonatomic, strong) UIImageView * backgroudImageView;//背景图
@property (nonatomic, strong) UIImageView * strategyView;//开单攻略背景图
@end

@implementation MyStoreTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kNavBarBackColor;
        [self sd_addSubviews:@[self.mTopBgView/*, self.shareOrderBgView*/]];
        
        _backgroudImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _strategyView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _strategyView.clipsToBounds=YES;
        _strategyView.userInteractionEnabled=YES;
        [self.mTopBgView sd_addSubviews:@[_backgroudImageView,_strategyView, self.titleView,self.commisionLabel,self.visitorLabel,self.orderNumberlabel,self.withdrawLabel]];
        
        _backgroudImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

        self.titleView.sd_layout.centerXEqualToView(self.mTopBgView)
        .topSpaceToView(self.mTopBgView, kStatusBarHeight+44+KScreenScale(10))
        .heightIs(KScreenScale(30)).autoWidthRatio(1);
        [self layoutTitleView];
        
        self.commisionLabel.sd_layout.centerXEqualToView(self.mTopBgView)
        .topSpaceToView(self.titleView, KScreenScale(20))
        .rightSpaceToView(self.mTopBgView, 0)
        .heightIs(KScreenScale(90));
        
        if ([[UleStoreGlobal shareInstance].config.isShowCancelCommissionBtn boolValue]) {
            [self.mTopBgView addSubview:self.cancelCommissionLab];
            self.cancelCommissionLab.sd_layout.bottomEqualToView(self.commisionLabel)
            .rightEqualToView(self.mTopBgView)
            .heightIs(KScreenScale(45))
            .widthIs(__MainScreen_Width/3.0);
            self.commisionLabel.sd_layout.rightSpaceToView(self.cancelCommissionLab, 0);
        }
        
        self.withdrawLabel.sd_layout.topSpaceToView(self.commisionLabel, KScreenScale(40))
        .leftSpaceToView(self.mTopBgView, 0)
        .widthIs(__MainScreen_Width/3.0)
        .heightIs(KScreenScale(80));
        
        self.visitorLabel.sd_layout.leftSpaceToView(self.withdrawLabel, 0)
        .topEqualToView(self.withdrawLabel)
        .widthRatioToView(self.withdrawLabel, 1.0)
        .heightIs(KScreenScale(80));
        
        self.orderNumberlabel.sd_layout.leftSpaceToView(self.visitorLabel, 0)
        .rightSpaceToView(self.mTopBgView, 0)
        .topEqualToView(self.withdrawLabel)
        .heightIs(KScreenScale(80));
        
        _strategyView.sd_layout.leftSpaceToView(self.mTopBgView, 0)
        .topSpaceToView(self.withdrawLabel, 0)
        .rightSpaceToView(self.mTopBgView, 0)
        .heightIs(0);
        self.backgroudImageView.sd_layout.bottomSpaceToView(_strategyView, 0);
        [self layoutStrategySubViews];
    }
    return self;
}

- (void)setModel:(MyStoreViewModel *)model{
    _model=model;
//    if (model.headBackImageUrl.length>0) {
//        [self.backgroudImageView yy_setImageWithURL:[NSURL URLWithString:model.headBackImageUrl] placeholder:nil];
//    }
    if (model.headBackgroudColor.length>0) {
        self.backgroundColor=[UIColor convertHexToRGB:model.headBackgroudColor];
    }
//    if (model.strategyImageUrl.length>0) {
//        [self.strategyView yy_setImageWithURL:[NSURL URLWithString:model.strategyImageUrl] placeholder:nil];
//    }
    [self.commisionLabel setMValue:[NSString stringWithFormat:@"%.2f",[model.commisionValue doubleValue]]];
    [self.commisionLabel showEyeButton];
   
    [self.visitorLabel setMValue:model.visitorValue.length>0?model.visitorValue:@"0"];
    [self.orderNumberlabel setMValue:model.orderValue.length>0?model.orderValue:@"0"];
    [self.withdrawLabel setMValue:self.model.withdrawCommison.length>0?self.model.withdrawCommison:@"0.00"];
    if (model.orderValue.length>0&&model.orderValue.integerValue>0) {
        [self showPromoteBar:NO animate:NO];
    }else{
        BOOL isShowPromote=YES;
        if ([NSDate isBetweenFromHour:0 fromMinute:0 fromSecond:0 toHour:13 toMinute:59 toSecond:59]) {
            isShowPromote=NO;//隐藏
        }else{/*在14点到23:59:59*/
            //当天是否点击或者关闭过
            NSDate * todayCloseDate= [UserDefaultManager getLocalDataObject:[NSString stringWithFormat:@"%@_OrderClosedDate",[US_UserUtility sharedLogin].m_userId]];
            if (todayCloseDate&&[NSDate isSameDay:todayCloseDate date2:[NSDate date]]) {//当天点击或关闭了  隐藏
                isShowPromote=NO;
            }
        }
        [self showPromoteBar:isShowPromote animate:NO];
    }
}

- (void)layoutStrategySubViews{
    [self.strategyView sd_addSubviews:@[self.promoteView]];
    self.promoteView.sd_layout.leftSpaceToView(self.strategyView, KScreenScale(20))
    .centerYEqualToView(self.strategyView)
    .rightSpaceToView(self.strategyView, KScreenScale(20))
    .heightIs(KScreenScale(60));
    [self layoutPromteView];
}

- (void)layoutTitleView{
    UIImageView * leftIcon=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"mystroe_img_Titleicon_left"]];
    UIImageView * rightIcon=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"mystroe_img_Titleicon_right"]];
    [self.titleView sd_addSubviews:@[self.titleLabel,leftIcon,rightIcon]];
    leftIcon.sd_layout.leftSpaceToView(self.titleView, 0)
    .centerYEqualToView(self.titleView)
    .widthIs(KScreenScale(14)).heightIs(KScreenScale(18));
    self.titleLabel.sd_layout.leftSpaceToView(leftIcon, 5)
    .topSpaceToView(self.titleView, 0)
    .bottomSpaceToView(self.titleView, 0)
    .autoWidthRatio(1);
    rightIcon.sd_layout.leftSpaceToView(self.titleLabel, 5)
    .centerYEqualToView(self.titleView)
    .widthIs(KScreenScale(14)).heightIs(KScreenScale(18));
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    [self.titleView setupAutoWidthWithRightView:rightIcon rightMargin:0];
}

- (void)layoutPromteView{
    UILabel *promoteLab=[[UILabel alloc]init];
    promoteLab.userInteractionEnabled=YES;
    promoteLab.text=@"今天还没有订单哦，点击查看开单攻略！";
    promoteLab.textColor=[UIColor convertHexToRGB:@"ef3b39"];
    promoteLab.font=[UIFont systemFontOfSize:KScreenScale(28)];
    [self.promoteView addSubview:promoteLab];
    promoteLab.sd_layout.leftSpaceToView(self.promoteView, KScreenScale(30))
    .topSpaceToView(self.promoteView, 0)
    .bottomSpaceToView(self.promoteView, 0)
    .autoWidthRatio(1);
    [promoteLab setSingleLineAutoResizeWithMaxWidth:300];
    
    UITapGestureRecognizer *fourthTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(promoteClick:)];
    [promoteLab addGestureRecognizer:fourthTapGes];
    
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage bundleImageNamed:@"mystore_btn_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.promoteView addSubview:closeBtn];
    closeBtn.sd_layout.rightSpaceToView(self.promoteView, KScreenScale(20))
    .centerYEqualToView(promoteLab)
    .widthIs(KScreenScale(68)).heightIs(KScreenScale(42));
}

- (void)showPromoteBar:(BOOL)show animate:(BOOL) animate{
    self.strategyView.sd_layout.heightIs(show? KMSStrategyHight:0);
    self.isShowPromoteBar=show;
    /*
    if (animate) {
        self.strategyView.sd_layout.heightIs(show? KMSStrategyHight:0);
        [UIView animateWithDuration:0.4 animations:^{
            if (show) {
                self.height_sd=KScreenScale(360)+KScreenScale(180);
//                self.shareOrderBgView.sd_layout.topSpaceToView(self.mTopBgView, KScreenScale(20));
            }else{
                self.height_sd=KScreenScale(360)+KScreenScale(120);
//                self.shareOrderBgView.sd_layout.topSpaceToView(self.mTopBgView, -KScreenScale(40));
            }
            [self.tableView beginUpdates];
            [self.tableView setTableHeaderView:self];
            [self.tableView endUpdates];
        } completion:^(BOOL finished) {
        }];
    }else{
        if (show) {
            self.strategyView.sd_layout.heightIs(KMSStrategyHight);
            self.height_sd=KScreenScale(360)+KScreenScale(180);
//            self.shareOrderBgView.sd_layout.topSpaceToView(self.mTopBgView, KScreenScale(20));
        }else{
            self.strategyView.sd_layout.heightIs(KScreenScale(0));
            self.height_sd=KScreenScale(360)+KScreenScale(120);
//            self.shareOrderBgView.sd_layout.topSpaceToView(self.mTopBgView, -KScreenScale(40));
        }
        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:self];
        [self.tableView endUpdates];
    }
     */
}

- (void)closeAction:(id)sender{
    [UserDefaultManager setLocalDataObject:[NSDate date] key:[NSString stringWithFormat:@"%@_OrderClosedDate",[US_UserUtility sharedLogin].m_userId]];
    [self showPromoteBar:NO animate:YES];
}

- (void)setShowNote:(BOOL)showNote{
    if (showNote) {
        self.promoteView.sd_layout.heightIs(KScreenScale(60));
        
    }else{
        self.promoteView.sd_layout.heightIs(0);
    }
}
#pragma mark - <Tap Click>
- (void)withdrawCommisionClick:(UIGestureRecognizer *)recognizer{
    [[UIViewController currentViewController] pushNewViewController:@"US_IncomeManageVC" isNibPage:NO withData:nil];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的钱包" moduledesc:@"收益" networkdetail:@""];
}
- (void)commisionClick:(UIGestureRecognizer *)recognizer{
    [[UIViewController currentViewController] pushNewViewController:@"US_IncomeManageVC" isNibPage:NO withData:nil];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"交易中收益" networkdetail:@""];
}

- (void)visitorClick:(UIGestureRecognizer *)recognizer{
     [[UIViewController currentViewController] pushNewViewController:@"US_ShareRecordVC" isNibPage:NO withData:nil];
     [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"访客量" networkdetail:@""];
}

- (void)ordersClick:(UIGestureRecognizer *)recognizer{
    [[UIViewController currentViewController] pushNewViewController:@"US_OrderListRootVC" isNibPage:NO withData:nil];
     [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"订单量" networkdetail:@""];
}
- (void)promoteClick:(UIGestureRecognizer *)recognizer{
//    HomeBtnItem * item=[[HomeBtnItem alloc] init];
//    item.ios_action=self.model.promote_iosAction;
    UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:@"WebDetailViewController:0&&key:https@@www.ule.com/app/yxd/2017/0301/goods_guide.html#title:新手攻略#hasnavi:1"];
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
    [UserDefaultManager setLocalDataObject:[NSDate date] key:[NSString stringWithFormat:@"%@_OrderClosedDate",[US_UserUtility sharedLogin].m_userId]];
    [self showPromoteBar:NO animate:YES];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"开单提示" networkdetail:@""];
}
- (void)cancelCommissionClick:(UIGestureRecognizer *)ges{
    [[UIViewController currentViewController] pushNewViewController:@"US_IncomeTradingCancelVC" isNibPage:NO withData:nil];
}

#pragma mark - <setter and getter>
- (UIView *)mTopBgView{
    if (!_mTopBgView) {
        _mTopBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(360)+kStatusBarHeight+44)];
        CAGradientLayer *layer=[UIView setGradualSizeChangingColor:_mTopBgView.bounds.size fromColor:kCommonRedColor toColor:[UIColor convertHexToRGB:@"FF7462"] gradualType:GradualTypeVertical];
        layer.zPosition=-1;
        [_mTopBgView.layer addSublayer:layer];
    }
    return _mTopBgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.text=@"今日创业简报";
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.alpha = 0.7;
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
    }
    return _titleLabel;
}

- (USTitleAndValueLabel *) commisionLabel{
    if (!_commisionLabel) {
        _commisionLabel=[[USTitleAndValueLabel alloc] initWithTitle:@"余额（元）" value:@"￥0.00"];
        _commisionLabel.valueLabel.font=[UIFont systemFontOfSize:KScreenScale(60)];
        _commisionLabel.isHasRightButton=YES;
        _commisionLabel.isHideVerticalLine=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commisionClick:)];
        [_commisionLabel addGestureRecognizer:tap];
    }
    return _commisionLabel;
}

- (USTitleAndValueLabel *)withdrawLabel{
    if (!_withdrawLabel) {
        _withdrawLabel=[[USTitleAndValueLabel alloc] initWithTitle:@"可提现余额（元)" value:@"0.00"];
        [_withdrawLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(withdrawCommisionClick:)]];
    }
    return _withdrawLabel;
}

- (USTitleAndValueLabel *)visitorLabel{
    if (!_visitorLabel) {
        _visitorLabel=[[USTitleAndValueLabel alloc] initWithTitle:@"访客量" value:@"0"];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(visitorClick:)];
        [_visitorLabel addGestureRecognizer:tap];
    }
    return _visitorLabel;
}

- (USTitleAndValueLabel *)orderNumberlabel{
    if (!_orderNumberlabel) {
        _orderNumberlabel=[[USTitleAndValueLabel alloc] initWithTitle:@"订单量" value:@"0"];
        _orderNumberlabel.userInteractionEnabled=YES;
        _orderNumberlabel.isHideVerticalLine=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ordersClick:)];
        [_orderNumberlabel addGestureRecognizer:tap];
    }
    return _orderNumberlabel;
}

- (UILabel *)cancelCommissionLab{
    if (!_cancelCommissionLab) {
        _cancelCommissionLab=[[UILabel alloc]init];
        _cancelCommissionLab.text=@"当日取消收益";
        _cancelCommissionLab.textColor=[UIColor whiteColor];
        _cancelCommissionLab.textAlignment=NSTextAlignmentCenter;
        _cancelCommissionLab.font=[UIFont systemFontOfSize:KScreenScale(28)>14?14:KScreenScale(28)];
        _cancelCommissionLab.adjustsFontSizeToFitWidth=YES;
        _cancelCommissionLab.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelCommissionClick:)];
        [_cancelCommissionLab addGestureRecognizer:tap];
    }
    return _cancelCommissionLab;
}

- (UIImageView *)promoteView{
    if (!_promoteView) {
        _promoteView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _promoteView.layer.cornerRadius=KScreenScale(60)/2.0;
        _promoteView.clipsToBounds=YES;
        _promoteView.userInteractionEnabled=YES;
        _promoteView.image=[UIImage bundleImageNamed:@"mystore_img_note"];
    }
    return _promoteView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView=[[UIView alloc] initWithFrame:CGRectZero];
    }
    return _titleView;
}
@end
