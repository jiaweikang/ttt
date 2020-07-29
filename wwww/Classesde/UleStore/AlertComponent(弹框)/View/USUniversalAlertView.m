//
//  USUniversalAlertView.m
//  u_store
//
//  Created by mac_chen on 2019/2/20.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USUniversalAlertView.h"
#import "USUniversalAlertShareView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "USUniversalAlertModelManager.h"
#import "UIImage+Extension.h"
#import "UleMbLogOperate.h"
#import "UlePushHelper.h"
#import "UIView+ShowAnimation.h"
#import "USShareView.h"
#import "CustomAlertViewManager.h"
#import "FeatureModel_ActivityDialog.h"
#import <UIView+SDAutoLayout.h>

#define CloseBtnTag   1000
#define ConfirmBtnTag 2000
#define ImageBtnTag   3000

@interface USUniversalAlertView ()

@property (nonatomic, copy) AlertConfirmBlock confirmBlock;
@property (nonatomic, copy) AlertCloseBlock closeBlock;

@property (nonatomic, strong) ActivityDialogIndexInfo *model;

@property (nonatomic, strong) UIImageView *closeImgView; //关闭按钮
@property (nonatomic, strong) UIImageView *confirmImgView; //底部按钮
@property (nonatomic, strong) UIImageView *activeImgView; //活动图片
@property (nonatomic, strong) UILabel     *confirmLabel; //底部按钮文字

@property (nonatomic, strong) USUniversalAlertShareView *shareView;
@property (nonatomic, strong) UIViewController       *hudShowedVC;
@property (nonatomic, strong) ShareCreateData *shareData;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, assign) BOOL alerViewHadshow;
@end

@implementation USUniversalAlertView

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (self.alerViewHadshow==NO) {
        self.alerViewHadshow=YES;
        [[USUniversalAlertModelManager sharedManager] setAlertShowTimes:NonEmpty(self.model.activity_code)];
    }
}

+ (USUniversalAlertView *)alertWithData:(ActivityDialogIndexInfo *)data confirmBlock:(AlertConfirmBlock)confirmBlock closeBlock:(AlertCloseBlock)closeBlock{
    return [[self alloc] initWithData:data confirmBlock:confirmBlock closeBlock:closeBlock];
}

- (instancetype)initWithData:(ActivityDialogIndexInfo *)data confirmBlock:(AlertConfirmBlock)confirmBlock closeBlock:(AlertCloseBlock)closeBlock{
    self = [super init];
    if (self) {
        self.model = data;
        self.confirmBlock = confirmBlock;
        self.closeBlock = closeBlock;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    self.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
    //活动图片
    self.activeImgView = [[UIImageView alloc] init];
    self.activeImgView.tag = ImageBtnTag;
    [self.activeImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl]];
    self.activeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.activeImgView addGestureRecognizer:tap1];

    //关闭按钮
    self.closeImgView = [[UIImageView alloc] init];
    self.closeImgView.tag = CloseBtnTag;
    [self.closeImgView sd_setImageWithURL:[NSURL URLWithString:self.model.close_image]];
    self.closeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.closeImgView addGestureRecognizer:tap2];

    //底部操作按钮
    self.confirmImgView = [[UIImageView alloc] init];
    self.confirmImgView.tag = ConfirmBtnTag;
    if (self.model.button_img.length > 0) {
        [self.confirmImgView sd_setImageWithURL:[NSURL URLWithString:self.model.button_img]];
    } else {
        self.confirmImgView.backgroundColor = [UIColor clearColor];
    }

    //底部按钮文字
    self.confirmLabel = [[UILabel alloc] init];
    self.confirmLabel.text = self.model.button_text;
    self.confirmLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
    self.confirmLabel.textColor = self.model.button_text_color.length > 0 ? [UIColor convertHexToRGB:self.model.button_text_color] : [UIColor blackColor];
    self.confirmLabel.textAlignment = 1;
    if ([self.model.button_type isEqualToString:@"0"] || [self.model.button_type isEqualToString:@"1"] || self.model.link.length > 0 || self.model.ios_action.length > 0) {
        self.confirmImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.confirmImgView addGestureRecognizer:tap3];
    }

    [self addSubview:self.activeImgView];
    [self addSubview:self.confirmImgView];
    [self.activeImgView addSubview:self.closeImgView];
    [self.confirmImgView addSubview:self.confirmLabel];
    self.activeImgView.sd_layout.centerYIs(self.centerY_sd-20)
    .centerXIs(self.centerX_sd)
    .widthIs(KScreenScale(680))
    .heightIs(KScreenScale(900));
    self.closeImgView.sd_layout.topSpaceToView(self.activeImgView, KScreenScale(28))
    .rightSpaceToView(self.activeImgView, KScreenScale(32))
    .widthIs(KScreenScale(72))
    .heightIs(KScreenScale(72));
    self.confirmImgView.sd_layout.topSpaceToView(self.activeImgView, KScreenScale(42))
    .leftEqualToView(self.activeImgView)
    .widthIs(KScreenScale(680))
    .heightIs(KScreenScale(100));
    self.confirmLabel.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSString *moduleid = @"";
    if (tap.view.tag == ConfirmBtnTag) {
        if ([self.model.button_type isEqualToString:@"0"]) {
            moduleid = @"活动弹框_按钮打开";
            if (_confirmBlock) {
                _confirmBlock(alertClickType_button);
            }
            [self dismissSelf];
        } else {
            moduleid = @"活动弹框_按钮保存";
            [UleMBProgressHUD showHUDWithText:@"正在保存"];
            if ([NSString isNullToString:self.model.listId].length > 0 || [NSString isNullToString:self.model.shareUrl].length > 0) {
                @weakify(self);
                [[USUniversalAlertModelManager sharedManager] getShareUrlWithData:@{@"shareUrl":self.model.shareUrl, @"listId":self.model.listId}.mutableCopy successBlock:^(NSString * _Nonnull shareUrl, ShareCreateData *data) {
                    shareUrl = [NSString isNullToString:shareUrl].length > 0 ? shareUrl : self.model.shareUrl;
                    @strongify(self);
                    if ([NSString isNullToString:shareUrl].length > 0) {
                        self.shareData = data;
                        self.shareUrl = shareUrl;
                        NSMutableDictionary *dic= @{
                                                    @"shareUrl":shareUrl,
                                                    @"imageUrl":self.model.shareImage,
                                                    }.mutableCopy;
                        if (!self.shareView) {
                            self.shareView = [[USUniversalAlertShareView alloc] initWithData:dic];
                        }
                        //延迟保存，有时图片会加载不出来
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self saveImage:[self getImage]];
                        });
                    } else {
                        [self callBack:NO];
                    }
                }];
            } else {
                if ([NSString isNullToString:self.model.link].length > 0) {
                    if ([self.model.link containsString:@"?"]) {
                        self.model.link = [NSString stringWithFormat:@"%@&storeid=%@", self.model.link, [US_UserUtility sharedLogin].m_userId];
                    } else {
                        self.model.link = [NSString stringWithFormat:@"%@?storeid=%@", self.model.link, [US_UserUtility sharedLogin].m_userId];
                    }
                    NSMutableDictionary *dic= @{
                                                @"shareUrl":self.model.link,
                                                @"imageUrl":self.model.shareImage,
                                                }.mutableCopy;
                    if (!_shareView) {
                        self.shareView = [[USUniversalAlertShareView alloc] initWithData:dic];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self saveImage:[self getImage]];
                    });
                }
            }
        }
    } else if (tap.view.tag == ImageBtnTag) {
        moduleid = @"活动弹框_图片打开";
        if (_confirmBlock) {
            _confirmBlock(alertClickType_image);
        }
        [self dismissSelf];
    } else if (tap.view.tag == CloseBtnTag) {
        if (_closeBlock) {
            _closeBlock();
        }
        [self dismissSelf];
    }
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", self.model.activity_code]
                          moduleid:moduleid
                        moduledesc:self.model.log_title
                     networkdetail:@""];
}

