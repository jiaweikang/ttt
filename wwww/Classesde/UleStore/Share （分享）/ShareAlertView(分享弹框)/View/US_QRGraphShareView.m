//
//  US_QRGraphShareView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/12.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_QRGraphShareView.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"
#import <UIView+ShowAnimation.h>
#import "UIImage+USAddition.h"
#import "USAuthorizetionHelper.h"
#import <UIImage+Extension.h>
#import <UleShareSDK/Ule_ShareView.h>
#import "UILabel+DeleteLine.h"
#import "WBPopOverView.h"
#import "UserDefaultManager.h"
#import "US_SharePageControl.h"
#import "UIView+Shade.h"

#define kWidth (__MainScreen_Width- KScreenScale(240))
#define kBottomHeight KScreenScale(328)
#define  QRImageArray  @[@"QRShare_btn_wechat",@"share_btn_download",@"share_btn_exchange"]
#define  QRTitleArray  @[@"微信好友",@"保存图片",@"更换主题"]

@interface US_QRGraphShareView ()<US_SharePageControlDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) USGraphShareViewType layoutType;
@property (nonatomic, strong) USShareModel * shareModel;
@property (nonatomic, strong) ShareTemplateList * templateModel;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIScrollView * imageScrollView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * describLabel;
@property (nonatomic, strong) NSString * saveImageUrl;
@property (nonatomic, strong) UIImageView * userImageView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * qrImageView;
@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIImageView * middleImageView;
@property (nonatomic, strong) UIView * userBackgroudView;
@property (nonatomic, strong) UIView * qrBackgroudView;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) UILabel * salePriceLabel;
@property (nonatomic, strong) UILabel * olderPriceLabel;
@property (nonatomic, strong) USShareViewBlock shareCallBack;
@property (nonatomic, strong) dispatch_group_t downloadGroup;
@property (nonatomic, strong) UIImageView * downloadImageView;
@property (nonatomic, strong) QRGraphFinishBlock saveQRFinishBlock;
@property (nonatomic, strong) US_SharePageControl * pageControl;
@end

@implementation US_QRGraphShareView

+ (instancetype)getQRGraphShareViewWithModel:(USShareModel *)shareModel withTemplate:(ShareTemplateList *)templateModel{
    US_QRGraphShareView * shareView=[[US_QRGraphShareView alloc] initWithFrame:CGRectZero withTemplateModel:templateModel];
    shareView.shareModel=shareModel;
    return shareView;
}

+ (void)showQRGraphShareViewWithModel:(USShareModel *)shareModel withTemplate:(ShareTemplateList *)templateModel callBack:(USShareViewBlock) shareCallBack{
    US_QRGraphShareView * shareView=[[US_QRGraphShareView alloc] initWithFrame:CGRectZero withTemplateModel:templateModel];
    shareView.shareModel=shareModel;
    shareView.shareCallBack=[shareCallBack copy];
    [shareView showViewWithAnimation:AniamtionAlert];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareView setupGuidePopView];
    });
}


- (instancetype)initWithFrame:(CGRect)frame withTemplateModel:(ShareTemplateList*)templateModel{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    if (self) {
        self.templateModel=templateModel;
        self.layoutType=[self.templateModel.modelNo isEqualToString:@"1"]?USGraphShareViewTypeOne:USGraphShareViewTypeTwo;
        [self setupUI];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"__%s__",__FUNCTION__);
}

