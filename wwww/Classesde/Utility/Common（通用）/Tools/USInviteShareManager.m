//
//  USInviteShareManager.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USInviteShareManager.h"
#import "USInviteAlertView.h"
#import "USShareView.h"
#import <UIView+ShowAnimation.h>
#import "US_NetworkExcuteManager.h"
#import "US_UserCenterApi.h"
#import <UIView+SDAutoLayout.h>
#import "UIImage+USAddition.h"
#import "UIImage+Extension.h"
#import <MJExtension/MJExtension.h>
#import <NSObject+YYModel.h>
#import "FeaturedModel_InviteOpen.h"
#import "USRedPacketCashManager.h"
#import "USImageDownloadManager.h"

@interface USInviteShareManager ()
@property (nonatomic, strong) UleNetworkExcute   *networkClient_API;
@property (nonatomic, strong) UleNetworkExcute   *networkClient_staticCDN;
@end

@implementation USInviteShareManager

+ (instancetype)sharedManager
{
    static USInviteShareManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[USInviteShareManager alloc] init];
        });
    }
    return sharedManager;
}

- (void)inviteShareToOpenStore
{
    [UleMBProgressHUD showHUDWithText:@""];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetInviteUrlReuqest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *urlStr = [responseDic objectForKey:@"data"];
        if (urlStr.length<=0) return;
        USInviteAlertView *alertView = [[USInviteAlertView alloc]initWithSure1:@"分享二维码" withSure2:@"分享链接" withCancel:@"取消" withTitle:@"邀请好友  开店创业"];
        alertView.btnActionBlock = ^(NSInteger index) {
            if (index==1) {
                [self shareOpenDownloadBackgroundImageWithQRStr:urlStr];
            }else if (index==2) {
                [self shareActionWithQRStr:urlStr];
            }
        };
        [alertView showViewWithAnimation:AniamtionPresentBottom];
    } failure:^(UleRequestError *error) {
        [self showErrorHud:error];
    }];
}


- (void)inviteShareMyStore
{
    [UleMBProgressHUD showHUDWithText:@""];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetMyStoreUrlRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        [self handleShareInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHud:error];
    }];
}

- (void)shareFenxiaoMyStore{
    @weakify(self);
    [UleMBProgressHUD showHUDWithText:@""];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetFenxiaoMyStoreUrlRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        [self handleShareInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHud:error];
    }];
}

- (void)handleShareInfo:(id)responseObj{
    ShareMyStoreModel *shareStoreModel = [ShareMyStoreModel mj_objectWithKeyValues:responseObj];
    ShareMyStoreInfo *shareStoreInfo = shareStoreModel.data;
    NSString *shareStoreLink = [NSString isNullToString:shareStoreInfo.shareUrl4].length > 0 ? shareStoreInfo.shareUrl4 : shareStoreInfo.shareUrl3;
    if (shareStoreLink.length<=0) return;
    
    NSString *shareStoreTitle = [NSString isNullToString:[US_UserUtility sharedLogin].m_stationName];
    NSString *shareStoreContent = [NSString isNullToString:[US_UserUtility sharedLogin].m_storeDesc];
    NSString *shareStoreImgUrl = [NSString isNullToString:[US_UserUtility sharedLogin].m_userHeadImgUrl].length > 0 ? [US_UserUtility sharedLogin].m_userHeadImgUrl : @"https://pic.ule.com/item/user_0102/desc20190618/a6dac43759a34c34_-1x-1.png";
    
    shareStoreTitle = shareStoreTitle.length>0?shareStoreTitle:[NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
    shareStoreContent = shareStoreContent.length>0?shareStoreContent:@"发现一家好店铺，分享给你哦!";
    if ([shareStoreImgUrl containsString:@"ule.com"]) {
        shareStoreImgUrl = [NSString getImageUrlString:kImageUrlType_XL withurl:shareStoreImgUrl];
    }
    
    USShareModel *shareModel=[[USShareModel alloc] init];
    shareModel.shareUrl = shareStoreLink;
    shareModel.shareTitle = shareStoreTitle;
    shareModel.shareContent = shareStoreContent;
    shareModel.shareImageUrl = shareStoreImgUrl;
    shareModel.shareOptions = shareStoreInfo.shareOptions;
    shareModel.favsListingStr = shareStoreInfo.favsListingStr;
    shareModel.WXMiniProgram_path = shareStoreInfo.miniWxShareInfo.path;
    shareModel.WXMiniProgram_OriginalId = shareStoreInfo.miniWxShareInfo.originalId;
    
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {}];
}

