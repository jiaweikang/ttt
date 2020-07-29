//
//  US_MyGoodsSearchAlertView.m
//  UleMarket
//
//  Created by chenzhuqing on 2019/1/23.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsSearchAlertView.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>

#define kAddSelfDic @{@"imageName":@"myGoods_btn_addSelf",\
@"title":@"添加",\
@"subTitle":@"录入自有商品",\
@"type":@"0"\
}\

#define kSearchPrdDic @{@"imageName":@"myGoods_btn_market",\
@"title":@"货源市场",\
@"subTitle":@"找货源 快、准、优",\
@"type":@"1",\
}\

#define kSyncPrdDic  @{@"imageName":@"myGoods_btn_sync",\
@"title":@"同步邮乐网收藏夹",\
@"subTitle":@"商品一键同步到小店",\
@"type":@"2",\
}\


@interface US_MyGoodsSearchAlertView ()<US_MyGoodsListBottomViewDelegate>
@property (nonatomic, strong) UILabel * titleLabel;

//@property (nonatomic, strong) UleControlView * leftImageView;
//@property (nonatomic, strong) UILabel * leftTitleLabel;
//@property (nonatomic, strong) UILabel * leftSubTitleLabel;
//@property (nonatomic, strong) UIImageView *leftCoverView;
//
//@property (nonatomic, strong) UleControlView *middleImageView;
//@property (nonatomic, strong) UILabel *middleTitleLabel;
//@property (nonatomic, strong) UILabel *middleSubTitleLabel;
//
//@property (nonatomic, strong) UleControlView * rightImageView;
//@property (nonatomic, strong) UILabel * rightTitleLabel;
//@property (nonatomic, strong) UILabel * rightSubTitleLabel;

@property (nonatomic, strong) UIView * alertView;
@property (nonatomic, strong) US_MyGoodsListBottomView * bottomView;
@property (nonatomic, strong) UIButton * touchView;
@property (nonatomic, assign) BOOL rightBtnCanClick;
@end


@implementation US_MyGoodsSearchAlertView

- (instancetype)initWithFrame:(CGRect)frame RightButtonCanClick:(BOOL)rightBtnCanClick{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightBtnCanClick = rightBtnCanClick;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.0f]];
    
    [self addSubview:self.touchView];
    [self addSubview:self.alertView];
    [self addSubview:self.bottomView];
    
    self.touchView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.bottomView.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    [self setAlertUI];
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}



- (void)setAlertUI{
    
    [self.alertView sd_addSubviews:@[self.titleLabel]];
    self.titleLabel.sd_layout.leftSpaceToView(self.alertView, KScreenScale(20))
    .topSpaceToView(self.alertView, KScreenScale(30))
    .rightSpaceToView(self.alertView, KScreenScale(20))
    .heightIs(KScreenScale(35));
    UIView * containView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.alertView addSubview:containView];
    containView.sd_layout.centerXEqualToView(self.alertView)
    .topSpaceToView(self.titleLabel, 0)
    .bottomSpaceToView(self.alertView, 0)
    .autoWidthRatio(0);
    CGFloat x=0;
    UIView * lastView;
    UIView * lastPlitLine;
    NSMutableArray * array=@[kAddSelfDic].mutableCopy;
    if ([[UleStoreGlobal shareInstance].config.isShowGoodsSourceBtn boolValue]) {
        [array addObject:kSearchPrdDic];
    }
    //判断是否需要显示同步邮乐网收藏
    if ([US_UserUtility isNeedGetUleFavoritList]) {
        [array addObject:kSyncPrdDic];
    }
    for (int i=0; i<array.count; i++) {
        NSDictionary * info=[array objectAt:i];
        UleControlView * btnView=[self buildButtonWithImage:info[@"imageName"] title:info[@"title"] subTitle:info[@"subTitle"]];
        btnView.tag=[info[@"type"] integerValue];
        [btnView addTouchTarget:self action:@selector(btnClickAction:)];
        [containView addSubview:btnView];
        btnView.sd_layout.leftSpaceToView(containView, x)
        .topSpaceToView(containView, 0)
        .widthIs(__MainScreen_Width/array.count)
        .bottomSpaceToView(containView, 0);
        lastView=btnView;
        UIView * splitLine=[[UIView alloc] initWithFrame:CGRectZero];
        [containView addSubview:splitLine];
        splitLine.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
        splitLine.sd_layout.leftSpaceToView(btnView, 0)
        .centerYEqualToView(containView)
        .widthIs(1).heightIs(KScreenScale(80));
        lastPlitLine=splitLine;
        x+=__MainScreen_Width/array.count+1;
    }
    [lastPlitLine removeFromSuperview];
    [containView setupAutoWidthWithRightView:lastView rightMargin:0];
}