- (void)setupUI{
    self.backgroundColor=[UIColor clearColor];
    self.alpha_backgroundView=@"0.7";
    [self sd_addSubviews:@[self.bottomView,self.contentView,self.pageControl]];
    self.bottomView.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(kBottomHeight);
//    self.contentView.sd_layout.leftSpaceToView(self, KScreenScale(120))
//    .rightSpaceToView(self, KScreenScale(120))
//    .bottomSpaceToView(self.bottomView, KScreenScale(38))
//    .heightIs(KScreenScale(908));
    self.pageControl.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self, kTabBarHeight - 5)
    .widthIs(100).heightIs(30);
    [self setupBottomView];
    [self setupContentView];
    
    self.bottomView.frame = CGRectMake(0, 0, __MainScreen_Width, kBottomHeight);
    _bottomView.layer.mask = [UIView drawCornerRadiusWithRect:_bottomView.bounds corners:UIRectCornerTopLeft | UIRectCornerTopRight size:CGSizeMake(KScreenScale(30), KScreenScale(30))];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
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
        btn.tag=i;
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

- (void)setupContentView{
    [self.contentView sd_addSubviews:@[self.imageScrollView,self.backImageView,self.titleLabel,self.describLabel,self.iconImageView,self.salePriceLabel,self.olderPriceLabel,self.userImageView,self.noteLabel,self.qrBackgroudView,self.middleImageView]];
    self.imageScrollView.sd_layout.leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0)
    .heightEqualToWidth();
    [self updateContentLayoutForType:self.layoutType];
}

- (void)setupGuidePopView{
    if ([UserDefaultManager getLocalDataBoolen:@"isHadShowGuidePopView"]) {
        return;
    }
    [UserDefaultManager setLocalDataBoolen:YES key:@"isHadShowGuidePopView"];
    UleControlView * btn=[self.bottomView viewWithTag:2];
    NSString *str1=@"新功能";
    NSString *str2=@"二维码分享可更换主题样式啦！";
    NSString *str3=@"点击更换新主题";
    CGFloat shareViewW=CGRectGetWidth(self.frame);
    CGPoint point=CGPointMake(btn.frame.origin.x+btn.frame.size.width/2, btn.frame.origin.y);//箭头点的位置
    CGPoint a = [btn.superview convertPoint:point toView:self];
    CGFloat lab2W=[NSString getSizeOfString:str2 withFont:[UIFont systemFontOfSize:14] andMaxWidth:__MainScreen_Width].width;
    CGFloat popViewW=lab2W+20>shareViewW?shareViewW:lab2W+20;
    WBPopOverView *_popView=[[WBPopOverView alloc]initWithOrigin:a Width:popViewW Height:75 Direction:WBArrowDirectionDown3];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
//    if (__MainScreen_Height<=568) {
//        _popView=[[WBPopOverView alloc]initWithOrigin:a Width:popViewW Height:75 Direction:WBArrowDirectionDown3];
//    }
    _popView.needCenter = NO;
    _popView.backView.layer.cornerRadius=10.0;
    _popView.backView.backgroundColor=[UIColor convertHexToRGB:@"1389f7"];
    _popView.backView.alpha=0.95;
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, popViewW-20, 20)];
    lab1.text=str1;
    lab1.textColor=[UIColor whiteColor];
    lab1.font=[UIFont systemFontOfSize:16];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, popViewW-20, 20)];
    lab2.text=str2;
    lab2.textColor=[UIColor whiteColor];
    lab2.font=[UIFont systemFontOfSize:14];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"share_pic_finger"]];
    imgView.frame=CGRectMake(CGRectGetWidth(_popView.backView.frame)-15, 57, 10, 12);
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, popViewW-30, 15)];
    lab3.text=str3;
    lab3.textColor=[UIColor whiteColor];
    lab3.textAlignment=NSTextAlignmentRight;
    lab3.font=[UIFont systemFontOfSize:12];
    [_popView.backView addSubview:lab1];
    [_popView.backView addSubview:lab2];
    [_popView.backView addSubview:imgView];
    [_popView.backView addSubview:lab3];
    [_popView popViewAtSuperView:self];
}

