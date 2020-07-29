//
//  PosterShareStyleView.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/11/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "PosterShareStyleView.h"
#import "BtnImgAndTitle.h"
#import <UIView+SDAutoLayout.h>
#import <Ule_ShareView.h>
#import "ShareStorePosterView.h"
#import "TeamInviteShareView.h"
#import "USRedPacketCashManager.h"
#import <UIImage+Extension.h>
#import "PosterShareModel.h"
#import "UIView+Shade.h"
#import "USAuthorizetionHelper.h"

#define kShareHeight (KScreenScale(350)+(kStatusBarHeight==20?0:34))

@interface PosterShareStyleView ()
@property (nonatomic, assign) PosterViewType posterViewType;
@property (nonatomic, strong) UIView * backgroudView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * wxShareBtn;
@property (nonatomic, strong) UIButton * friendShareBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) ShareStorePosterView *shareStorePosterView;
@property (nonatomic, strong) TeamInviteShareView * invitePosterView;
@property (nonatomic, strong) NSString * qrCodeUrl;
@property (nonatomic, strong) UIView * shareView;

@end

@implementation PosterShareStyleView

- (instancetype)initWithShareType:(PosterViewType)posterViewType {
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        _posterViewType = posterViewType;
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    _backgroudView=[[UIView alloc] initWithFrame:self.bounds];
    _backgroudView.backgroundColor=[UIColor blackColor];
    _backgroudView.alpha=0.0;
    
    [self sd_addSubviews:@[self.backgroudView,self.invitePosterView,self.shareView,self.shareStorePosterView]];
    
    self.invitePosterView.sd_layout.bottomSpaceToView(self, kShareHeight+KScreenScale(40))
    .leftSpaceToView(self, (__MainScreen_Width-KScreenScale(640))/2.0)
    .widthIs(KScreenScale(640))
    .heightIs(KScreenScale(800));
    self.shareStorePosterView.sd_layout.bottomSpaceToView(self, kShareHeight+KScreenScale(40))
    .leftSpaceToView(self, (__MainScreen_Width-KScreenScale(590))/2.0)
    .widthIs(KScreenScale(590))
    .heightIs(KScreenScale(690));
    
    if (_posterViewType == TeamInviteType) {
        self.shareStorePosterView.hidden = YES;
    } else if (_posterViewType == ShareStoreType) {
        self.invitePosterView.hidden = YES;
    }
    
    self.shareView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self,__MainScreen_Height)
    .rightSpaceToView(self, 0)
    .heightIs(kShareHeight);
    [self loadShareViewUI];
}

- (void)loadShareViewUI{
    UIView * shareContent=[UIView new];
    UIView * line=[UIView new];
    line.backgroundColor=kViewCtrBackColor;
    [self.shareView sd_addSubviews:@[self.titleLabel,shareContent,line,self.cancelBtn]];
    
    self.titleLabel.sd_layout.leftSpaceToView(self.shareView, KScreenScale(10))
    .topSpaceToView(self.shareView, KScreenScale(20)).rightSpaceToView(self.shareView, KScreenScale(10))
    .heightIs(KScreenScale(30));
    
    NSArray *shareTitleArr = @[];
    NSArray *shareImgArr = @[];
    if (_posterViewType == ShareStoreType) {
        shareTitleArr = @[@"微信好友",@"朋友圈",@"保存图片"];
        shareImgArr = @[@"share_btn_wechat",@"share_btn_wxFriend",@"share_store_save"];
        self.titleLabel.sd_resetLayout.heightIs(0);
    } else if (_posterViewType == TeamInviteType) {
        shareTitleArr = @[@"微信好友",@"朋友圈"];
        shareImgArr = @[@"share_btn_wechat",@"share_btn_wxFriend"];
    }
    
    CGFloat margin=(__MainScreen_Width - KScreenScale(130)* shareImgArr.count) / (shareImgArr.count+1);
    int j=0;
    for (int i=0; i<shareTitleArr.count; i++) {
        BtnImgAndTitle * shareBtn=[[BtnImgAndTitle alloc] initWithFrame:CGRectZero];
        [shareBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:KScreenScale(23)]];
        [shareBtn setTitle:shareTitleArr[i] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage bundleImageNamed:shareImgArr[i]] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(btnClick:)
           forControlEvents:UIControlEventTouchUpInside];
        shareBtn.tag=i;
        [shareContent addSubview:shareBtn];
        shareBtn.sd_layout.leftSpaceToView(shareContent, (KScreenScale(130)+margin)*j).centerYEqualToView(shareContent)
        .widthIs(KScreenScale(130)).heightIs(KScreenScale(130));
        [shareContent setupAutoWidthWithRightView:shareBtn rightMargin:0];
        j++;
        if (![WXApi isWXAppInstalled]) {
            UIView *coverView=[[UIView alloc]init];
            coverView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.7];
            [shareBtn addSubview:coverView];
            coverView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        }
    }
    shareContent.sd_layout.centerXEqualToView(self.shareView).topSpaceToView(self.titleLabel, KScreenScale(20))
    .heightIs(KScreenScale(170));
    line.sd_layout.leftSpaceToView(self.shareView, 0)
    .topSpaceToView(shareContent, 0).rightSpaceToView(self.shareView, 0)
    .heightIs(KScreenScale(10));
    
    self.cancelBtn.sd_layout.leftSpaceToView(self.shareView, 0)
    .rightSpaceToView(self.shareView, 0).topSpaceToView(line, 0)
    .heightIs(KScreenScale(100));
    
}