- (void)btnClickAction:(UleControlView *) sender{
    switch (sender.tag) {
        case 0:
            [self leftViewClick:sender];
            break;
        case 1:
            [self middleViewClick:sender];
            break;
        case 2:
            [self rightViewClick:sender];
            break;
        default:
            break;
    }
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5f]];
        self.alertView.top_sd=__MainScreen_Height-KScreenScale(400)-self.bottomView.height_sd;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss:(AlertDismissFinish)disMissFinished{
    self.dismissFinish=[disMissFinished copy];
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.0f]];
        self.alertView.top_sd=__MainScreen_Height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissFinish) {
            self.dismissFinish();
        }
    }];
}

- (void)backgroundClick{
    [self dismiss:nil];
}
#pragma mark - <click Event>
- (void)leftViewClick:(id)sender{
//    if (![[US_UserUtility sharedLogin].qualificationFlag  isEqualToString:@"1"]) {
//        [UleMBProgressHUD showHUDWithText:@"功能暂未开放，请等待通知" afterDelay:1.5];
//        [self dismiss:nil];
    //        return;
    //    }
    [self dismiss:^{
        if (![[US_UserUtility sharedLogin].qualificationFlag  isEqualToString:@"1"]) {
            //跳转注册
            NSString *urlStr=[NSString stringWithFormat:@"%@/mxiaodian/user/merchant/reg.html#/",[UleStoreGlobal shareInstance].config.mUleDomain];
            NSMutableDictionary *params=@{@"key":urlStr,
                                          @"hasnavi":@"1",
                                          @"title":@"自有商品注册"}.mutableCopy;
            [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uleMerchant://"]]){
                //编辑
                NSString *str = @"uleMerchant://EditGoodsViewController";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }else{
                //跳转到应用市场
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id684673362"]];
            }
        }
    }];
}

- (void)middleViewClick:(id)sender{
    [self dismiss:^{
        NSString * categoryLinkUrl=[NSString stringWithFormat:@"%@/ulewap/category_v2.html",[UleStoreGlobal shareInstance].config.ulecomDomain];
        NSMutableDictionary *dic = @{@"key":categoryLinkUrl,
                                     @"hasnavi":@"1",
                                     @"title":@"分类"}.mutableCopy;
        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
    }];
}

- (void)rightViewClick:(id)sender{
    [self dismiss:^{
        [[UIViewController currentViewController] pushNewViewController:@"US_MyGoodsSyncVC" isNibPage:NO withData:nil];
    }];
}

- (void)searchProductClick{
    [self dismiss:nil];
}

- (void)bottomLeftBtnClick{
    [self dismiss:nil];
}

- (void)bottomRightBtnClick{
    [self dismiss:^{
        if (self.rightButtonClick) {
            self.rightButtonClick();
        }
    }];
    
}
#pragma mark - <setter and getter>
- (UIView *)alertView{
    if (!_alertView) {
        _alertView=[[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, KScreenScale(400))];
        _alertView.backgroundColor=[UIColor whiteColor];
        _alertView.userInteractionEnabled=YES;
    }
    return _alertView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.text=@"选择货源商品";
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];
    }
    return _titleLabel;
}

- (UleControlView *) buildButtonWithImage:(NSString *)imageName title:(NSString *)title subTitle:(NSString *)subTitle{
    UleControlView * btn=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/3.0, self.alertView.height_sd-KScreenScale(35))];
    btn.mImageView.image=[UIImage bundleImageNamed:imageName];
    btn.mImageView.sd_layout.centerXEqualToView(btn)
    .topSpaceToView(btn, KScreenScale(35))
    .widthIs(KScreenScale(140))
    .heightEqualToWidth();
    btn.mTitleLabel.text=title;
    btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    btn.mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
    btn.mTitleLabel.sd_layout.leftSpaceToView(btn, 0)
    .rightSpaceToView(btn, 0)
    .topSpaceToView(btn.mImageView, KScreenScale(18))
    .heightIs(KScreenScale(35));
    UILabel * subTitleLabel=[UILabel new];
    [btn addSubview:subTitleLabel];
    subTitleLabel.text=subTitle;
    subTitleLabel.textAlignment=NSTextAlignmentCenter;
    subTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
    subTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(22)];
    subTitleLabel.sd_layout.leftSpaceToView(btn, 0)
    .rightSpaceToView(btn, 0)
    .heightIs(KScreenScale(35))
    .topSpaceToView(btn.mTitleLabel, KScreenScale(18));
    return btn;
}

- (US_MyGoodsListBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[US_MyGoodsListBottomView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kStatusBarHeight==20?49:83)];
        [_bottomView.leftButton setBackgroundColor:[UIColor convertHexToRGB:@"fef0ef"]];
        _bottomView.leftButton.mTitleLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        [_bottomView.leftButton addTouchTarget:self action:@selector(bottomLeftBtnClick)];
        [_bottomView.rightButton addTouchTarget:self action:@selector(bottomRightBtnClick)];
        if (!self.rightBtnCanClick) {
            [_bottomView setRightButtonCanClick:self.rightBtnCanClick];
        }
    }
    return _bottomView;
}

- (UIButton *)touchView{
    if (!_touchView) {
        _touchView=[UIButton new];
        [_touchView addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchView;
}
@end

