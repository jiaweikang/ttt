//
//  USShareView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USShareView.h"
#import <UIView+SDAutoLayout.h>
#import "BtnImgAndTitle.h"
#import <UIView+ShowAnimation.h>
#import <Ule_ShareView.h>
#import "US_QRGraphShareView.h"
#import "US_NetworkExcuteManager.h"
#import "USAuthorizetionHelper.h"
#import "ShareParseTool.h"
#import "US_MultiGraphShareView.h"
#import "ShareCreateId.h"
#import <UleWeixinSDK/WXApi.h>
#import <UMAnalytics/MobClick.h>
#import "US_ActivityRuleView.h"
#import "US_MessageCopyView.h"
#import "US_BottomPresentAlertView.h"
#import "USRedPacketCashManager.h"
#import "PosterShareStyleView.h"
#import "ShareStorePosterModel.h"
#import "US_ActivityPosterShareView.h"
#import "US_NewQRGraphShareView.h"

static const CGFloat ktopHeight = 114;
static const CGFloat kAlertHeight = 455;
static const CGFloat kTitleMargin =30;
//static const CGFloat kAlertHeightMax  =900;
#define  USShareImageArray  @[@"share_btn_wechat",@"share_btn_wxFriend",@"share_btn_multiPic",@"share_btn_qr",@"share_btn_wxMiniProgram",@"share_btn_copyLink",@"share_btn_storePoster",@"share_btn_storePoster",@"share_btn_advertorial"]
#define  USShareTitleArray  @[@"微信好友",@"朋友圈",@"多图分享",@"海报分享",@"小程序",@"复制链接",@"店铺海报",@"海报分享",@"软文分享"]

#define TopBgImgViewTag 5000

@interface USShareView ()
@property (nonatomic, strong) UILabel * mPriceLabel;
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) UILabel * mRightTitleLabel;
@property (nonatomic, strong) UIImageView * mRightIconImgaeView;
@property (nonatomic, strong) USShareModel * shareModel;
@property (nonatomic, strong) USShareViewBlock shareCallBack;
@property (nonatomic, strong) US_QRGraphShareView * qrGraph;//用于获取并下载带二维码的图片
@property (nonatomic, strong) UIImageView * topView;
@property (nonatomic, strong) UIView * shareTypeView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) US_ActivityRuleView * activityRuleView;
@property (nonatomic, strong) US_MessageCopyView * messageCopyView;
@property (nonatomic, strong) US_NewQRGraphShareView    *qrGraphNew;
@end

@implementation USShareView

+ (instancetype) shareInstance{
    static USShareView * shareView=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView=[[USShareView alloc] initWithFrame:CGRectZero];
    });
    return shareView;
}

// 分享注册
+ (void)registWeChatForAppKey:(NSString *)appKey{
    [WXApi registerApp:appKey universalLink:[UleStoreGlobal shareInstance].config.universalLink];
}

- (void)dealloc{
    NSLog(@"__%s__",__FUNCTION__);
}

- (void)reloadUI{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self setupUI];
}

- (void)setShareModel:(USShareModel *)shareModel{
    _shareModel=shareModel;
    [self reloadUI];
}

