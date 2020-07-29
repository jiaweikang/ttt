//
//  US_ActivityPosterShareView.m
//  UleStoreApp
//
//  Created by xulei on 2020/2/12.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_ActivityPosterShareView.h"
#import <UIView+SDAutoLayout.h>
#import "USShareModel.h"
#import "UIImage+USAddition.h"
#import <UIImage+Extension.h>
#import <UIView+ShowAnimation.h>
#import "UIView+Shade.h"
#import "NSString+Addition.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import "USAuthorizetionHelper.h"

@interface US_ActivityPosterShareView ()
@property (nonatomic, strong) UIView        *bottomBgView;
@property (nonatomic, strong) UIImageView   *posterImageView;//展示的图
@property (nonatomic, strong) UIImageView   *sharePosterImageView;
@property (nonatomic, strong) UIImage       *cutImage;//750x1334的图
@property (nonatomic, strong) UIView        *qrBgView;//二维码背景图
@property (nonatomic, strong) UIImageView   *qrImageView;//二维码
@property (nonatomic, strong) UILabel       *mTitleLab;//提示语

@end

@implementation US_ActivityPosterShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    self.alpha_backgroundView=@"0.7";
    [self addSubview:self.bottomBgView];
    [self addSubview:self.posterImageView];
    CGFloat bottomViewHeight=CGRectGetHeight(self.bottomBgView.frame);
    CGFloat verticalPadding=KScreenScale(38);
    CGFloat maxPosterHeight=__MainScreen_Height-kStatusBarHeight-bottomViewHeight-verticalPadding;
    CGFloat posterHeight=KScreenScale(908)>maxPosterHeight?maxPosterHeight:KScreenScale(908);
    CGFloat posterWidth=375.0/667.0*posterHeight;
    CGFloat leftPadding=(__MainScreen_Width-posterWidth)*0.5;
    self.posterImageView.frame=CGRectMake(leftPadding, CGRectGetHeight(self.frame)-bottomViewHeight-verticalPadding-posterHeight, posterWidth, posterHeight);

    [self.sharePosterImageView sd_addSubviews:@[self.mTitleLab,self.qrBgView]];
    [self.qrBgView addSubview:self.qrImageView];
    CGFloat screenScale=[UIScreen mainScreen].scale;
    self.mTitleLab.sd_layout.centerXEqualToView(self.sharePosterImageView)
    .bottomSpaceToView(self.sharePosterImageView, 40/screenScale)
    .widthIs(0)
    .heightIs(40/screenScale);
    self.qrBgView.sd_layout.centerXEqualToView(self.sharePosterImageView)
    .bottomSpaceToView(self.mTitleLab, 20/screenScale)
    .widthIs(210/screenScale)
    .heightIs(210/screenScale);
    CGFloat padding = 6/screenScale;
    self.qrImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(padding, padding, padding, padding));
}

- (void)setMShareModel:(USShareModel *)mShareModel{
    _mShareModel=mShareModel;
    //标题
    if ([NSString isNullToString:mShareModel.posterTips].length>0) {
        self.mTitleLab.text=[NSString isNullToString:mShareModel.posterTips];
        CGFloat width = [self.mTitleLab.text widthForFont:self.mTitleLab.font]+15;
        self.mTitleLab.sd_layout.widthIs(width);
    }else if(!mShareModel.posterTips){
        self.mTitleLab.text=@"扫码享更多活动优惠";
        CGFloat width = [self.mTitleLab.text widthForFont:self.mTitleLab.font]+15;
        self.mTitleLab.sd_layout.widthIs(width);
    }
    //二维码
    UIImage *qrImage=[UIImage uleQRCodeForString:[NSString isNullToString:mShareModel.shareUrl] size:200 fillColor:[UIColor blackColor] iconImage:[UIImage imageNamed:@"US_icon"]];
    [self.qrImageView setImage:qrImage];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    manager.config.downloadTimeout = 20;
    [UleMBProgressHUD showHUDWithText:@"加载中..."];
    [manager downloadImageWithURL:[NSURL URLWithString:[NSString isNullToString:mShareModel.posterImageUrl]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        [UleMBProgressHUD hideHUD];
        if (finished&&image&&!error) {
            [self.sharePosterImageView setImage:image];
            self.cutImage=[UIImage makeImageWithView:self.sharePosterImageView];
            [self.posterImageView setImage:self.cutImage];
            [self showViewWithAnimation:AniamtionAlert];
        }else{
            [UleMBProgressHUD showHUDWithText:@"获取海报失败" afterDelay:1.5];
        }
    }];
}