#pragma mark - <布局>
- (void) updateContentLayoutForType:(USGraphShareViewType) type{
    if (type == USGraphShareViewTypeOne) {
        self.iconImageView.sd_layout.centerXEqualToView(self.contentView)
        .topSpaceToView(self.imageScrollView, -KScreenScale(120)/2.0).widthIs(KScreenScale(120)).heightIs(KScreenScale(120));
        self.describLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(30))
        .topSpaceToView(self.iconImageView, KScreenScale(30))
        .rightSpaceToView(self.contentView, KScreenScale(30))
        .heightIs(KScreenScale(70));
        
        self.salePriceLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(30))
        .topSpaceToView(self.describLabel, KScreenScale(30)).heightIs(KScreenScale(50))
        .autoWidthRatio(1);
        
        self.olderPriceLabel.sd_layout.leftEqualToView(self.salePriceLabel)
        .topSpaceToView(self.salePriceLabel, KScreenScale(8)).heightIs(KScreenScale(30))
        .autoWidthRatio(1);
        
        self.userImageView.sd_layout.leftEqualToView(self.describLabel)
        .bottomSpaceToView(self.contentView, KScreenScale(10))
        .widthIs(KScreenScale(110)).heightEqualToWidth();
        
        self.qrBackgroudView.sd_layout.rightSpaceToView(self.contentView, KScreenScale(10))
        .bottomEqualToView(self.userImageView)
        .widthIs(KScreenScale(110)).heightEqualToWidth();
        
        self.titleLabel.sd_layout.leftSpaceToView(self.userImageView, KScreenScale(20))
        .rightSpaceToView(self.qrBackgroudView, KScreenScale(20))
        .topSpaceToView(self.userImageView, KScreenScale(20)-self.userImageView.height_sd)
        .heightIs(KScreenScale(30));
        
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        
        self.noteLabel.sd_layout.leftEqualToView(self.titleLabel)
        .topSpaceToView(self.titleLabel, 5).rightSpaceToView(self.qrBackgroudView, KScreenScale(20))
        .heightIs(KScreenScale(30));
        self.userImageView.hidden=NO;
    }else{
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(30))
        .topSpaceToView(self.imageScrollView, KScreenScale(30))
        .rightSpaceToView(self.contentView, KScreenScale(30)).heightIs(KScreenScale(30));
        
        self.describLabel.sd_layout.topSpaceToView(self.titleLabel, KScreenScale(20))
        .leftEqualToView(self.titleLabel).rightEqualToView(self.titleLabel)
        .heightIs(KScreenScale(70));
        
        self.salePriceLabel.sd_layout.leftEqualToView(self.titleLabel)
        .topSpaceToView(self.describLabel, KScreenScale(10)).heightIs(KScreenScale(50))
        .autoWidthRatio(1);
        
        self.olderPriceLabel.sd_layout.leftSpaceToView(self.salePriceLabel, KScreenScale(30))
        .centerYEqualToView(self.salePriceLabel).heightIs(KScreenScale(30))
        .autoWidthRatio(1);
        if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0) {
            
            [self.contentView addSubview:self.userBackgroudView];
            [self.contentView bringSubviewToFront:self.userImageView];
            self.userImageView.layer.cornerRadius = KScreenScale(20);
            self.noteLabel.font = [UIFont systemFontOfSize:KScreenScale(18)];
            self.noteLabel.textColor = [UIColor blackColor];
            self.userBackgroudView.sd_layout.bottomSpaceToView(self.contentView, KScreenScale(51))
            .leftSpaceToView(self.contentView, KScreenScale(159))
            .widthIs(KScreenScale(87)).heightEqualToWidth();
            
            self.userImageView.sd_layout.bottomSpaceToView(self.contentView, KScreenScale(55))
            .leftSpaceToView(self.contentView, KScreenScale(163))
            .widthIs(KScreenScale(78.5)).heightEqualToWidth();
            
            self.noteLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(20))
            .rightSpaceToView(self.contentView, KScreenScale(20))
            .bottomSpaceToView(self.contentView, KScreenScale(168))
            .heightIs(KScreenScale(30));
            
            self.qrBackgroudView.sd_layout.rightSpaceToView(self.contentView, KScreenScale(162))
            .bottomSpaceToView(self.contentView, KScreenScale(52))
            .widthIs(KScreenScale(87)).heightEqualToWidth();
            
            self.backImageView.sd_layout.leftSpaceToView(self.contentView, 0)
            .bottomSpaceToView(self.contentView, 0)
            .rightSpaceToView(self.contentView, 0).heightIs(kWidth*0.474);

            self.describLabel.sd_layout.topSpaceToView(self.titleLabel, KScreenScale(10))
            .leftEqualToView(self.titleLabel).rightEqualToView(self.titleLabel)
            .heightIs(KScreenScale(60));
            
            self.salePriceLabel.sd_layout.leftEqualToView(self.titleLabel)
            .topSpaceToView(self.describLabel, 0).heightIs(KScreenScale(30))
            .autoWidthRatio(1);
            
            self.olderPriceLabel.sd_layout.leftSpaceToView(self.salePriceLabel, KScreenScale(30))
            .centerYEqualToView(self.salePriceLabel).heightIs(KScreenScale(30))
            .autoWidthRatio(1);
            
        }else{
            self.userImageView.sd_layout.leftEqualToView(self.describLabel)
            .bottomSpaceToView(self.contentView, KScreenScale(30))
            .widthIs(KScreenScale(110)).heightEqualToWidth();
            
           
           _userImageView.layer.cornerRadius=KScreenScale(110)/2.0;
            self.qrBackgroudView.sd_layout.rightSpaceToView(self.contentView, KScreenScale(30))
            .bottomEqualToView(self.userImageView)
            .widthIs(KScreenScale(110)).heightEqualToWidth();
            
            self.noteLabel.sd_layout.leftSpaceToView(self.userImageView, KScreenScale(14))
            .centerYEqualToView(self.userImageView).rightSpaceToView(self.qrBackgroudView, KScreenScale(14))
            .heightIs(KScreenScale(30));
        }
        self.iconImageView.hidden=YES;
    }
}
-(void)setAttrinbutedLabel:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(25)] range:NSMakeRange(0, 1)];
    label.attributedText = attributedStr;
}
#pragma mark - <显示数据>
- (void) setShareModel:(USShareModel *)shareModel{
    _shareModel=shareModel;
    float salePrice = _shareModel.sharePrice.floatValue;
    float marketPrice = _shareModel.marketPrice.floatValue;
    self.describLabel.text=_shareModel.shareContent;
    self.salePriceLabel.text=[NSString stringWithFormat:@"￥%.2f",salePrice];
    [self setAttrinbutedLabel:self.salePriceLabel];
    [self.salePriceLabel setSingleLineAutoResizeWithMaxWidth:200];
    self.olderPriceLabel.text=marketPrice<=0||marketPrice==salePrice?@"":[NSString stringWithFormat:@"￥%.2f",marketPrice];
    [self.olderPriceLabel addDeleteLine];
    [self.olderPriceLabel setSingleLineAutoResizeWithMaxWidth:200];
    NSString *storeNameStr=@"";
    if ([US_UserUtility sharedLogin].m_stationName && ![[US_UserUtility sharedLogin].m_stationName isEqualToString:@""]) {
        storeNameStr = [US_UserUtility sharedLogin].m_stationName;
    } else {
        storeNameStr = [NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
    }
    [self.userImageView yy_setImageWithURL:[NSURL URLWithString:[US_UserUtility sharedLogin].m_userHeadImgUrl] placeholder:[UIImage bundleImageNamed:@"my_img_header_default"]];
    self.titleLabel.text=storeNameStr;
    self.noteLabel.text=@"长按识别图中二维码";
    self.qrImageView.image=[UIImage uleQRCodeForString:self.shareModel.shareUrl size:200 fillColor:[UIColor blackColor] iconImage:nil];
    
    if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0) {
        [self.backImageView yy_setImageWithURL:[NSURL URLWithString:self.templateModel.shareImagelFirst] placeholder:nil];
    }
    
    UIView * tempView=self.imageScrollView;
    for (int i=0; i<self.shareModel.listImage.count; i++) {
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView yy_setImageWithURL:[NSURL URLWithString:self.shareModel.listImage[i]] placeholder:nil];
        [self.imageScrollView addSubview:imageView];
        imageView.sd_layout.leftSpaceToView(tempView, 0).topSpaceToView(self.imageScrollView, 0).bottomSpaceToView(self.imageScrollView, 0).widthEqualToHeight();
        tempView=imageView;
    }
    self.imageScrollView.contentSize=CGSizeMake((self.contentView.width_sd)*self.shareModel.listImage.count, 0);
    self.pageControl.totoalPage=self.shareModel.listImage.count;
    self.pageControl.currentPage=1;
    
    //中间横幅
    if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0 && [NSString isNullToString:self.shareModel.imageBanner].length > 0) {
        [self.middleImageView yy_setImageWithURL:[NSURL URLWithString:self.shareModel.imageBanner] placeholder:nil]; self.middleImageView.sd_layout.topSpaceToView(self.imageScrollView, 0)
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(KScreenScale(54));
        
        self.titleLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(30))
        .bottomSpaceToView(self.contentView, KScreenScale(306))
        .rightSpaceToView(self.contentView, KScreenScale(30)).heightIs(KScreenScale(30));
    }
}