+ (void)shareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack{
    NSLog(@"shareOptions===%@",shareModel.shareOptions);
    [self registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare];
    USShareView * shareView=[USShareView shareInstance];
    shareView.shareModel=shareModel;
    shareView.shareCallBack = [shareCallBack copy];
    [shareView layoutMessageCopyView];
    //如果有图片链接
    if ([shareModel.shareOptions containsString:@"6"]||[shareModel.shareOptions containsString:@"7"]) {
        UIImageView *topBgImgView = (UIImageView *)[shareView viewWithTag:TopBgImgViewTag];
        topBgImgView.image = [UIImage bundleImageNamed:@"share_icon_storeTopBg"];
    }
    if (shareModel.listImage.count>0||shareModel.shareUrl.length>0||shareModel.shareImageData!=nil) {
        [shareView handleminiWxShareInfoWithModel:shareModel];
        [shareView updateShareViewWithData:nil];
        [shareView showViewWithAnimation:AniamtionPresentBottom];
    }else{
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@""];
        @weakify(shareView)
        //没有分享链接请求接口获取链接
        [shareView.shareModel startRequestShareInfor:^(id  _Nonnull responseObj) {
            @strongify(shareView);
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
            [shareView updateShareViewWithData:responseObj];
            [shareView showViewWithAnimation:AniamtionPresentBottom];
            
        } failed:^(NSError * _Nonnull error) {
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
        }];
        
    }
}
+ (void)insuranceShareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack{
    [self registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare];
    USShareView * shareView=[USShareView shareInstance];
    shareView.shareModel=shareModel;
    shareView.shareCallBack = [shareCallBack copy];
    [shareView layoutMessageCopyView];
    [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@""];
    //没有分享链接请求接口获取链接
    if (shareModel.shareUrl.length == 0) {
        @weakify(shareView)
        [shareModel startRequestInsuranceShareInfor:^(id  _Nonnull responseObj) {
            @strongify(shareView);
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
            [shareView updateShareViewWithData:responseObj];
            [shareView showViewWithAnimation:AniamtionPresentBottom atView:[UIViewController currentViewController].tabBarController.view];
            
        } failed:^(NSError * _Nonnull error) {
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
        }];
    }
    //有分享链接 直接分享
    else{
        [shareView updateShareViewWithData:nil];
        [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
        [shareView showViewWithAnimation:AniamtionPresentBottom atView:[UIViewController currentViewController].tabBarController.view];
    }
}

+ (void)fenxiaoShareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack{
    [self registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare];
    USShareView * shareView=[USShareView shareInstance];
    shareView.shareModel=shareModel;
    shareView.shareCallBack = [shareCallBack copy];
    [shareView layoutMessageCopyView];
    [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@""];
    @weakify(shareView)
    [shareModel startRequestFenxiaoShareInfo:^(id  _Nonnull responseObj) {
        @strongify(shareView);
        [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
        [shareView updateShareViewWithData:responseObj];
        [shareView showViewWithAnimation:AniamtionPresentBottom atView:[UIViewController currentViewController].tabBarController.view];
    } failed:^(NSError * _Nonnull error) {
        [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
    }];
}

-(void)handleminiWxShareInfoWithModel:(USShareModel *)shareModel{
    //处理微信小程序参数
    if ([NSString isNullToString:shareModel.WXMiniProgram_pageUrl].length > 0 && [NSString isNullToString:shareModel.WXMiniProgram_path].length > 0 &&
        [NSString isNullToString:shareModel.WXMiniProgram_OriginalId].length > 0) {
        
    }
    //如果没有微信小程序参数 但是配置了小程序分享方式4 要把4去掉
    else {
        //4代表小程序
        //4在中间
        if ([shareModel.shareOptions containsString:@"##4"]) {
            shareModel.shareOptions=[shareModel.shareOptions stringByReplacingOccurrencesOfString:@"##4" withString:@""];
        }
        //4在开头
        if ([shareModel.shareOptions containsString:@"4##"]) {
            shareModel.shareOptions=[shareModel.shareOptions stringByReplacingOccurrencesOfString:@"4##" withString:@""];
        }
        //只有4
        if ([shareModel.shareOptions containsString:@"4"]) {
            shareModel.shareOptions=[shareModel.shareOptions stringByReplacingOccurrencesOfString:@"4" withString:@""];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(kAlertHeight))];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor=[UIColor clearColor];
    self.topView=[self layoutTopView];
    [self addSubview:self.topView];
    self.topView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0)
    .rightSpaceToView(self, 0).heightIs(KScreenScale(ktopHeight));
    
    [self addSubview:self.activityRuleView];
    self.activityRuleView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self.topView, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0);
    [self addSubview:self.messageCopyView];
    self.messageCopyView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self.activityRuleView, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0);
    
    [self addSubview: self.shareTypeView];
    [self layoutShareTypeView];
    
    self.shareTypeView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self.messageCopyView, 0)
    .rightSpaceToView(self, 0)
    .autoHeightRatio(0);

    [self addSubview:self.bottomView];
    self.bottomView.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self.shareTypeView, 0)
    .heightIs(kStatusBarHeight>20?KScreenScale(100)+34:KScreenScale(100));
    
    [self setupAutoHeightWithBottomView:self.bottomView bottomMargin:0];
    
}