- (void)changeStyle
{
    if (_posterViewType == ShareStoreType) {
        self.shareView.sd_layout.bottomEqualToView(self)
        .heightIs(kShareHeight-KScreenScale(45));
        
        self.shareView.layer.mask = [UIView drawCornerRadiusWithRect:self.shareView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(KScreenScale(30), KScreenScale(30))];
    }
}

- (void)loadModel:(id)model{
    PosterShareModel *shareModel = (PosterShareModel *)model;
    self.qrCodeUrl = shareModel.qrCodeUrl;
    if (_posterViewType == TeamInviteType) {
        self.invitePosterView.model = model;
    } else if (_posterViewType == ShareStoreType) {
        self.shareStorePosterView.model = model;
    }
}

- (void)show{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.frame=CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.sd_layout.topSpaceToView(self, __MainScreen_Height-kShareHeight);
        [self changeStyle];
        [self.shareView updateLayout];
        self.backgroudView.alpha=0.5;
        self.shareStorePosterView.alpha=1.0;
        self.invitePosterView.alpha=1.0;
    } completion:^(BOOL finished) {

    }];

}

#pragma mark - <button click>
- (void)cancelClick:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.sd_layout.topSpaceToView(self, __MainScreen_Height);
            [self.shareView updateLayout];
            self.alpha = 0.0f;
            self.backgroudView.alpha=0;
            self.shareStorePosterView.alpha=0;
            self.invitePosterView.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)btnClick:(BtnImgAndTitle *)sender{
    UIImage * postImage;
    
    if (_posterViewType == ShareStoreType) {
        postImage = [UIImage makeImageWithView:self.shareStorePosterView];
    } else if (_posterViewType == TeamInviteType) {
        postImage = [self.invitePosterView buildPostViewToImage];
    }
    NSData *imageData = UIImageJPEGRepresentation(postImage, 1.0);
    if (imageData.length > 9*1024*1024) {
        imageData = UIImageJPEGRepresentation(postImage, 0.8);
    }
    if (sender.tag == 0) {
        [self shareImageOnly:imageData shareType:UleShareTypeWXSession];
    } else if (sender.tag == 1) {
        [self shareImageOnly:imageData shareType:UleShareTypeWXTimeline];
    } else if (sender.tag == 2) {
        [self saveClick:postImage];
    }
    
}

- (void)saveClick:(UIImage *)postImage{
    if ([USAuthorizetionHelper photoLibaryAuth]) {
        if (_posterViewType == TeamInviteType) {
            [self.invitePosterView saveKoulingStr];
        }

        UIImageWriteToSavedPhotosAlbum(postImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 回调
    if (error) {
         [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:2.0];
    }else{
         [UleMBProgressHUD showHUDWithText:@"保存成功" afterDelay:2.0];
    }
}

-(void)shareImageOnly:(NSData *)imgData shareType:(UleShareType)sType{
    Ule_ShareClass *shareClass = [[Ule_ShareClass alloc] init];
    shareClass.shareType = sType;
    shareClass.imageData = imgData;
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [[Ule_ShareView shareViewManager] shareMethod:shareClass withViewController:[UIViewController currentViewController].navigationController];
    [self setShareBackCallMethodWithLink:@""];
}

//分享结果回调
-(void)setShareBackCallMethodWithLink:(NSString *)linkUrl{
    [Ule_ShareView shareViewManager].resultBlock = ^(NSString *name,NSString *result){
        if ([result isEqualToString:SV_Success]) {
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
            //记录
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"SHARE_SUCCESS" moduledesc:[self.qrCodeUrl urlEncodedString] networkdetail:@""];
        }
        [self cancelClick:nil];
    };
}

#pragma mark - <setter and getter>
- (UIView *)shareView{
    if (!_shareView) {
        _shareView=[[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, kShareHeight)];
        _shareView.backgroundColor=[UIColor whiteColor];
    }
    return _shareView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.text = @"选择分享方式后自动为您保存图片、复制口令";
        _titleLabel.textColor = [UIColor convertHexToRGB:kDarkTextColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor whiteColor]];
        _titleLabel.font = [UIFont systemFontOfSize:(KScreenScale(26))];
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn=[[UIButton alloc] init];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:(KScreenScale(34))]];
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (TeamInviteShareView *)invitePosterView{
    if (!_invitePosterView) {
        _invitePosterView=[[TeamInviteShareView alloc] initWithFrame:CGRectMake((__MainScreen_Width-KScreenScale(640))/2.0, kShareHeight+KScreenScale(40), KScreenScale(640), KScreenScale(800))];
        _invitePosterView.clipsToBounds=YES;
        _invitePosterView.layer.cornerRadius=5;
        _invitePosterView.backgroundColor=[UIColor clearColor];
    }
    return _invitePosterView;
}

- (ShareStorePosterView *)shareStorePosterView{
    if (!_shareStorePosterView) {
        _shareStorePosterView=[[ShareStorePosterView alloc] initWithFrame:CGRectMake((__MainScreen_Width-KScreenScale(640))/2.0, kShareHeight+KScreenScale(40), KScreenScale(590), KScreenScale(690))];
        _shareStorePosterView.clipsToBounds=YES;
        _shareStorePosterView.layer.cornerRadius=KScreenScale(14);
        _shareStorePosterView.backgroundColor=[UIColor whiteColor];
    }
    return _shareStorePosterView;
}

@end