- (void)transformContentViewToImageAndSaveToLocal:(QRGraphFinishBlock)saveFinish{
    self.saveQRFinishBlock = [saveFinish copy];
    self.downloadImageView=[UIImageView new];
    NSString * urlStr=@"";
    if (self.shareModel.listImage.count>0) {
        urlStr= self.shareModel.listImage[0];
    }
    _downloadGroup = dispatch_group_create();
      @weakify(self);
    dispatch_group_enter(self.downloadGroup);
    [self.downloadImageView yy_setImageWithURL:[NSURL URLWithString:urlStr] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
         @strongify(self);
        dispatch_group_leave(self.downloadGroup);
    }];
    if (self.templateModel&&self.templateModel.shareImagelFirst.length>0) {
        dispatch_group_enter(self.downloadGroup);
        [self.backImageView yy_setImageWithURL:[NSURL URLWithString:self.templateModel.shareImagelFirst] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            dispatch_group_leave(self.downloadGroup);
        }];
    }
    dispatch_group_notify(self.downloadGroup, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self setShareModel:self.shareModel];
        [self.contentView setNeedsDisplay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImage * image=[UIImage makeImageWithView:self.contentView];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    });

    
}

#pragma mark - <Button event>
- (void)closeClick:(UIButton *)sender{
    [self hiddenView];
}