#pragma mark - <ACTIONS>
- (void)shareOpenDownloadBackgroundImageWithQRStr:(NSString *)qrStr{
    //下载图片
    [UleMBProgressHUD showHUDWithText:@""];
    [self.networkClient_staticCDN beginRequest:[US_UserCenterApi buildGetInviteOpenBackroundImage] success:^(id responseObject) {
        FeaturedModel_InviteOpen *responseModel = [FeaturedModel_InviteOpen yy_modelWithDictionary:responseObject];
        FeaturedModel_InviteOpenIndex *firstItem=[responseModel.indexInfo firstObject];
        @weakify(self);
        [[USImageDownloadManager sharedManager]asyncDownloadWithLink:[NSString isNullToString:firstItem.imgUrl] success:^(NSData * _Nullable data) {
            @strongify(self);
            UIImage *backgroundImage=[UIImage imageWithData:data];
            UIImage *shareImage;
            if ([[UleStoreGlobal shareInstance].config.clientType isEqualToString:@"ylxd"]) {
                shareImage=[self getOpenStoreImage:qrStr andBackgroundImage:backgroundImage];
            }else if([[UleStoreGlobal shareInstance].config.clientType isEqualToString:@"ylxdsq"]){
                shareImage=[self getOpenUleMarketImage:qrStr andBackgroundImage:backgroundImage];
            }
            [UleMBProgressHUD hideHUD];
            [self shareActionWithImage:shareImage];
        } fail:^(NSError * _Nullable error) {
            [UleMBProgressHUD hideHUD];
        }];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUD];
        UIImage *shareImage;
        if ([[UleStoreGlobal shareInstance].config.clientType isEqualToString:@"ylxd"]) {
            shareImage=[self getOpenStoreImage:qrStr andBackgroundImage:nil];
        }else if([[UleStoreGlobal shareInstance].config.clientType isEqualToString:@"ylxdsq"]){
            shareImage=[self getOpenUleMarketImage:qrStr andBackgroundImage:nil];
        }
        [self shareActionWithImage:shareImage];
    }];
}

- (void)shareActionWithImage:(UIImage *)image{
    if (!image) {
        return;
    }
    NSData *imageData=UIImageJPEGRepresentation(image, 1.0);
    if (imageData.length>9*1024*1024) {
        imageData=UIImageJPEGRepresentation(image, 0.8);
    }
    //二维码分享
    Ule_ShareModel *qrModel = [[Ule_ShareModel alloc]init];
    qrModel.shareType=@"110";
    qrModel.singleImgData=imageData;
    [self shareWithModel:qrModel];
}

//链接分享
- (void)shareActionWithQRStr:(NSString *)qrStr{
    //链接
    Ule_ShareModel *urlModel = [[Ule_ShareModel alloc]init];
    urlModel.shareType=@"110";
    urlModel.title=@"30秒快速注册，马上拥有属于您的小店";
    urlModel.content=@"精选商品一键分享朋友圈，自己购买得返利，拼团购买享低价！你只管省钱就行";
    urlModel.imageUrl=[UleStoreGlobal shareInstance].config.appLogoUrl;
    urlModel.linkUrl=qrStr;
    [self shareWithModel:urlModel];
}