- (UIImageView *)layoutTopView{
    UIImageView * topView=[[UIImageView alloc] init];
    topView.tag = TopBgImgViewTag;
    topView.backgroundColor=[UIColor clearColor];
    topView.image=[UIImage bundleImageNamed:@"share_pic_topBg"];
    CGRect rect=CGRectMake(0, 0, __MainScreen_Width, ktopHeight);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(KScreenScale(35)*0.5, KScreenScale(35)*0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    topView.layer.mask = maskLayer;

    UIImageView * iconImageView=[UIImageView new];
    self.mRightIconImgaeView=iconImageView;
    [topView addSubview:iconImageView];
    iconImageView.image=[UIImage bundleImageNamed:@"share_icon_ok"];
    iconImageView.sd_layout.leftSpaceToView(topView, KScreenScale(kTitleMargin))
    .topSpaceToView(topView, KScreenScale(20)).widthIs(KScreenScale(25)).heightEqualToWidth();
    
    UILabel * rightTitleLabel=[UILabel new];
    self.mRightTitleLabel=rightTitleLabel;
    rightTitleLabel.textColor=[UIColor convertHexToRGB:@"FEB1B0"];
    rightTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(23)];
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    [topView addSubview:rightTitleLabel];
    rightTitleLabel.sd_layout.leftSpaceToView(self.mRightIconImgaeView, KScreenScale(10))
    .centerYEqualToView(self.mRightIconImgaeView).heightIs(KScreenScale(23)).autoWidthRatio(1);
    [rightTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel * titleLabel=[self getInitLabel];
    self.mTitleLabel=titleLabel;
    [topView addSubview:titleLabel];
    titleLabel.sd_layout.centerYIs(KScreenScale(ktopHeight)/2.0).heightIs(KScreenScale(40))
    .leftSpaceToView(topView,KScreenScale(kTitleMargin)).rightSpaceToView(topView, KScreenScale(10));
    return topView;
}

- (void) layoutShareTypeView{
    for (UIView * view in [self.shareTypeView subviews]) {
        [view removeFromSuperview];
    }
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text = @"选择分享方式";
    titleLabel.textColor = [UIColor convertHexToRGB:@"B3B3B3"];
    titleLabel.font = [UIFont systemFontOfSize:(KScreenScale(24))];
    [self.shareTypeView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(self.shareTypeView, KScreenScale(kTitleMargin))
    .topSpaceToView(self.shareTypeView, KScreenScale(40))
    .widthIs(150).heightIs(KScreenScale(20));
    UIView * contentView=[UIView new];
    NSString * shareType=self.shareModel.shareOptions.length>0?self.shareModel.shareOptions:@"0##1##2##3##5";//默认显示
    NSArray * typeArray = [shareType componentsSeparatedByString:@"##"];
    NSMutableArray * buttonTypeArr = [NSMutableArray new];
    for (int i=0; i<[typeArray count]; i++) {
        NSInteger typeValue = [[[typeArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
        if (typeValue>-1 && typeValue<9) {
            [buttonTypeArr addObject:[NSNumber numberWithInteger:typeValue]];
        }
    }
    if (buttonTypeArr.count == 0) {
        return;
    }
    //获取需要显示的分享方式的个数(用于计算每个分享方式的位置间隔大小)
    NSInteger showNum=buttonTypeArr.count;

    int btnNum=0;
    CGFloat maxWidth=0,maxHeight=0;
    CGFloat rowMargin=KScreenScale(40);
    CGFloat btnWidth=KScreenScale(130);
    showNum=showNum>4?4:showNum;
    CGFloat margin=(__MainScreen_Width - KScreenScale(130)* showNum) / (showNum+1);
  
    for (int i=0; i<buttonTypeArr.count; i++) {

        BtnImgAndTitle * shareBtn=[[BtnImgAndTitle alloc] initWithFrame:CGRectZero];
        [shareBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:KScreenScale(23)]];
        NSString * btnTitle=NonEmpty([USShareTitleArray objectAt:[[buttonTypeArr objectAt:i] integerValue]]);
        if ([[[buttonTypeArr objectAt:i] stringValue] isEqualToString:@"4"]&&self.shareModel.WXMiniProgram_DialogName.length>0) {
            btnTitle=self.shareModel.WXMiniProgram_DialogName;
        }
        [shareBtn setTitle:btnTitle forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage bundleImageNamed:NonEmpty([USShareImageArray objectAt:[[buttonTypeArr objectAtIndex:i] integerValue]])] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(btnClick:)
           forControlEvents:UIControlEventTouchUpInside];
        shareBtn.tag=[[buttonTypeArr objectAt:i] integerValue];
        [contentView addSubview:shareBtn];
        shareBtn.frame=CGRectMake((btnWidth+margin)*(btnNum%4)+margin, (btnWidth+rowMargin)*(btnNum/4)+rowMargin, btnWidth, btnWidth);
        btnNum++;
        if (![WXApi isWXAppInstalled]) {
            UIView *coverView=[[UIView alloc]init];
            coverView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.7];
            [shareBtn addSubview:coverView];
            coverView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        }
    }
    maxWidth=btnNum>4?(((btnWidth+margin))*4+margin):((((btnWidth+margin))*btnNum+margin));
    btnNum=btnNum>0?btnNum-1:0;
    maxHeight=(btnWidth+rowMargin)*(btnNum/4+1)+rowMargin;
    
    [self.shareTypeView addSubview:contentView];
    contentView.sd_layout.centerXEqualToView(self.shareTypeView)
    .topSpaceToView(titleLabel,0)
    .heightIs(maxHeight)
    .widthIs(maxWidth);
    [self.shareTypeView setupAutoHeightWithBottomView:contentView bottomMargin:0];
}

- (void)layoutMessageCopyView{
    if ([NSString isNullToString:self.shareModel.ruleDescription].length>0) {
        [self.activityRuleView setActivityRuleStr:[NSString isNullToString:self.shareModel.ruleDescription]];
        self.activityRuleView.hidden=NO;
        self.activityRuleView.sd_layout.heightIs(KScreenScale(252));
    }else {
        [self.activityRuleView setActivityRuleStr:@""];
        self.activityRuleView.hidden=YES;
        self.activityRuleView.sd_layout.heightIs(0);
    }
    if ([NSString isNullToString:self.shareModel.messageCopyStr].length>0) {
        [self.messageCopyView setMessageCopyStr:[NSString isNullToString:self.shareModel.messageCopyStr]];
        self.messageCopyView.hidden=NO;
        self.messageCopyView.sd_layout.heightIs(KScreenScale(370))
        .topSpaceToView(self.activityRuleView, self.activityRuleView.hidden?0:-KScreenScale(10));
    }else{
//        [self.messageCopyView setMessageCopyStr:@""];
        self.messageCopyView.hidden=YES;
        self.messageCopyView.sd_layout.heightIs(0)
        .topSpaceToView(self.activityRuleView, 0);
    }
    [self.activityRuleView updateConstraints];
    [self.messageCopyView updateLayout];
//    [self setNeedsDisplay];
    [self layoutSubviews];
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    self.frame=CGRectMake(0, __MainScreen_Height-rect.size.height, rect.size.width, rect.size.height);
//}

- (void)updateShareViewWithData:(ShareCreateData *)shareCreate{
    if (shareCreate) {
        self.shareModel.favsListingStr=shareCreate.favsListingStr;
    }
    if (!self.shareModel.favsListingStr||self.shareModel.favsListingStr.length==0||[[self.shareModel.insuranceFlag description] isEqualToString:@"1"]||!self.shareModel.isNeedSaveQRImage) {
        self.mRightIconImgaeView.hidden=YES;
        self.mRightTitleLabel.hidden=YES;
        self.mTitleLabel.sd_layout.centerYIs(KScreenScale(ktopHeight)/2.0);
    }else{
        self.mRightIconImgaeView.hidden=NO;
        self.mRightTitleLabel.hidden=NO;
        self.mTitleLabel.sd_layout.centerYIs(KScreenScale(ktopHeight)/2.0+KScreenScale(10));
        self.mRightTitleLabel.text=self.shareModel.favsListingStr;
    }
#warning tt 182 审核 隐藏分享顶部文案
//    if (self.shareModel.shareCommission.length>0) {
//        self.mTitleLabel.text=[NSString stringWithFormat:@"分享成单，最高可赚 ￥%@",self.shareModel.shareCommission];
//        self.mTitleLabel.attributedText=[self.mTitleLabel.text setSubStrings:@[self.shareModel.shareCommission] showWithFont:[UIFont systemFontOfSize:KScreenScale(46)]];
//    }else{
    self.mTitleLabel.text=@"";
//    }
    if (shareCreate.additionalShareInfo.length>0) {
        self.shareModel.messageCopyStr=shareCreate.additionalShareInfo;
    }
    if (shareCreate.shareCommissionLongText.length>0) {
        self.mTitleLabel.text=shareCreate.shareCommissionLongText;
    }
    if (self.shareModel.additionalShareInfo.length>0) {
        self.shareModel.messageCopyStr=self.shareModel.additionalShareInfo;
    }
    if (self.shareModel.shareCommissionLongText.length>0) {
        self.mTitleLabel.text=self.shareModel.shareCommissionLongText;
    }
    if ([NSString isNullToString:shareCreate.imageBanner].length > 0) {
        self.shareModel.imageBanner = shareCreate.imageBanner;
    }
    [self layoutShareTypeView];
    [self layoutMessageCopyView];
}

#pragma mark - <点击事件>
- (void)buttonCancel:(UIButton *)btn{
    [self hiddenView];
}

- (void)btnClick:(UIButton *)btn{
    NSInteger tag=btn.tag;
    switch (tag) {
        case 0:
            [self wxAndFriendsShareType:@"100"];
            break;
        case 1:
            [self wxAndFriendsShareType:@"010"];;
            break;
        case 2:
            [self multiPicshareAction];
            break;
        case 3:
            [self qrCodeShareAction];
            break;
        case 4:
            [self WXMiniProgramShare];
            break;
        case 5:
            [self linkCopyAction];
            break;
        case 6:
            [self shareStorePosterView];
            break;
        case 7:
            //活动海报分享
            [self shareActivityPosterView];
            break;
        case 8:
            //软文分享
            [self articalShareAction];
            break;
        default:
            break;
    }
}

#pragma mark - <分享事件>
//微信朋友圈分享
- (void)wxAndFriendsShareType:(NSString *)shareType{
    Ule_ShareModel * shareModel=[[Ule_ShareModel alloc] initWithTitle:self.shareModel.shareTitle content:self.shareModel.shareContent imageUrl:self.shareModel.shareImageUrl     linkUrl:self.shareModel.shareUrl shareType:shareType];
    shareModel.singleImgData=self.shareModel.shareImageData;
    NSString * linkUrl=shareModel.linkUrl.length>0?shareModel.linkUrl:@"";
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    @weakify(self);
    [[Ule_ShareView shareViewManager] shareWithModel:shareModel withViewController:nil resultBlock:^(NSString *name, NSString * result) {
        @strongify(self);
        if (self.shareCallBack) {
            self.shareCallBack(result);
        }
        //TODO:红包雨逻辑
        if ([result isEqualToString:SV_Success]) {
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
            
            //记录
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"SHARE_SUCCESS" moduledesc:[linkUrl urlEncodedString] networkdetail:@""];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self hiddenView];
        });
       
    }];
    //TODO:添加友盟统计
    NSString * shareTypeStr=[shareType isEqualToString:@"100"]?@"微信好友":@"朋友圈";
    [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                             @"分享页面":NonEmpty(self.shareModel.logPageName),
                                             @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                             @"分享类型":shareTypeStr}];
    NSString * tel=[shareType isEqualToString:@"100"]?@"WX":@"WXF";
    [LogStatisticsManager onShareLog:tel tev:self.shareModel.shareUrl andShareTo:@""];
}
//多图分享
- (void)multiPicshareAction{
    [self hiddenView];
    [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在加载"];
    @weakify(self);
    [self.shareModel startRequestMultiPicInfo:^(id  _Nonnull responseObj) {
        @strongify(self);
        if (self.shareModel.listImage>0) {
            //判断有无相册权限，有则存储照片，无则提示
            if ([USAuthorizetionHelper photoLibaryAuth]) {
                //保存分享内容到剪贴板
                [ShareParseTool saveToPasteboard:self.shareModel.listName];
                //下载并保存图片到本地
                [ShareParseTool downloadImagesAndSaveToLocation:self.shareModel.listImage completion:^(NSError * _Nonnull error) {
                    if (!error) {
                        //下载并保存带二维码的图片
                        if (self.shareModel.isNeedSaveQRImage) {
                            self.qrGraph=[US_QRGraphShareView getQRGraphShareViewWithModel:self.shareModel withTemplate:[ShareParseTool getLocalShareTemplateModel]];
                            [self.qrGraph transformContentViewToImageAndSaveToLocal:^{
                                //下载完成后弹出提示框
                                [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
                                US_MultiGraphShareView * multiGraph= [[US_MultiGraphShareView alloc] initWithFrame:CGRectZero];
                                [multiGraph showViewWithAnimation:AniamtionPresentBottom];
                            }];
                        }else{
                            //下载完成后弹出提示框
                            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
                            US_MultiGraphShareView * multiGraph= [[US_MultiGraphShareView alloc] initWithFrame:CGRectZero];
                            [multiGraph showViewWithAnimation:AniamtionPresentBottom];
                        }
                        //TODO:日志
                        [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                                                 @"分享页面":NonEmpty(self.shareModel.logPageName) ,
                                                                 @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                                                 @"分享类型":@"多图分享"}];
                    }else [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
                }];
            }else{
                [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
                //提示需要授权的Alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
        }
    } failed:^(NSError * _Nonnull error) {
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:[error.userInfo objectForKey:NSLocalizedDescriptionKey] afterDelay:0.3];
    }];
    NSString *listIdStr = [NSString stringWithFormat:@"nativeItem_%@", self.shareModel.listId];
    [UleMbLogOperate addMbLogClick:listIdStr moduleid:NonEmpty(self.shareModel.shareTitle) moduledesc:@"shareMultiImage" networkdetail:@""];
    [LogStatisticsManager onShareLog:@"PIC" tev:@"" andShareTo:@""];
}
//带二维码的商品图片分享
- (void)qrCodeShareAction{
    [self hiddenView];
    if (self.shareModel.listImage2.count>0) {
        [self showNewQRGraphShareView];
    }
    else if (self.shareModel.listImage.count > 0) {
        [self showQRGraphShareView];
    } else {
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在加载"];
        @weakify(self);
        [self.shareModel startRequestMultiPicInfo:^(id  _Nonnull responseObj) {
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
            @strongify(self);
            if (self.shareModel.listImage2.count>0) {
                [self showNewQRGraphShareView];
            }else{
                //显示二维码图片分享弹框
                [self showQRGraphShareView];
            }
        } failed:^(NSError * _Nonnull error) {
            [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:[error.userInfo objectForKey:NSLocalizedDescriptionKey] afterDelay:0.3];;
        }];
    }
    NSString *listIdStr = [NSString stringWithFormat:@"nativeItem_%@", self.shareModel.listId];
    [UleMbLogOperate addMbLogClick:listIdStr moduleid:NonEmpty(self.shareModel.shareTitle) moduledesc:@"shareQrCode" networkdetail:@""];
    [LogStatisticsManager onShareLog:@"QR" tev:NonEmpty(self.shareModel.shareTitle) andShareTo:@""];
}

//微信小程序分享
-(void)WXMiniProgramShare{
    Ule_ShareModel * shareModel=[[Ule_ShareModel alloc] initWithTitle:self.shareModel.shareTitle content:self.shareModel.shareContent imageUrl:nil linkUrl:nil shareType:@"100"];
    NSString * programType=@"1";//
    if ([NSString isNullToString:self.shareModel.WXMiniProgram_Type].length>0) {
        if ([[NSString isNullToString:self.shareModel.WXMiniProgram_Type] isEqualToString:@"0"]) {
            programType = @"1";
        }else{
            programType=@"0";
        }
    }
    //微信小程序参数
    [shareModel shareModelSetWXMiniProgramDataWithUserName:self.shareModel.WXMiniProgram_OriginalId
                                                       Path:self.shareModel.WXMiniProgram_path
                                                   ImageUrl:self.shareModel.shareImageUrl
                                                    PageUrl:self.shareModel.WXMiniProgram_pageUrl
                                               ProgramType:programType];
    if (self.shareModel.WXMiniProgram_Title.length>0) {
        shareModel.title=self.shareModel.WXMiniProgram_Title;
    }
    NSString * linkUrl=shareModel.linkUrl.length>0?shareModel.linkUrl:@"";
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    @weakify(self);
    [[Ule_ShareView shareViewManager] shareWithModel:shareModel withViewController:nil resultBlock:^(NSString *name, NSString * result) {
        @strongify(self);
        if (self.shareCallBack) {
            self.shareCallBack(result);
        }
        if ([result isEqualToString:SV_Success]) {
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];

            //记录
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"SHARE_SUCCESS" moduledesc:[linkUrl urlEncodedString] networkdetail:@""];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hiddenView];
        });
    }];
    //TODO:添加友盟统计
    [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                             @"分享页面":NonEmpty(self.shareModel.logPageName),
                                             @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                             @"分享类型":@"小程序分享"}];
    [LogStatisticsManager onShareLog:@"MiniProgram" tev:linkUrl andShareTo:@""];
    NSString *listIdStr = [NSString stringWithFormat:@"nativeItem_%@", self.shareModel.listId];
    [UleMbLogOperate addMbLogClick:listIdStr moduleid:NonEmpty(self.shareModel.shareTitle) moduledesc:@"shareToWechat" networkdetail:@""];
}