- (void)btnClick:(UIButton *)sender{
    NSString * title= QRTitleArray[sender.tag];
    if ([title isEqualToString:@"微信好友"]) {
        [self wxShare];
    }else if ([title isEqualToString:@"保存图片"]){
        [self hiddenViewWithCompletion:^{
            [self downloadQRShareImage];
        }];
    }else if([title isEqualToString:@"更换主题"]){
        [self jumpToTemplateViewController];
    }
}
#pragma mark - <事件处理>
//采用系统分享，将图片分享到微信朋友圈
- (void)wxShare{
    UIImage * image = [[UIImage alloc] init];
    if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0) {
        self.contentView.frame = CGRectMake(0, 0, 375, 667);
        image = [self saveImage];
    } else {
        image=[UIImage makeImageWithView:self.contentView];
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
                if (self.shareCallBack) {
                    self.shareCallBack(SV_Success);
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
        if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0) {
            self.contentView.frame = CGRectMake(0, 0, 375, 667);
            image = [self saveImage];
        } else {
            image=[UIImage makeImageWithView:self.contentView];
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //弹alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@",self.shareModel.listId] moduleid:@"商品分享" moduledesc:@"下载图片" networkdetail:@""];
}

//生成下载的图片
- (UIImage *)saveImage
{
    self.contentView.layer.masksToBounds = NO;
    UIView *saveImageView = self.contentView;
    
    saveImageView.sd_layout.rightSpaceToView(self, 20)
    .bottomSpaceToView(self, 20)
    .widthIs(375)
    .heightIs(667);
        
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.describLabel.font = [UIFont systemFontOfSize:15];
    self.salePriceLabel.font = [UIFont systemFontOfSize:16];
    self.olderPriceLabel.font = [UIFont systemFontOfSize:14];
    self.noteLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    [topImgView yy_setImageWithURL:[NSURL URLWithString:self.saveImageUrl] placeholder:nil];
    [saveImageView addSubview:topImgView];

    topImgView.sd_layout.topSpaceToView(saveImageView, 0)
    .leftEqualToView(saveImageView)
    .rightEqualToView(saveImageView)
    .heightEqualToWidth();
    
    self.titleLabel.sd_layout.topSpaceToView(self.imageScrollView, 20)
    .leftSpaceToView(self.imageScrollView, 20)
    .widthIs(325)
    .heightIs(16);
    
    self.describLabel.sd_layout.topSpaceToView(self.titleLabel, 10)
    .leftEqualToView(self.titleLabel)
    .widthIs(325)
    .heightIs(40);
    
    self.salePriceLabel.sd_layout.topSpaceToView(self.describLabel, 5)
    .leftEqualToView(self.describLabel)
    .widthIs(325)
    .heightIs(20);
    
    self.noteLabel.sd_layout.bottomSpaceToView(saveImageView, 124)
    .leftEqualToView(saveImageView)
    .rightEqualToView(saveImageView)
    .heightIs(20);
    
    self.backImageView.sd_layout.bottomEqualToView(saveImageView)
    .widthIs(375)
    .heightIs(179);
    
    self.userBackgroudView.sd_layout.leftSpaceToView(saveImageView, 100)
    .bottomSpaceToView(saveImageView, 42)
    .widthIs(80)
    .heightEqualToWidth();
    
    self.userImageView.sd_layout.leftSpaceToView(saveImageView, 102.5)
    .bottomSpaceToView(saveImageView, 44.5)
    .widthIs(75)
    .heightEqualToWidth();
    
    self.qrBackgroudView.sd_layout.bottomSpaceToView(saveImageView, 42)
    .rightSpaceToView(saveImageView, 102.5)
    .widthIs(80)
    .heightEqualToWidth();
    
    //中间横幅
    if (self.templateModel.shareImagelFirst&&self.templateModel.shareImagelFirst.length>0 && [NSString isNullToString:self.shareModel.imageBanner].length > 0) {
        [self.middleImageView yy_setImageWithURL:[NSURL URLWithString:self.shareModel.imageBanner] placeholder:nil]; self.middleImageView.sd_layout.topSpaceToView(self.imageScrollView, 0)
        .leftEqualToView(saveImageView)
        .rightEqualToView(saveImageView)
        .heightIs(40);
        
        self.titleLabel.sd_layout.bottomSpaceToView(saveImageView, 226)
        .leftSpaceToView(saveImageView, 20)
        .widthIs(325)
        .heightIs(16);
    }
    
    return [UIImage makeImageWithView:saveImageView];
}

- (void)jumpToTemplateViewController{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
    [dic setObject:self.shareModel forKey:@"shareModel"];
    if (self.shareCallBack) {
        [dic setObject:self.shareCallBack forKey:@"callBackBlock"];
    }
    [[UIViewController currentViewController] pushNewViewController:@"US_QRShareTemplateVC" isNibPage:NO withData:dic];
    [self hiddenView];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"商品分享" moduledesc:@"更换主题" networkdetail:@""];
}