- (void)shareWithModel:(Ule_ShareModel *)model{
    [[Ule_ShareView shareViewManager] registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [[Ule_ShareView shareViewManager] shareWithModel:model withViewController:[UIViewController currentViewController].tabBarController viewTitle:@"通过社交软件分享才能获得更多客流哟" resultBlock:^(NSString *name, NSString *result) {
        if ([result isEqualToString:SV_Success]) {
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
        }
    }];
}

-(UIImage *)getOpenStoreImage:(NSString *)qrUrl andBackgroundImage:(UIImage *)backImage{
    UIView *shareBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenScale(590), KScreenScale(896))];
    shareBgView.backgroundColor=[UIColor whiteColor];
    //背景
    UIImageView *shareTopImgView=[[UIImageView alloc]initWithImage:backImage?backImage:[UIImage bundleImageNamed:@"invite_img_openstore_bg"]];
    [shareBgView addSubview:shareTopImgView];
    shareTopImgView.sd_layout.topSpaceToView(shareBgView, 0)
    .leftSpaceToView(shareBgView, 0)
    .rightSpaceToView(shareBgView, 0)
    .heightIs(KScreenScale(896));
    
    //二维码
    UIImageView *mQRImageView=[[UIImageView alloc] init];
    mQRImageView.image = [UIImage uleQRCodeForString:qrUrl size:200 fillColor:[UIColor blackColor] iconImage:nil];
    [shareBgView addSubview:mQRImageView];
    mQRImageView.sd_layout.bottomSpaceToView(shareBgView, KScreenScale(20))
    .leftSpaceToView(shareBgView, KScreenScale(300))
    .widthIs(KScreenScale(230))
    .heightEqualToWidth();
    
    //截取图片
    UIImage * theImage=[UIImage makeImageWithView:shareBgView];
    return theImage;
}

-(UIImage *)getOpenUleMarketImage:(NSString *)qrUrl andBackgroundImage:(UIImage *)backImage{
    UIView *shareBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenScale(590), KScreenScale(760))];
    shareBgView.backgroundColor=[UIColor whiteColor];
        //背景
    UIImageView *shareTopImgView=[[UIImageView alloc]initWithImage:backImage?backImage:[UIImage imageNamed:@"invite_img_openstore_bg"]];
    [shareBgView addSubview:shareTopImgView];
    shareTopImgView.sd_layout.topSpaceToView(shareBgView, 0)
    .leftSpaceToView(shareBgView, 0)
    .rightSpaceToView(shareBgView, 0)
    .heightIs(KScreenScale(760));
        
    //二维码
    UIImageView *mQRImageView=[[UIImageView alloc] init];
    mQRImageView.image = [UIImage uleQRCodeForString:qrUrl size:1000 fillColor:[UIColor blackColor] iconImage:[UIImage imageNamed:@"US_icon.png"]];
    UIView * mQRbgView=[[UIView alloc] init];
    mQRbgView.backgroundColor=[UIColor whiteColor];
    mQRbgView.layer.cornerRadius=KScreenScale(10);
    mQRbgView.clipsToBounds=YES;
    [shareBgView addSubview:mQRbgView];
    mQRbgView.sd_layout.bottomSpaceToView(shareBgView, KScreenScale(80))
    .centerXEqualToView(shareBgView)
    .widthIs(KScreenScale(220))
    .heightEqualToWidth();
    [mQRbgView addSubview:mQRImageView];
    mQRImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(KScreenScale(10), KScreenScale(10), KScreenScale(10), KScreenScale(10)));
    //截取图片
    UIImage * theImage=[UIImage makeImageWithView:shareBgView];
    return theImage;
}

