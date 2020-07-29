//
//  US_GoodsSourceScrollBarView.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceScrollBarView.h"
#import "BBCyclingLabel.h"
#import "FeaturedModel_HomeScrollBar.h"
#import <NSAttributedString+YYText.h>
#import <UIView+SDAutoLayout.h>
#import "USGoodsPreviewManager.h"
#import "USLocationManager.h"
#import "UIView+Shade.h"

@implementation US_GoodsSourceScrollBarViewModel

- (instancetype)initWithHomeScrollBar:(NSMutableArray *)barArray{
    if (self=[super init]) {
        self.scrollDataArr=[NSMutableArray arrayWithArray:barArray];
        self.isNewData=YES;
    }
    return self;
}

@end

@interface US_GoodsSourceScrollBarView ()
@property (nonatomic, strong)YYAnimatedImageView    *mBackgroundImgView;
@property (nonatomic, strong)UIImageView    *leftImgView;
@property (nonatomic, strong)UIView         *mBgView;
@property (nonatomic, strong)UIImageView    *locateImgView;
@property (nonatomic, strong)UILabel        *locateLab;
@property (nonatomic, strong)UIView         *lineView;
@property (nonatomic, strong)BBCyclingLabel *mContentView;
@property (nonatomic, strong)UILabel        *mRightLab;
@property (nonatomic, strong)UIImageView    *mRightImgView;

@property (nonatomic, strong)US_GoodsSourceScrollBarViewModel  *mDataModel;
@property (nonatomic, strong)NSTimer        *mTimer;
@property (nonatomic, strong)NSMutableArray *titlesArray;
@property (nonatomic, assign)int    currentIndex;
@property (nonatomic, copy)NSString         *currentListID;
@property (nonatomic, strong)NSMutableDictionary *listImgsDic;

@end

@implementation US_GoodsSourceScrollBarView

-(void)dealloc{
    [self.mTimer invalidate];
    self.mTimer=nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.backgroundColor=[UIColor whiteColor];
    CAGradientLayer *layer=[UIView setGradualSizeChangingColor:self.bounds.size fromColor:[UIColor convertHexToRGB:@"ffffff"] toColor:[UIColor convertHexToRGB:@"f2f2f2"] gradualType:GradualTypeVertical];
    [self.layer addSublayer:layer];
    [self addSubview:self.mBackgroundImgView];
    self.mBackgroundImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.mBgView sd_addSubviews:@[self.locateImgView, self.locateLab, self.lineView, self.mContentView, self.mRightLab, self.mRightImgView]];
    [self sd_addSubviews:@[/*self.leftImgView,*/ self.mBgView]];
//    self.leftImgView.sd_layout.topSpaceToView(self, 2)
//    .leftSpaceToView(self, 6)
//    .widthIs(25)
//    .heightEqualToWidth();
    self.locateImgView.sd_layout.topSpaceToView(self.mBgView, 8)
    .leftSpaceToView(self.mBgView, 10)
    .widthIs(13)
    .heightEqualToWidth();
    self.locateLab.sd_layout.topSpaceToView(self.mBgView, 0)
    .leftSpaceToView(self.locateImgView, 3)
    .bottomSpaceToView(self.mBgView, 0)
    .widthIs(35);
    self.lineView.sd_layout.topSpaceToView(self.mBgView, 6)
    .leftSpaceToView(self.locateLab, 3)
    .widthIs(1)
    .bottomSpaceToView(self.mBgView, 6);
    self.mRightImgView.sd_layout.centerYEqualToView(self.mBgView)
    .rightSpaceToView(self.mBgView, 8)
    .widthIs(5)
    .heightIs(8);
    self.mRightLab.sd_layout.topSpaceToView(self.mBgView, 0)
    .bottomSpaceToView(self.mBgView, 0)
    .rightSpaceToView(self.mRightImgView, 3)
    .widthIs(45);
}

- (void)setModel:(US_GoodsSourceScrollBarViewModel *)model{
    if (_mDataModel==model) {
        return;
    }
    self.mDataModel=model;
    if (model.backgroundUrlStr.length>0) {
        [self.mBackgroundImgView yy_setImageWithURL:[NSURL URLWithString:model.backgroundUrlStr] placeholder:nil];
    }
    [self.listImgsDic removeAllObjects];
    self.locateLab.text=[self getProvinceStr];
    NSMutableArray *titlesArr=[NSMutableArray array];
    for (FeaturedModel_HomeScrollBarIndex *item in model.scrollDataArr) {
        [titlesArr addObject:[NSString stringWithFormat:@"%@ ",[NSString isNullToString:item.context]]];
    }
    self.titlesArray=titlesArr;
    self.currentIndex=0;
    model.isNewData=NO;
    [self addMTimer];
}