#pragma mark - <图片成功保存回调>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (self.saveQRFinishBlock) {
        self.saveQRFinishBlock();
        return;
    }
    [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
    if (error) {
        [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:2.0];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"您可到相册查看图片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
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
        self.saveImageUrl = self.shareModel.listImage[currentPage];
    }
}

#pragma mark - <setter and getter>
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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
    }
    return _titleLabel;
}
- (UILabel *)describLabel{
    if (!_describLabel) {
        _describLabel=[UILabel new];
        _describLabel.textColor=[UIColor convertHexToRGB:@"5d5d5d"];
        _describLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _describLabel.numberOfLines=0;
    }
    return _describLabel;
}
- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel=[UILabel new];
        _noteLabel.font=[UIFont systemFontOfSize:KScreenScale(18)];
        _noteLabel.textColor=[UIColor convertHexToRGB:@"909090"];
        _noteLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _noteLabel;
}

- (UILabel *)salePriceLabel{
    if (!_salePriceLabel) {
        _salePriceLabel=[UILabel new];
        _salePriceLabel.textColor=[UIColor convertHexToRGB:@"ef3c39"];
        _salePriceLabel.font=[UIFont systemFontOfSize:KScreenScale(40)];
        _salePriceLabel.isAttributedContent=YES;
    }
    return _salePriceLabel;
}