- (UIImage *)getMyStoreImage:(NSString *)shareLink{
    UIView *shareBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenScale(642), KScreenScale(704))];
    shareBgView.backgroundColor=[UIColor whiteColor];
    //上部视图
    UIImageView *shareTopImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"invite_img_openstore_topbg"]];
    [shareBgView addSubview:shareTopImgView];
    shareTopImgView.sd_layout.topEqualToView(shareBgView)
    .leftEqualToView(shareBgView)
    .rightEqualToView(shareBgView)
    .heightIs(KScreenScale(242));
    //用户头像
    UIImageView *userImgView=[[UIImageView alloc]init];
    userImgView.clipsToBounds=YES;
    userImgView.layer.cornerRadius=KScreenScale(130)*0.5;
    [shareTopImgView addSubview:userImgView];
    userImgView.sd_layout.centerYEqualToView(shareTopImgView)
    .leftSpaceToView(shareTopImgView, KScreenScale(82))
    .widthIs(KScreenScale(130))
    .heightIs(KScreenScale(132));
    if ([US_UserUtility sharedLogin].m_userHeadImage) {
        [userImgView setImage:[US_UserUtility sharedLogin].m_userHeadImage];
    }else if ([US_UserUtility sharedLogin].m_userHeadImgUrl&&[US_UserUtility sharedLogin].m_userHeadImgUrl.length>0) {
        [userImgView yy_setImageWithURL:[NSURL URLWithString:[US_UserUtility sharedLogin].m_userHeadImgUrl] placeholder:[UIImage bundleImageNamed:@"my_img_head_default"]];
    }else [userImgView setImage:[UIImage bundleImageNamed:@"my_img_head_default"]];
    //店主名
    UILabel *shareNameLab=[[UILabel alloc]init];
    shareNameLab.text=[US_UserUtility sharedLogin].m_userName;
    shareNameLab.textColor=[UIColor whiteColor];
    shareNameLab.font=[UIFont systemFontOfSize:KScreenScale(40)];
    [shareTopImgView addSubview:shareNameLab];
    shareNameLab.sd_layout.centerYEqualToView(shareTopImgView)
    .leftSpaceToView(userImgView, KScreenScale(40))
    .rightSpaceToView(shareTopImgView, 0)
    .heightIs(KScreenScale(38));
    //二维码
    UIImage *iconImg=[UIImage bundleImageNamed:@"my_img_head_default"];
    if ([US_UserUtility sharedLogin].m_userHeadImage) {
        iconImg = [US_UserUtility sharedLogin].m_userHeadImage;
    }
    UIImageView *mQRImageView=[[UIImageView alloc] init];
    mQRImageView.image = [UIImage uleQRCodeForString:shareLink size:200 fillColor:[UIColor blackColor] iconImage:iconImg];
    [shareBgView addSubview:mQRImageView];
    mQRImageView.sd_layout.topSpaceToView(shareTopImgView, KScreenScale(60))
    .centerXEqualToView(shareBgView)
    .widthIs(KScreenScale(236))
    .heightIs(KScreenScale(236));
    
    UILabel *bottomLab1=[[UILabel alloc]init];
    bottomLab1.text=@"长按或扫描识别二维码";
    bottomLab1.textColor=[UIColor convertHexToRGB:@"666666"];
    bottomLab1.font=[UIFont systemFontOfSize:KScreenScale(30)];
    bottomLab1.textAlignment=NSTextAlignmentCenter;
    [shareBgView addSubview:bottomLab1];
    bottomLab1.sd_layout.topSpaceToView(mQRImageView, KScreenScale(20))
    .leftSpaceToView(shareBgView, 0)
    .rightSpaceToView(shareBgView, 0)
    .heightIs(KScreenScale(40));
    
    UILabel *bottomLab2=[[UILabel alloc]init];
    bottomLab2.text=@"进入小店";
    bottomLab2.textColor=[UIColor convertHexToRGB:@"333333"];
    bottomLab2.font=[UIFont boldSystemFontOfSize:KScreenScale(40)];
    bottomLab2.textAlignment=NSTextAlignmentCenter;
    [shareBgView addSubview:bottomLab2];
    bottomLab2.sd_layout.topSpaceToView(bottomLab1, 0)
    .leftSpaceToView(shareBgView, 0)
    .rightSpaceToView(shareBgView, 0)
    .heightIs(KScreenScale(60));
    
    //截取图片
    UIImage * theImage=[UIImage makeImageWithView:shareBgView];
    return theImage;
}

- (void)showErrorHud:(UleRequestError *)error
{
    NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
    if ([NSString isNullToString:errorInfo].length>0) {
        [UleMBProgressHUD showHUDWithText:errorInfo afterDelay:1.5];
    }else [UleMBProgressHUD hideHUD];
}

#pragma mark - <getters>
- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}
-(UleNetworkExcute *)networkClient_staticCDN{
    if (!_networkClient_staticCDN) {
        _networkClient_staticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_staticCDN;
}

@end





@implementation ShareMyStoreMiniWxInfo
@end

@implementation ShareMyStoreInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"miniWxShareInfo" : [ShareMyStoreMiniWxInfo class]
             };
}
@end

@implementation ShareMyStoreModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShareMyStoreInfo class],
             };
}
@end