//复制链接
- (void)linkCopyAction{
    [self hiddenView];
    if (self.shareModel.shareUrl.length > 0) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        [board setString:self.shareModel.shareUrl];
        
        @weakify(self);
        US_BottomPresentAlertView *alertView = [US_BottomPresentAlertView BottomPresentAlertViewWithTitle:@"提示" Message:@"复制成功" cancelTitle:@"留在小店" ConfirmTitle:@"前往微信" confirmAction:^{
            @strongify(self);
            [self guideToWeiXin];
        }];
        [alertView showViewWithAnimation:AniamtionPresentBottom];
    }
    //TODO:添加友盟统计
    [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                             @"分享页面":NonEmpty(self.shareModel.logPageName),
                                             @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                             @"分享类型":@"复制链接"}];
    [LogStatisticsManager onShareLog:@"URL" tev:self.shareModel.shareUrl andShareTo:@""];
    NSString *listIdStr = [NSString stringWithFormat:@"nativeItem_%@", self.shareModel.listId];
    [UleMbLogOperate addMbLogClick:listIdStr moduleid:NonEmpty(self.shareModel.shareTitle) moduledesc:@"shareToWechat" networkdetail:@""];
}
//店铺海报
- (void)shareStorePosterView
{
    [self hiddenView];
    [LogStatisticsManager onShareLog:@"POSTER" tev:@"" andShareTo:@""];
    ShareStorePosterModel *shareStoreModel = [[ShareStorePosterModel alloc] init];
    shareStoreModel.qrCodeUrl = self.shareModel.shareUrl;
    PosterShareStyleView *storeShareView = [[PosterShareStyleView alloc] initWithShareType:ShareStoreType];
    [storeShareView loadModel:shareStoreModel];
    [storeShareView show];
}
//活动海报
- (void)shareActivityPosterView{
    [self hiddenView];
    [LogStatisticsManager onShareLog:@"ACTIVITY_POSTER" tev:@"" andShareTo:@""];
    US_ActivityPosterShareView *activityView=[[US_ActivityPosterShareView alloc]init];
    activityView.mShareModel=self.shareModel;
}
//软文分享
- (void)articalShareAction{
    [self hiddenView];
    NSMutableDictionary *param=@{@"key":[NSString isNullToString:self.shareModel.articleUrl]}.mutableCopy;
    [[UIViewController currentViewController] pushNewViewController:@"WebView" isNibPage:NO withData:param];
}