- (UILabel *)olderPriceLabel{
    if (!_olderPriceLabel) {
        _olderPriceLabel=[UILabel new];
        _olderPriceLabel.textColor=[UIColor convertHexToRGB:@"bcbcbc"];
        _olderPriceLabel.font=[UIFont systemFontOfSize:KScreenScale(28)];
        _olderPriceLabel.isAttributedContent=YES;
    }
    return _olderPriceLabel;
}
- (UIImageView *) iconImageView{
    if (!_iconImageView) {
        _iconImageView=[UIImageView new];
        _iconImageView.image=[UIImage imageNamed:@"US_icon"];
    }
    return _iconImageView;
}
- (UIView *)qrBackgroudView{
    if (!_qrBackgroudView) {
        _qrBackgroudView=[UIView new];
        _qrBackgroudView.backgroundColor=[UIColor whiteColor];
        _qrBackgroudView.layer.cornerRadius=5.0;
        _qrBackgroudView.layer.borderWidth=0.5;
        _qrBackgroudView.layer.borderColor=[UIColor convertHexToRGB:@"f2f2f2"].CGColor;
        UIImageView * qr=[[UIImageView alloc] init];
        [_qrBackgroudView addSubview:qr];
        qr.sd_layout.spaceToSuperView(UIEdgeInsetsMake(KScreenScale(10), KScreenScale(10), KScreenScale(10), KScreenScale(10)));
        self.qrImageView=qr;
    }
    return _qrBackgroudView;
}
- (UIView *)userBackgroudView{
    if (!_userBackgroudView) {
        _userBackgroudView=[UIView new];
        _userBackgroudView.backgroundColor=[UIColor whiteColor];
        _userBackgroudView.layer.cornerRadius=KScreenScale(20);
        _userBackgroudView.layer.borderWidth=0.5;
        _userBackgroudView.layer.borderColor=[UIColor convertHexToRGB:@"f2f2f2"].CGColor;
    }
    return _userBackgroudView;
}
- (UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView=[UIImageView new];
        _userImageView.backgroundColor=[UIColor redColor];
        _userImageView.layer.cornerRadius=KScreenScale(110)/2.0;
        _userImageView.clipsToBounds=YES;
    }
    return _userImageView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView=[UIImageView new];
    }
    return _backImageView;
}

- (UIImageView *)middleImageView
{
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
    }
    return _middleImageView;
}
@end
