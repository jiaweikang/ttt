//
//  US_GoodsSourceSuspendBarView.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceSuspendBarView.h"
#import <UIView+SDAutoLayout.h>
#import "BBCyclingLabel.h"
#import <NSAttributedString+YYText.h>
#import "USGoodsPreviewManager.h"

@interface US_GoodsSourceSuspendBarView ()
@property (nonatomic, strong) UIImageView   *bgImgView;
//@property (nonatomic, strong) UIImageView   *listImgView;
@property (nonatomic, strong) UILabel       *mRightLab;
@property (nonatomic, strong) UIImageView   *mRightImgView;
@property (nonatomic, strong) BBCyclingLabel *mContentView;
@property (nonatomic, strong)NSTimer        *mTimer;
@property (nonatomic, strong)NSMutableArray *titlesArray;
@property (nonatomic, assign)int    currentIndex;
@property (nonatomic, copy)NSString         *currentListID;
@property (nonatomic, strong)NSMutableDictionary *listImgsDic;
@end

@implementation US_GoodsSourceSuspendBarView
-(void)dealloc{
    [self.mTimer invalidate];
    self.mTimer=nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self sd_addSubviews:@[self.bgImgView, self.mRightImgView, self.mRightLab, /*self.listImgView,*/ self.mContentView]];
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
    [self addGestureRecognizer:tapGes];
}

-(void)setMDataArray:(NSMutableArray<FeaturedModel_HomeScrollBarIndex *> *)mDataArray{
    _mDataArray=[NSMutableArray arrayWithArray:mDataArray];
    [self.listImgsDic removeAllObjects];
    NSMutableArray *titlesArr=[NSMutableArray array];
    for (FeaturedModel_HomeScrollBarIndex *item in mDataArray) {
        [titlesArr addObject:[NSString stringWithFormat:@"%@ ",[NSString isNullToString:item.context]]];
    }
    self.titlesArray=titlesArr;
    self.currentIndex=0;
    [self addMTimer];
}
- (void)tapGesAction{
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString isNullToString:self.currentListID] andSearchKeyword:@"" andPreviewType:@"2" andHudVC:(UleBaseViewController *)[UIViewController currentViewController]];
}
- (void)timerAction{
    FeaturedModel_HomeScrollBarIndex *currentItem=[self.mDataArray objectAt:self.currentIndex];
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
            imageView.layer.cornerRadius=(CGRectGetHeight(self.frame)-2)*0.5;
            imageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)-2, CGRectGetHeight(self.frame)-2);
            [self.listImgsDic setObject:imageView forKey:@(self.currentIndex)];
        }
        NSMutableAttributedString *attachText= [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:[UIFont systemFontOfSize:__MainScreen_Width<=320?9:11] alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
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
    }
}

- (void)stopTimer{
    [self.mTimer setFireDate:[NSDate distantFuture]];
}
- (void)startTimer{
    [self.mTimer setFireDate:[NSDate date]];
}
#pragma mark - <getters>
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"homeScrollBar_bg"]];
        _bgImgView.frame=self.bounds;
    }
    return _bgImgView;
}
//- (UIImageView *)listImgView{
//    if (!_listImgView) {
//        CGFloat height=(CGRectGetHeight(self.frame)-4);
//        _listImgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.mRightLab.frame)-3-height, 2, height, height)];
//        _listImgView.clipsToBounds=YES;
//        _listImgView.layer.cornerRadius=height*0.5;
//    }
//    return _listImgView;
//}
- (UILabel *)mRightLab{
    if (!_mRightLab) {
        _mRightLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.mRightImgView.frame)-48, 0, 45, CGRectGetHeight(self.frame))];
        _mRightLab.text=@"查看详情";
        _mRightLab.textColor=[UIColor whiteColor];
        _mRightLab.font=[UIFont systemFontOfSize:11];
        _mRightLab.textAlignment=NSTextAlignmentRight;
    }
    return _mRightLab;
}
- (UIImageView *)mRightImgView{
    if (!_mRightImgView) {
        _mRightImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"drawLottery_img_arrow_right"]];
        _mRightImgView.frame=CGRectMake(CGRectGetWidth(self.frame)-13, (CGRectGetHeight(self.frame)-8)*0.5, 5, 8);
    }
    return _mRightImgView;
}
- (BBCyclingLabel *)mContentView{
    if (!_mContentView) {
        _mContentView=[[BBCyclingLabel alloc]initWithFrame:CGRectMake(8, 0, CGRectGetMinX(self.mRightLab.frame)-8, CGRectGetHeight(self.frame)) andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        _mContentView.textColor=[UIColor whiteColor];
        _mContentView.numberOfLines=1;
        _mContentView.lineBreakMode=NSLineBreakByTruncatingMiddle;
        _mContentView.font=[UIFont systemFontOfSize:11];
//        _mContentView.adjustsFontSizeToFitWidth=YES;
        _mContentView.clipsToBounds=YES;
    }
    return _mContentView;
}
- (NSMutableDictionary *)listImgsDic{
    if (!_listImgsDic) {
        _listImgsDic=[NSMutableDictionary dictionary];
    }
    return _listImgsDic;
}
@end
