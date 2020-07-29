//
//  US_NewQRGraphShareView.m
//  UleStoreApp
//
//  Created by lei xu on 2020/5/9.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_NewQRGraphShareView.h"
#import "USShareModel.h"
#import <UIView+ShowAnimation.h>
#import "US_SharePageControl.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIView+Shade.h"
#import "UleControlView.h"
#import "USImageDownloadManager.h"
#import <UIImage+Extension.h>
#import "USApplicationLaunchManager.h"

#define kBottomHeight KScreenScale(328)
#define  QRImageArray  @[@"QRShare_btn_wechat",@"share_btn_download"]
#define  QRTitleArray  @[@"微信好友",@"保存图片"]

@interface US_NewQRGraphShareView ()<US_SharePageControlDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) USShareModel      *shareModel;
@property (nonatomic, copy) USShareViewBlock    shareCallBlock;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIScrollView * imageScrollView;
@property (nonatomic, strong) US_SharePageControl * pageControl;

@property (nonatomic, strong) NSMutableArray    *standardImageList;
@end

@implementation US_NewQRGraphShareView

+ (instancetype)showNewQRGraphShareViewWithModel:(USShareModel *)shareModel callBack:(USShareViewBlock)shareCallBack{
    return [[US_NewQRGraphShareView alloc]initWithFrame:CGRectZero withShareModel:shareModel callBack:shareCallBack];
}

- (instancetype)initWithFrame:(CGRect)frame withShareModel:(USShareModel *)shareModel callBack:(USShareViewBlock)shareCallBack{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)]) {
        self.shareModel=shareModel;
        self.shareCallBlock = [shareCallBack copy];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    self.alpha_backgroundView=@"0.7";
    [self sd_addSubviews:@[self.bottomView,self.contentView,self.pageControl]];
    self.bottomView.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(kBottomHeight);
    self.pageControl.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self, kTabBarHeight - 5)
    .widthIs(100).heightIs(30);
    [self setupBottomView];
    [self handleImageList];
    
    self.bottomView.frame = CGRectMake(0, 0, __MainScreen_Width, kBottomHeight);
    _bottomView.layer.mask = [UIView drawCornerRadiusWithRect:_bottomView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(KScreenScale(30), KScreenScale(30))];
}

- (void)handleImageList{
    [UleMBProgressHUD showHUDWithText:@""];
    @weakify(self);
    [[USImageDownloadManager sharedManager] downloadImageList:self.shareModel.listImage2 success:^(NSMutableArray * _Nullable resultArr) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        [self buildQRImageWithImageList:resultArr];
        [self setupContentView];
        [self showViewWithAnimation:AniamtionAlert];
    } fail:^(NSError * _Nullable error) {
        [UleMBProgressHUD hideHUD];
        [UleMBProgressHUD showHUDWithText:@"图片下载失败" afterDelay:1.5];
    }];
}

- (void)buildQRImageWithImageList:(NSArray *)imageList{
    [self.standardImageList removeAllObjects];
    for (UIImage *image in imageList) {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        CGFloat screenScale=[UIScreen mainScreen].scale;
        imageView.frame=CGRectMake(0, 0, 750/screenScale, 1334/screenScale);
        UIView *qrBackgroudView=[[UIView alloc]init];
        qrBackgroudView.backgroundColor=[UIColor whiteColor];
        qrBackgroudView.layer.cornerRadius=5.0;
        qrBackgroudView.layer.borderWidth=0.5;
        qrBackgroudView.layer.borderColor=[UIColor convertHexToRGB:@"f2f2f2"].CGColor;
        UIImageView * qr=[[UIImageView alloc] init];
        [qrBackgroudView addSubview:qr];
        [imageView addSubview:qrBackgroudView];
        qrBackgroudView.sd_layout.centerXEqualToView(imageView)
        .bottomSpaceToView(imageView, 30/screenScale)
        .widthIs(200/screenScale)
        .heightIs(200/screenScale);
        qr.sd_layout.spaceToSuperView(UIEdgeInsetsMake(2, 2, 2, 2));
        qr.image=[UIImage uleQRCodeForString:self.shareModel.shareUrl size:200 fillColor:[UIColor blackColor] iconImage:nil];
        UIImage *standardImage=[UIImage makeImageWithView:imageView];
        [self.standardImageList addObject:standardImage];
    }
}

- (void)setupContentView{
    [self.contentView addSubview:self.imageScrollView];
    self.imageScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    UIView * tempView=self.imageScrollView;
    for (int i=0; i<self.standardImageList.count; i++) {
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setImage:self.standardImageList[i]];
        [self.imageScrollView addSubview:imageView];
        imageView.sd_layout.leftSpaceToView(tempView, 0)
        .topSpaceToView(self.imageScrollView, 0)
        .bottomSpaceToView(self.imageScrollView, 0)
        .widthRatioToView(self.imageScrollView, 1.0);
        tempView=imageView;
    }
    self.imageScrollView.contentSize=CGSizeMake((self.contentView.width_sd)*self.shareModel.listImage2.count, 0);
    self.pageControl.totoalPage=self.shareModel.listImage2.count;
    self.pageControl.currentPage=1;
}