- (void)saveBtnAction{
    if ([USAuthorizetionHelper photoLibaryAuth]) {
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在保存"];
        UIImageWriteToSavedPhotosAlbum(self.cutImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //弹alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - <图片成功保存回调>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
    if (error) {
        [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:1.5];
    }else{
        [self hiddenView];
        [UleMBProgressHUD showHUDWithText:@"海报已保存，正在跳转微信..." afterDelay:1.5 withTarget:self dothing:@selector(guideToWeiXin)];
    }
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

- (void)dismissBtnAction{
    [self hiddenView];
}

#pragma mark - <getters>
- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        CGFloat bottomHeight=KScreenScale(328)+KTabbarSafeBottomMargin;
        _bottomBgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-bottomHeight, __MainScreen_Width, bottomHeight)];
        _bottomBgView.backgroundColor=[UIColor whiteColor];
        _bottomBgView.layer.mask = [UIView drawCornerRadiusWithRect:_bottomBgView.bounds corners:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(KScreenScale(30), KScreenScale(30))];
        //标题
        UILabel *titleLab=[[UILabel alloc]init];
        titleLab.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"妙文复制，轻松分享" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: KScreenScale(28)],NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"333333"]}];
        titleLab.attributedText=titleStr;
        [_bottomBgView addSubview:titleLab];
        titleLab.sd_layout.topSpaceToView(_bottomBgView, KScreenScale(50))
        .leftSpaceToView(_bottomBgView, 0)
        .rightSpaceToView(_bottomBgView, 0)
        .heightIs(KScreenScale(30));
        //step1
        UIImageView *imageview1=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"share_img_step1"]];
        [_bottomBgView addSubview:imageview1];
        UILabel *lab1=[[UILabel alloc]init];
        NSMutableAttributedString *lab1Str = [[NSMutableAttributedString alloc] initWithString:@"保存图片到手机相册" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:KScreenScale(24)],NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"666666"]}];
        lab1.attributedText=lab1Str;
        [_bottomBgView addSubview:lab1];
        //step2
        UIImageView *imageview2=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"share_img_step2"]];
        [_bottomBgView addSubview:imageview2];
        UILabel *lab2=[[UILabel alloc]init];
        NSMutableAttributedString *lab2Str = [[NSMutableAttributedString alloc] initWithString:@"打开微信，从手机相册中选择图片发布至朋友圈" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:KScreenScale(24)],NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"666666"]}];
        lab2.attributedText=lab2Str;
        [_bottomBgView addSubview:lab2];
        CGFloat lab2Width=[lab2Str.string widthForFont:lab2.font]+3;
        lab2.sd_layout.centerXEqualToView(_bottomBgView)
        .topSpaceToView(titleLab, KScreenScale(90))
        .widthIs(lab2Width)
        .heightIs(KScreenScale(25));
        imageview2.sd_layout.rightSpaceToView(lab2, KScreenScale(17))
        .centerYEqualToView(lab2)
        .widthIs(KScreenScale(30))
        .heightIs(KScreenScale(30));
        lab1.sd_layout.bottomSpaceToView(lab2, KScreenScale(30))
        .leftEqualToView(lab2)
        .rightSpaceToView(_bottomBgView, 0)
        .heightIs(KScreenScale(25));
        imageview1.sd_layout.rightSpaceToView(lab1, KScreenScale(17))
        .centerYEqualToView(lab1)
        .widthIs(KScreenScale(30))
        .heightIs(KScreenScale(30));
        //保存图片
        UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame=CGRectMake(0, 0, KScreenScale(410), KScreenScale(70));
        [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        saveBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(28)];
        [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        CAGradientLayer * layer=[UIView setGradualChangingColor:saveBtn fromColor:[UIColor convertHexToRGB:@"FE5F45"] toColor:[UIColor convertHexToRGB:@"FD2448"] gradualType:GradualTypeHorizontal];
        [saveBtn.layer addSublayer:layer];
        layer.zPosition=-1;
        saveBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        [_bottomBgView addSubview:saveBtn];
        saveBtn.sd_layout.topSpaceToView(lab2, KScreenScale(44))
        .centerXEqualToView(_bottomBgView)
        .widthIs(KScreenScale(410))
        .heightIs(KScreenScale(70));
    }
    return _bottomBgView;
}

- (UIImageView *)posterImageView{
    if (!_posterImageView) {
        _posterImageView=[[UIImageView alloc]init];
        _posterImageView.userInteractionEnabled=YES;
        _posterImageView.layer.cornerRadius=KScreenScale(10);
        _posterImageView.clipsToBounds=YES;
        UIButton *dismissBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [dismissBtn setBackgroundImage:[UIImage bundleImageNamed:@"share_activityPoster_dismiss"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dismissBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_posterImageView addSubview:dismissBtn];
        dismissBtn.sd_layout.topSpaceToView(_posterImageView, 5)
        .rightSpaceToView(_posterImageView, 5)
        .widthIs(28)
        .heightIs(28);
    }
    return _posterImageView;
}

- (UIImageView *)sharePosterImageView{
    if (!_sharePosterImageView) {
        CGFloat screenScale = [UIScreen mainScreen].scale;
        _sharePosterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 750/screenScale, 1334/screenScale)];
    }
    return _sharePosterImageView;
}

- (UILabel *)mTitleLab{
    if (!_mTitleLab) {
        _mTitleLab=[[UILabel alloc]init];
        _mTitleLab.backgroundColor=[UIColor whiteColor];
        _mTitleLab.textAlignment=NSTextAlignmentCenter;
        _mTitleLab.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        _mTitleLab.font=[UIFont systemFontOfSize:22/[UIScreen mainScreen].scale];
        _mTitleLab.sd_cornerRadiusFromHeightRatio=@(0.5);
        _mTitleLab.clipsToBounds=YES;
    }
    return _mTitleLab;
}

- (UIView *)qrBgView{
    if (!_qrBgView) {
        _qrBgView=[[UIView alloc]init];
        _qrBgView.backgroundColor=[UIColor whiteColor];
        _qrBgView.layer.cornerRadius=7.0;
        _qrBgView.clipsToBounds=YES;
    }
    return _qrBgView;
}

- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView=[[UIImageView alloc]init];
    }
    return _qrImageView;
}

@end