- (void)tapGesAction{
    //日志
    [LogStatisticsManager onClickLog:Home_MsgScrol andTev:[NSString isNullToString:self.currentListID]];
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString isNullToString:self.currentListID] andSearchKeyword:@"" andPreviewType:@"2" andHudVC:(UleBaseViewController *)[UIViewController currentViewController]];
}
- (void)timerAction{
    FeaturedModel_HomeScrollBarIndex *currentItem=[self.mDataModel.scrollDataArr objectAt:self.currentIndex];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:[self.titlesArray objectAt:self.currentIndex] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:__MainScreen_Width<=320?9:11]}];
    if ([NSString isNullToString:currentItem.defImgUrl].length>0) {
        NSString *imageUrlStr=[NSString isNullToString:currentItem.defImgUrl];
        if ([imageUrlStr containsString:@"ule.com"]) {
            imageUrlStr=[NSString getImageUrlString:kImageUrlType_L withurl:imageUrlStr];
        }
        YYAnimatedImageView *imageView=[self.listImgsDic objectForKey:@(self.currentIndex)];
        if (!imageView) {
            imageView= [[YYAnimatedImageView alloc] init];
            [imageView yy_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholder:nil];
            imageView.clipsToBounds=YES;
            imageView.layer.cornerRadius=14;
            imageView.frame = CGRectMake(0, 0, 28, 28);
            [self.listImgsDic setObject:imageView forKey:@(self.currentIndex)];
        }
        NSMutableAttributedString *attachText1= [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:__MainScreen_Width<=320?9:11] alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText1];
    }
    [self.mContentView setText:text animated:YES];
    self.currentListID=currentItem.listingId;
    self.currentIndex++;
    if (self.currentIndex>=self.titlesArray.count) {
        self.currentIndex=0;
    }
}
-(void)addMTimer{
    if (!_mTimer) {
        _mTimer=[NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_mTimer forMode:NSRunLoopCommonModes];
        [_mTimer fire];
    }
}
//渐变
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds; // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向为水平方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0); // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0, @1.0];
    return gradientLayer;
}
#pragma mark - <getters>
- (YYAnimatedImageView *)mBackgroundImgView{
    if (!_mBackgroundImgView) {
        _mBackgroundImgView=[YYAnimatedImageView new];
        _mBackgroundImgView.contentMode=UIViewContentModeScaleToFill;
    }
    return _mBackgroundImgView;
}
- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"homeScrollBar_dynamic"]];
    }
    return _leftImgView;
}
- (UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]initWithFrame:CGRectMake(KScreenScale(20), 5, __MainScreen_Width-KScreenScale(40), 30)];
        [_mBgView.layer addSublayer:[self setGradualChangingColor:_mBgView fromColor:[UIColor colorWithRed:255/255.0 green:151/255.0 blue:67/255.0 alpha:1.0] toColor:[UIColor colorWithRed:255/255.0 green:72/255.0 blue:102/255.0 alpha:1.0]]];
        _mBgView.layer.cornerRadius=15;
        _mBgView.layer.masksToBounds=YES;
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
        [_mBgView addGestureRecognizer:tapGes];
    }
    return _mBgView;
}
- (UIImageView *)locateImgView{
    if (!_locateImgView) {
        _locateImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"homeScrollBar_location"]];
    }
    return _locateImgView;
}
- (UILabel *)locateLab{
    if (!_locateLab) {
        _locateLab=[[UILabel alloc]init];
        _locateLab.textColor=[UIColor whiteColor];
        _locateLab.font=[UIFont systemFontOfSize:11];
        _locateLab.textAlignment=NSTextAlignmentCenter;
    }
    return _locateLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor whiteColor];
    }
    return _lineView;
}
- (UIImageView *)mRightImgView{
    if (!_mRightImgView) {
        _mRightImgView=[[UIImageView alloc]init];
        _mRightImgView.image=[UIImage bundleImageNamed:@"drawLottery_img_arrow_right"];
    }
    return _mRightImgView;
}
- (BBCyclingLabel *)mContentView{
    if (!_mContentView) {
        _mContentView=[[BBCyclingLabel alloc]initWithFrame:CGRectMake(70, 0, CGRectGetWidth(self.mBgView.frame)-120-KScreenScale(40), 30) andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        _mContentView.textColor=[UIColor whiteColor];
        _mContentView.font=[UIFont systemFontOfSize:11];
        _mContentView.numberOfLines=1;
//        _mContentView.lineBreakMode=NSLineBreakByTruncatingMiddle;
//        _mContentView.adjustsFontSizeToFitWidth=YES;
        _mContentView.clipsToBounds=YES;
    }
    return _mContentView;
}
- (UILabel *)mRightLab{
    if (!_mRightLab) {
        _mRightLab=[[UILabel alloc]init];
        _mRightLab.text=@"查看详情";
        _mRightLab.textColor=[UIColor whiteColor];
        _mRightLab.font=[UIFont systemFontOfSize:11];
        _mRightLab.textAlignment=NSTextAlignmentRight;
    }
    return _mRightLab;
}
- (NSMutableDictionary *)listImgsDic{
    if (!_listImgsDic) {
        _listImgsDic=[NSMutableDictionary dictionary];
    }
    return _listImgsDic;
}
//展示用
- (NSString *)getProvinceStr
{
    NSString *provinceStr = @"全国";
    if ([US_UserUtility sharedLogin].enterpriseFlag && [NSString isNullToString:[US_UserUtility sharedLogin].m_provinceName].length > 0) {
        provinceStr = [US_UserUtility sharedLogin].m_provinceName;
    } else if ([USLocationManager sharedLocation].lastProvince.length > 0) {
        provinceStr = [USLocationManager sharedLocation].lastProvince;
    }
    if (provinceStr.length > 0) {
        if (provinceStr.length >= 2) {
            provinceStr = [provinceStr substringToIndex:2];
        }
    }
    if ([provinceStr isEqualToString:@"黑龙"]) {
        provinceStr = @"黑龙江";
    }
    if ([provinceStr isEqualToString:@"内蒙"]) {
        provinceStr = @"内蒙古";
    }
    return provinceStr;
}


@end