- (void)guideToWeiXin{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)showQRGraphShareView
{
    ShareTemplateList * template=[ShareParseTool getLocalShareTemplateModel];
    @weakify(self);
    [US_QRGraphShareView showQRGraphShareViewWithModel:self.shareModel withTemplate:template callBack:^(id  _Nonnull response) {
        @strongify(self);
        if (self.shareCallBack) {
            self.shareCallBack(response);
        }
        //TODO:红包雨逻辑
        //TODO:日志
        [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                                 @"分享页面":NonEmpty(self.shareModel.logPageName) ,
                                                 @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                                 @"分享类型":@"二维码分享"}];
    }];
}

- (void)showNewQRGraphShareView{
    @weakify(self);
    self.qrGraphNew=[US_NewQRGraphShareView showNewQRGraphShareViewWithModel:self.shareModel callBack:^(id  _Nonnull response) {
        @strongify(self);
        if (self.shareCallBack) {
            self.shareCallBack(response);
        }
        //TODO:红包雨逻辑
        //TODO:日志
        [MobClick event:@"shareAll" attributes:@{@"商品ID":[NSString stringWithFormat:@"%@", NonEmpty(self.shareModel.listId)],
                                                 @"分享页面":NonEmpty(self.shareModel.logPageName) ,
                                                 @"分享来源":NonEmpty(self.shareModel.logShareFrom),
                                                 @"分享类型":@"海报二维码分享"}];
    }];
}