- (void)setupBottomView{
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:btnView];
    btnView.sd_layout.topEqualToView(self.bottomView)
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .heightIs(KScreenScale(218));
    
    CGFloat margin=(self.width_sd - KScreenScale(145)* QRTitleArray.count) / (QRTitleArray.count+1);
    CGFloat width=KScreenScale(145);
    for (int i=0; i<QRTitleArray.count; i++) {
        UleControlView *btn=[[UleControlView alloc]initWithFrame:CGRectMake(margin+(width+margin) *i, KScreenScale(46), width, width)];
        btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        btn.mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(22)];
        btn.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        btn.mTitleLabel.text=QRTitleArray[i];
        btn.mImageView.image=[UIImage bundleImageNamed:QRImageArray[i]];
        [btn addTouchTarget:self action:@selector(btnClick:)];
        btn.tag=1000+i;
        [btnView addSubview:btn];
        btn.mImageView.sd_layout.topSpaceToView(btn, 0)
        .centerXEqualToView(btn)
        .widthIs(KScreenScale(90))
        .heightIs(KScreenScale(90));
        btn.mTitleLabel.sd_layout.bottomSpaceToView(btn, 0)
        .leftSpaceToView(btn, 0)
        .rightSpaceToView(btn, 0)
        .heightIs(KScreenScale(25));
    }
    
    UIView *placeView = [[UIView alloc] init];
    placeView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    [self.bottomView addSubview:placeView];
    placeView.sd_layout.topSpaceToView(btnView, 0)
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .heightIs(KScreenScale(5));
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(28)];
    [cancelBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cancelBtn];
    cancelBtn.sd_layout.topSpaceToView(placeView, 0)
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .heightIs(KScreenScale(100));
}

#pragma mark - <pageControl>
-(void)picSharePageLeftBtnClick:(NSUInteger)currentP{
    CGPoint newPoint=CGPointMake((currentP-1)*CGRectGetWidth(self.imageScrollView.frame), 0);
    [self.imageScrollView setContentOffset:newPoint animated:YES];
}
-(void)picSharePageRightBtnClick:(NSUInteger)currentP{
    CGPoint newPoint=CGPointMake((currentP-1)*CGRectGetWidth(self.imageScrollView.frame), 0);
    [self.imageScrollView setContentOffset:newPoint animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==_imageScrollView) {
        int currentPage=scrollView.contentOffset.x/(NSInteger)scrollView.width_sd;
        self.pageControl.currentPage=currentPage+1;
    }
}

#pragma mark - <Button event>
- (void)closeClick:(UIButton *)sender{
    [self hiddenView];
}

- (void)btnClick:(UIButton *)sender{
    NSInteger index=sender.tag-1000;
    if (index==0) {
        [self wxShare];
    }else if (index==1){
        [self hiddenViewWithCompletion:^{
            [self downloadQRShareImage];
        }];
    }
}

#pragma mark - <事件处理>
//采用系统分享，将图片分享到微信朋友圈
- (void)wxShare{
    UIImage * image = [[UIImage alloc] init];
    NSInteger index=self.pageControl.currentPage-1;
    if (index>=0&&index<self.standardImageList.count) {
        image=[self.standardImageList objectAt:index];
    }
    NSMutableArray *itemsArr = [NSMutableArray array];
    if (image) {
        NSString *path_sandBox = NSHomeDirectory();
        NSString *imagePath = [path_sandBox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX.jpg"]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];
        //取消直接跳微信的分享方式  20170904
        NSURL *shareObj = [NSURL fileURLWithPath:imagePath];
        MultiShareItem *item = [[MultiShareItem alloc] initWithPlaceHolderImg:image andShareFile:shareObj];
        [itemsArr addObject:item];
    }

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsArr applicationActivities:nil];
    activityVC.modalInPopover = true;
    activityVC.restorationIdentifier = @"activity";
    if (kSystemVersion>=9.0) {
        if (@available(iOS 9.0, *)) {
            activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
        } else {
            // Fallback on earlier versions
        }
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    }
    if (activityVC) {
        //监听分享完成
        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if ([activityType isEqualToString:@"com.tencent.xin.sharetimeline"]&&completed) {
                if (self.shareCallBlock) {
                    self.shareCallBlock(SV_Success);
                }
            }
        };
        //弹出分享
        [[UIViewController currentViewController] presentViewController:activityVC animated:YES completion:nil];
        [self hiddenView];
    }
}
//下载带二维码的图片，并保存的本地
- (void)downloadQRShareImage{
    if ([USAuthorizetionHelper photoLibaryAuth]) {
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在保存"];
        
        UIImage * image = [[UIImage alloc] init];
        NSInteger index=self.pageControl.currentPage-1;
        if (index>=0&&index<self.standardImageList.count) {
            image=[self.standardImageList objectAt:index];
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //弹alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@",self.shareModel.listId] moduleid:@"商品分享" moduledesc:@"下载图片" networkdetail:@""];
}

#pragma mark - <图片成功保存回调>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
    if (error) {
        [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:2.0];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"您可到相册查看图片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - <getters>
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[UIView new];
        _bottomView.backgroundColor=[UIColor whiteColor];
    }
    return _bottomView;
}
- (US_SharePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[US_SharePageControl alloc] initWithTotalPages:0];
        _pageControl.delegate=self;
    }
    return _pageControl;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(KScreenScale(120), kStatusBarHeight + KScreenScale(20), KScreenScale(510), KScreenScale(908))];
        _contentView.backgroundColor=[UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = KScreenScale(14);
    }
    return _contentView;
}

- (UIScrollView *)imageScrollView{
    if (!_imageScrollView) {
        _imageScrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _imageScrollView.pagingEnabled=YES;
        _imageScrollView.delegate=self;
    }
    return _imageScrollView;
}

- (NSMutableArray *)standardImageList{
    if (!_standardImageList) {
        _standardImageList=[NSMutableArray array];
    }
    return _standardImageList;
}
@end
