//
//  USScreenshotHelper.m
//  u_store
//
//  Created by xulei on 2018/7/5.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "USScreenshotHelper.h"
#import "Ule_ShareView.h"

typedef void(^DismissAnimatedCompleteBlock)(void);

@interface USScreenshotHelper ()
{
    UIImage *screenImage;
    UIView  *imgBgView;
    UIImageView *imgvPhoto;
}

@end

@implementation USScreenshotHelper

+(instancetype)shared
{
    static USScreenshotHelper *shared=nil;
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared=[[USScreenshotHelper alloc]init];
        });
    }
    return shared;
}

-(void)startMonitoring
{
    //注册用户的截屏操作通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

#pragma mark - 获取截图
//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    NSLog(@"检测到截屏");
    [self removeCutView];
    
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    screenImage = [[self imageWithScreenshot] copy];
    
    CGRect windowFrame=[UIApplication sharedApplication].keyWindow.frame;
    
    //添加边框
    imgBgView=[[UIView alloc]init];
    imgBgView.backgroundColor=[UIColor whiteColor];
    imgBgView.layer.cornerRadius=5.0;
    imgBgView.layer.borderColor=[UIColor convertHexToRGB:@"999999"].CGColor;
    imgBgView.layer.borderWidth=0.8;
    imgBgView.frame=CGRectMake(0, windowFrame.size.height-windowFrame.size.height/3.0, windowFrame.size.width/3.0, windowFrame.size.height/3.0);
    
    //添加图片
    imgvPhoto = [[UIImageView alloc]initWithImage:screenImage];
    imgvPhoto.frame = CGRectMake(5, 5, CGRectGetWidth(imgBgView.frame)-10, CGRectGetHeight(imgBgView.frame)-10);
    imgvPhoto.backgroundColor = [UIColor whiteColor];
    imgvPhoto.userInteractionEnabled = YES;
    [imgBgView addSubview:imgvPhoto];
    
    [[UIApplication sharedApplication].delegate.window addSubview:imgBgView];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView:)];
    [imgvPhoto addGestureRecognizer:tap];
    
    //5秒后隐藏
    [self performSelector:@selector(dismissAnimatedCompletion:) withObject:nil afterDelay:5.0f];
}

// 点击图片改变imageView位置,打印图片信息
- (void)tapImgView: (UITapGestureRecognizer *)tap {
    
    NSLog(@"点击了截图...");
    @weakify(self);
    [self dismissAnimatedCompletion:^{
        @strongify(self);
        [self shareFromNative];
    }];
}

-(void)shareFromNative{
    NSMutableArray *itemsArr=[NSMutableArray array];
    NSString *path_sandBox = NSHomeDirectory();
    NSString *imagePath = [path_sandBox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareScreen.jpg"]];
    [UIImageJPEGRepresentation(screenImage, 1.0) writeToFile:imagePath atomically:YES];
    
    NSURL *shareObj = [NSURL fileURLWithPath:imagePath];
    
    MultiShareItem *item = [[MultiShareItem alloc] initWithPlaceHolderImg:screenImage andShareFile:shareObj];
    [itemsArr addObject:item];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsArr applicationActivities:nil];
    activityVC.modalInPopover = true;
    activityVC.restorationIdentifier = @"screenActivity";
    
    if (@available(iOS 9.0, *)) {
        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    }
    if (activityVC) {
        //监听分享完成
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]&&completed) {
                //成功回调
                
            }
        };
    }
    [[UIViewController currentViewController] presentViewController:activityVC animated:YES completion:nil];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot {
    
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

#pragma mark - disappear
-(void)dismissAnimatedCompletion:(DismissAnimatedCompleteBlock)completionBlock
{
    @weakify(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect leftFrame=CGRectMake(-CGRectGetWidth(self->imgBgView.frame), CGRectGetMinY(self->imgBgView.frame), CGRectGetWidth(self->imgBgView.frame), CGRectGetHeight(self->imgBgView.frame));
        self->imgBgView.frame=leftFrame;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeCutView];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

-(void)removeCutView{
    if (imgBgView&&imgvPhoto) {
        [imgBgView removeFromSuperview];
        [imgvPhoto removeFromSuperview];
        imgBgView=nil;
        imgvPhoto=nil;
        //取消延时方法的调用
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAnimatedCompletion:) object:nil];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