#pragma mark - <setter and getter>
- (UILabel *) getInitLabel{
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:KScreenScale(28)];
    return label;
}
- (US_ActivityRuleView *)activityRuleView{
    if (!_activityRuleView) {
        _activityRuleView=[[US_ActivityRuleView alloc]initWithFrame:CGRectZero];
    }
    return _activityRuleView;
}
- (US_MessageCopyView *)messageCopyView{
    if (!_messageCopyView) {
        _messageCopyView=[[US_MessageCopyView alloc] initWithFrame:CGRectZero];
    }
    return _messageCopyView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor=[UIColor whiteColor];
        UIView * line=[UIView new];
        line.backgroundColor=kViewCtrBackColor;
        [_bottomView addSubview:line];
        line.sd_layout.leftSpaceToView(_bottomView, 0).topSpaceToView(_bottomView, 0)
        .rightSpaceToView(_bottomView, 0).heightIs(KScreenScale(10));
        UIButton * bottom_cancel=[[UIButton alloc] initWithFrame:CGRectZero];
        [bottom_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottom_cancel setBackgroundColor:[UIColor whiteColor]];
        [bottom_cancel.titleLabel setFont:[UIFont systemFontOfSize:KScreenScale(32)]];
        [bottom_cancel setTitle:@"取 消" forState:UIControlStateNormal];
        [bottom_cancel addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:bottom_cancel];
        bottom_cancel.sd_layout.leftSpaceToView(_bottomView, 0)
        .topSpaceToView(line,0)
        .rightSpaceToView(_bottomView, 0)
        .heightIs(KScreenScale(90));
    }
    return _bottomView;
}

- (UIView *)shareTypeView{
    if (!_shareTypeView) {
        _shareTypeView=[UIView new];
        _shareTypeView.backgroundColor=[UIColor whiteColor];
    }
    return _shareTypeView;
}
@end