- (void)dismissSelf{
    dispatch_async(dispatch_get_main_queue(), ^{
         [self hiddenView];
    });
}

/** 保存图片 */
- (void)saveImage:(UIImage *)image {
    self.shareView.hidden = YES;
    //判断有无相册权限，有则存储照片，无则提示
    BOOL isAuth = [self photoLibaryAuth];
    if (isAuth) {
        [self saveiOSImage:image];
    }
    else {
        [self callBack:isAuth];
    }
}

#pragma mark - iOS 保存到相册 通用
- (void)saveiOSImage:(UIImage *)image {
    if (!image) {
        // 回调
        [self callBack:NO];
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 回调
    [self callBack:!error];
}

#pragma mark - 调用保存相册 回调
- (void)callBack:(BOOL)isSuccess {
    [UleMBProgressHUD hideHUD];
    if (isSuccess) {
        [UleMBProgressHUD showHUDWithText:@"保存成功" afterDelay:1 withTarget:self dothing:@selector(saveImageSuccess)];
    }
    else {
        BOOL isNOAuth = ![self photoLibaryAuth];
        if (isNOAuth) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:1.0];
            self.confirmImgView.userInteractionEnabled = YES;
        }
    }
}

/**
 *  判断有无相册权限
 */
- (BOOL)photoLibaryAuth {
    BOOL isAuth = NO;
    if (kSystemVersion>=9.0) {
        //请求权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        isAuth = !(status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted);
    }
    else {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        isAuth = !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied);
    }
    return isAuth;
}

- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (UIImage *)getImage {
    
    UIImage *theImage=[UIImage makeImageWithView:self.shareView];
    return theImage;
}

- (void)saveImageSuccess{
    //设置弹框管理容器中剩下的弹框不自动弹出
    [CustomAlertViewManager sharedManager].isCancelShowAutomic=YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddenViewWithCompletion:^{
            USShareModel * shareModel=[[USShareModel alloc] init];
            shareModel.additionalShareInfo=[NSString isNullToString:self.model.shareCopywriting].length > 0 ? self.model.shareCopywriting : self.shareData.additionalShareInfo;
            shareModel.isNeedSaveQRImage=YES;
            self.shareView.hidden=NO;
            [self.shareView setNeedsDisplay];
            UIImage * image=[self getImage];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            if (imageData.length > 9*1024*1024) {
                imageData = UIImageJPEGRepresentation(image, 0.8);
            }
            shareModel.shareImageData=imageData;
            shareModel.logPageName=@"活动弹框";
            shareModel.logShareFrom=@"首页";
            shareModel.shareChannel=@"";
            shareModel.shareFrom=@"";
            //shareModel.shareType=@"1100";
            shareModel.shareOptions=@"0##1";
            [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
                
            }];
        }];
    });
}

@end
