//
//  USGuideViewController.m
//  UleStoreApp
//
//  Created by xulei on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USGuideViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "USApplicationLaunchApi.h"
#import "DeviceInfoHelper.h"
#import <SMPageControl.h>
#import "FeaturedModel_GuidePage.h"
#import "UleModulesDataToAction.h"
#import <FileController.h>
#import "USImageDownloadManager.h"
#import "US_NetworkExcuteManager.h"
#import "USGuideViewLocalModel.h"
#import "NSDate+USAddtion.h"
#import "UleGetTimeTool.h"

#import "UM_LaunchAdCache.h"
#import "UM_ADDownloadManager.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

static CGFloat UleGuideViewPageControlHeight = 18.0;
static NSString *const KEY_LocalGuideModel = @"USLocalGuideModel";

@interface USGuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UleNetworkExcute  *networkClient_UstaticCDN;
@property (nonatomic, strong) UIImageView       *mLaunchCoverView;
@property (nonatomic, strong) UIScrollView      *mScrollView;
@property (nonatomic, strong) SMPageControl     *mPageControl;
@property (nonatomic, strong) UIButton          *skipBtn;
@property (nonatomic, strong) dispatch_source_t  gcdTimer;
@property (nonatomic, strong) NSTimer           *guideShowTimer;
@property (nonatomic, assign) NSInteger         guideShowTimerCount;
@property (nonatomic, strong) NSMutableArray    *mSourceArr;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *playerControlView;

@end

@implementation USGuideViewController

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer=nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.fd_prefersNavigationBarHidden=YES;
    //用launch图覆盖
    [self.view addSubview:self.mLaunchCoverView];
    //开始2秒倒计时
    [self startDefaultTimer];
    [self startRequestAdvertise];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeDefaultTimer];
    [self closeGuideShowTimer];
}

#pragma mark - <定时器>
- (void)startDefaultTimer{
    __block int timeout = 2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    @weakify(self);
    dispatch_source_set_timer(_gcdTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        @strongify(self);
        if (timeout<=0) {
            [self closeDefaultTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissAlphaAnimation];
            });
        }else {
            timeout--;
        }
    });
    dispatch_resume(_gcdTimer);
}

- (void)closeDefaultTimer
{
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer=nil;
    }
}

- (void)startGuideShowTimer:(NSInteger)timeOut
{
    self.guideShowTimerCount = timeOut;
    self.guideShowTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(guideShowTimerAction) userInfo:nil repeats:YES];
}

- (void)guideShowTimerAction
{
    self.guideShowTimerCount--;
    if (self.guideShowTimerCount<=0) {
        self.guideShowTimerCount=0;
        [self closeGuideShowTimer];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@%@s",@"跳过",@(self.guideShowTimerCount)] forState:UIControlStateNormal];
    });
}

- (void)closeGuideShowTimer
{
    if (self.guideShowTimer.isValid) {
        [self.guideShowTimer invalidate];
        self.guideShowTimer=nil;
    }
}

#pragma mark -  <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // bounces可以实现滑动消失效果
    if (scrollView.contentOffset.x <= __MainScreen_Width - 1) {
        [scrollView setBounces:NO];
    }
    else {
        [scrollView setBounces:YES];
    }
    // 到最后一帧 自动到下一页
    if (scrollView.contentOffset.x > (self.mPageControl.numberOfPages-1) * __MainScreen_Width + 10) {
        
        scrollView.scrollEnabled = NO;
        
        [self dismissTranslationAnimation];
    }
    // 设置PageControl小白点
    CGRect visibleBounds = self.view.bounds;
    NSInteger pageIndex = floorf(scrollView.contentOffset.x / CGRectGetWidth(visibleBounds));
    self.mPageControl.currentPage = pageIndex;
}

#pragma mark - <ACTION>
//点击某一帧
- (void)touchBtnAction
{
    // 取消自动消失
    if (self.mSourceArr.count == 1) {
        [self closeGuideShowTimer];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlphaAnimation) object:nil];
    }
    
    [UIView animateWithDuration:0.7 animations:^{
        
        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self dismissGuideViewController:YES];
        }
    }];
}

//跳过
- (void)skipBtnAction
{
    // 取消自动消失
    if (self.mSourceArr.count == 1) {
        [self closeGuideShowTimer];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlphaAnimation) object:nil];
    }
    [self dismissAlphaAnimation];
}

/** 渐变消失动画 */
- (void)dismissAlphaAnimation {
    [UIView animateWithDuration:0.7 animations:^{
        
        self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
//        if (finished) {
            [self dismissGuideViewController:NO];
//        }
    }];
}

- (void)dismissGuideViewController:(BOOL)didTouch
{
    /**1. 广告点击,先处理广告iOS action */
    UleUCiOSAction *tModuleAction = nil;
    if (didTouch && self.mSourceArr.count != 0) {
        FeaturedModel_GuidePageIndex *itemModel = self.mSourceArr[self.mPageControl.currentPage];
        tModuleAction = [UleModulesDataToAction resolveModulesActionStr:itemModel.ios_action];
        //日志记录
        [LogStatisticsManager onClickLog:GuidePage andTev:NonEmpty(itemModel.log_title)];
    }
    if (_mDismissComplete) {
        _mDismissComplete(tModuleAction);
    }
}

/** 平移消失动画 */
- (void)dismissTranslationAnimation {
    
    // 取消自动消失
    if (self.mSourceArr.count == 1) {
        [self closeGuideShowTimer];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlphaAnimation) object:nil];
    }
    
    [UIView animateWithDuration:0.7 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.x = -frame.size.width;
        self.view.frame = frame;
        self.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self dismissGuideViewController:NO];
        }
    }];
}

/** 解析item获取最终的 imageURL string */
- (NSString *)parseModelImageURL:(FeaturedModel_GuidePageIndex *)tempItem {
    /** 图片信息 */
    NSArray *images = [NSArray arrayWithObjects:tempItem.image0,tempItem.image1,tempItem.image2,tempItem.image3,tempItem.image4,tempItem.image5,tempItem.image6,tempItem.image7,tempItem.image8,tempItem.image9, nil];
    /** 尺寸信息 */
    NSArray *resolutions = [tempItem.resolution componentsSeparatedByString:@"&"];
    /** 匹配 */
    CGSize tSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale, [[UIScreen mainScreen] bounds].size.height * [UIScreen mainScreen].scale);
    NSString *tString = [NSString stringWithFormat:@"%.0fx%.0f",tSize.width,tSize.height];
    NSInteger tIndex ;
    if ([resolutions containsObject:tString]) {
        tIndex= [resolutions indexOfObject:tString];
    }else{
        tIndex=images.count-1;
    }
    if (tIndex>=images.count) {
        tIndex=images.count-1;
    }
    
    /** 结果 */
    NSString *resultString = [self optimizeImageURL:[images objectAt:tIndex] withPercent:@"30"];
    
    return resultString;
}

/** 根据网络状态优化image 分辨率 */
- (NSString *)optimizeImageURL:(NSString*)imgUrl withPercent:(NSString *)percent {
    
    NSString *tImageURL = nil;
    // Wi-Fi 不用优化
    if ([UleReachability sharedManager].mReachabilityStatus == UleReachabilityStatusViaWiFi) {
        
        tImageURL = imgUrl;
    }
    // 其他网络状态优化
    else {
        if ([imgUrl hasPrefix:@"https://"]) {
            
            NSString *str = [[[imgUrl substringFromIndex:8]componentsSeparatedByString:@"/"]firstObject];
            NSString *replaceStr = [NSString stringWithFormat:@"%@/m/%@",str,percent];
            tImageURL = [imgUrl stringByReplacingOccurrencesOfString:str withString:replaceStr];
        }
        else {
            tImageURL = imgUrl;
        }
    }
    return tImageURL;
}

- (void)removeMLaunchCoverView
{
    if (_mLaunchCoverView) {
        [self.mLaunchCoverView removeFromSuperview];
        self.mLaunchCoverView=nil;
    }
}

#pragma mark - <网络请求>
- (void)startRequestAdvertise
{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[USApplicationLaunchApi buildRequestAdvertise] success:^(id responseObject) {
        @strongify(self);
        
        FeaturedModel_GuidePage *model = [FeaturedModel_GuidePage mj_objectWithKeyValues:responseObject];
        
        NSMutableArray *filterArr = [self getFilterArrayWithSource:model.indexInfo];
        //清除本地无用缓存
        [self deleteLocalGuideUselessCache:filterArr];
        //清除广告视频缓存
        [self clearADVideoCache:filterArr];
        
        //找出当前应该显示的那一个广告页
        FeaturedModel_GuidePageIndex *currentShowData = [self getShouldShowGuideData:filterArr];
        
        //展示视频广告
        if (currentShowData && [NSString isNullToString:currentShowData.video].length > 0) {
            [self setupADVideo:currentShowData];
        } else {
        //展示图片广告
            [self setupADImage:currentShowData];
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self dismissAlphaAnimation];
    }];
}

- (void)clearADVideoCache:(NSArray <FeaturedModel_GuidePageIndex *>*)array {
    NSMutableArray *urlArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(FeaturedModel_GuidePageIndex * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSString isNullToString:obj.video].length > 0) {
            [urlArray addObject:[NSURL URLWithString:obj.video]];
        }
    }];
    [UM_LaunchAdCache clearDiskCacheExceptVideoUrlArray:urlArray];
}

- (void)setupADImage:(FeaturedModel_GuidePageIndex *)currentShowData {
    if (currentShowData) {
        currentShowData.downloadImgStr = [self parseModelImageURL:currentShowData];
        NSMutableArray *imgUrlList = [NSMutableArray arrayWithObject:currentShowData.downloadImgStr];
        //下载图片
        @weakify(self);
        [[USImageDownloadManager sharedManager] downloadImageList:imgUrlList success:^(NSMutableArray * _Nullable resultArr) {
            @strongify(self);
            currentShowData.resultImage = resultArr.firstObject;
            if (currentShowData) {
                [self removeMLaunchCoverView];
                [self closeDefaultTimer];
                self.mSourceArr=@[currentShowData].mutableCopy;
                [self showScrollView:YES];
            }
            else {
                [self dismissAlphaAnimation];
            }
        } fail:^(NSError * _Nullable error) {
            @strongify(self);
            [self dismissAlphaAnimation];
        }];
    }else {
//            [self saveLocalGuideviewImg:nil];
        [self dismissAlphaAnimation];
    }
}

- (void)setupADVideo:(FeaturedModel_GuidePageIndex *)currentShowData {
    //本地不存在广告视频 (下载广告视频)
    //先加载占位图（启动页），防止播放前黑屏
    self.playerControlView.coverImageView.image = [UIImage imageNamed:[DeviceInfoHelper queryLaunchImage]];
//    currentShowData.video = @"https://video-beta.ulecdn.com/item/20200416/appvideo/ulebetacs2_aa374499da314f70bee73923dd409207_VID_20200416_150215.mp4";
    if (![UM_LaunchAdCache checkIsHaveVideoCachePathWithURL:[NSURL URLWithString:currentShowData.video]]) {
        [[UM_ADDownloadManager share] downloadVideoWithURL:[NSURL URLWithString:currentShowData.video]];
        self.player.assetURL = [NSURL URLWithString:currentShowData.video];
    } else {
        self.player.assetURL = [UM_LaunchAdCache getVideoCacheURLWithURL:[NSURL URLWithString:currentShowData.video]];
    }
    [self.player playTheIndex:0];
    
    self.mSourceArr=@[currentShowData].mutableCopy;
    [self closeDefaultTimer];
    [self setAlertShowTimes:currentShowData.guide_code];
    
    @weakify(self);
    //缓冲时间
    self.player.playerBufferTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
        @strongify(self);
        ZFAVPlayerManager *manager = [[ZFAVPlayerManager alloc] init];
        if (manager.loadState == ZFPlayerLoadStatePrepare && bufferTime > 3) {
            [self dismissAlphaAnimation];
        }
        NSLog(@"bufferTime = %f", bufferTime);
    };
    //缓冲完成，准备开始播放
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self);
        self.playerControlView.coverImageView.hidden = NO;
        [self showSkipButton];
        NSLog(@"begin");
    };
    //播放失败隐藏点击重试按钮，直接进入首页
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self);
        self.playerControlView.failBtn.hidden = YES;
        [self dismissAlphaAnimation];
    };
    //开始播放
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self);
//        [self showSkipButton];
        self.playerControlView.coverImageView.hidden = YES;
        //静音
        asset.muted = YES;
    };
    
    //播放完成进入首页
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self);
        [self startGuideShowTimer:0];
        [self performSelector:@selector(dismissAlphaAnimation) withObject:nil afterDelay:0];
    };
}

- (void)showSkipButton {
    self.mPageControl.numberOfPages = self.mSourceArr.count;
    self.mPageControl.currentPage = 0;
    //跳过
    [self.playerControlView.portraitControlView addSubview:self.skipBtn];
    [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
}

- (void)clickVideo {
    FeaturedModel_GuidePageIndex *itemModel = self.mSourceArr[self.mPageControl.currentPage];
    if ([NSString isNullToString:itemModel.ios_action].length > 0) {
        // 取消自动消失
        if (self.mSourceArr.count == 1) {
            [self closeGuideShowTimer];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlphaAnimation) object:nil];
        }
        [UIView animateWithDuration:0.7 animations:^{
            
            self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.view.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                [self dismissGuideViewController:YES];
            }
        }];
    }
}

- (void)showScrollView:(BOOL)isLog {
    if (_mScrollView) {
        if (_mScrollView.contentSize.width == CGRectGetWidth(self.mScrollView.frame)) {
            [self closeGuideShowTimer];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissAlphaAnimation) object:nil];
        }
        [_mScrollView removeFromSuperview];
        _mScrollView = nil;
    }
    [self.mScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.mScrollView.frame)*self.mSourceArr.count, CGRectGetHeight(self.mScrollView.frame))];
    [self.view addSubview:self.mScrollView];
    
    for (int i=0; i<self.mSourceArr.count; i++) {
        FeaturedModel_GuidePageIndex *itemModel = self.mSourceArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [btn setBackgroundImage:itemModel.resultImage forState:UIControlStateNormal];
        [btn setBackgroundImage:itemModel.resultImage forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(touchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.mScrollView addSubview:btn];
        if (isLog) {
            [self setAlertShowTimes:itemModel.guide_code];
        }
    }
    //跳过
    [self.view addSubview:self.skipBtn];
    if (self.mSourceArr.count == 1) {
        [self.skipBtn setTitle:@"跳过3s" forState:UIControlStateNormal];
    }else{
        [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    }
    
    // pageControl
    self.mPageControl.numberOfPages = self.mSourceArr.count;
    self.mPageControl.currentPage = 0;
    [self.view addSubview:self.mPageControl];
        
    // 单图3s后自动消失
    if (self.mSourceArr.count == 1) {
        [self startGuideShowTimer:3];
        [self performSelector:@selector(dismissAlphaAnimation) withObject:nil afterDelay:3.7];
    }
}

- (FeaturedModel_GuidePageIndex *)getShouldShowGuideData:(NSMutableArray *)filteredArray{
    USGuideViewLocalModel *guideLocalModel=[self getLocalGuideModel];
    //如果本地没有显示数据 说明从没显示过 直接取第一个显示
    if (!guideLocalModel.guideDataArray||guideLocalModel.guideDataArray.count==0) {
        return filteredArray.firstObject;
    }
    //获取当天日期
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSString * currentDateStr=[NSDate DateStringFromTimestamp:currentTime DateFormat:@"YYYYMMdd"];
    //不是当天 重置remainder 重置弹出次数
    if (![guideLocalModel.lastShowDate isEqualToString:currentDateStr]) {
        guideLocalModel.remainder=@"0";
        for (USGuideViewLocalInfo * alertLocalInfo in guideLocalModel.guideDataArray) {
            alertLocalInfo.guideShowCount=@"0";
        }
    }
    
    for (FeaturedModel_GuidePageIndex *guideInfo in filteredArray.reverseObjectEnumerator) {
        BOOL findOld=NO;
        for (USGuideViewLocalInfo *guideLocalInfo in guideLocalModel.guideDataArray) {
            if ([guideInfo.guide_code isEqualToString:guideLocalInfo.guideCode]) {
                findOld=YES;
                //字段为空没有次数上限 直接把已显示次数赋值给请求到的数据
                if ([NSString isNullToString:guideInfo.guide_count].length<=0) {
                    guideInfo.nowDayShowedCount=guideLocalInfo.guideShowCount;
                    break;
                }else{
                    if ([guideLocalInfo.guideShowDate isEqualToString:currentDateStr]) {
                        //如果已显示次数大于等于接口返回设置的最大显示次数 就删除此条数据
                        if (guideLocalInfo.guideShowCount.integerValue>=guideInfo.guide_count.integerValue) {
                            [filteredArray removeObject:guideInfo];
                            break;
                        }
                        //如果弹出日期是当天 就把弹出次数赋值给接口数据
                        guideInfo.nowDayShowedCount=guideLocalInfo.guideShowCount;
                    }
                    //如果不是当天 说明当天没有显示过 赋值0
                    else{
                        guideInfo.nowDayShowedCount=@"0";
                    }
                }
                break;
            }
            //如果在本地数据中没有找到匹配到的 说明是新返回的活动弹框 从没有弹出过 赋值0
            if (!findOld) {
                guideInfo.nowDayShowedCount=@"0";
            }
        }
    }
    //然后根据已弹出次数找出下一个需要弹出的活动框
    //先用弹出次数除2取余 找出第一个等于0的还未弹出过
    BOOL findOne=NO;
    for (FeaturedModel_GuidePageIndex *guideInfo in filteredArray) {
        if (guideInfo.nowDayShowedCount.integerValue%2==guideLocalModel.remainder.integerValue) {
            findOne=YES;
            [self saveLocalGuideModel:guideLocalModel];
            return guideInfo;
        }
    }
    if (!findOne) {
        //如果都已经是奇数 说明都已经弹出过一遍 找除2取余等于1的
        if (guideLocalModel.remainder.integerValue==0) {
            guideLocalModel.remainder=@"1";
        }else{
            guideLocalModel.remainder=@"0";
        }
        [self saveLocalGuideModel:guideLocalModel];
        for (FeaturedModel_GuidePageIndex *guideInfo in filteredArray) {
            if (guideInfo.nowDayShowedCount.integerValue %2==guideLocalModel.remainder.integerValue) {
                return guideInfo;
            }
        }
    }
    [self saveLocalGuideModel:guideLocalModel];
    return nil;
}

//记录通用弹窗展示次数
- (void)setAlertShowTimes:(NSString *)guideCode{
    //获取当天日期
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSString * currentDateStr=[NSDate DateStringFromTimestamp:currentTime DateFormat:@"YYYYMMdd"];
    
    USGuideViewLocalModel * guideLocalModel=[self getLocalGuideModel];
    
    if (guideLocalModel) {
        BOOL isFind=NO;
        for (USGuideViewLocalInfo * guideInfo in guideLocalModel.guideDataArray) {
            if ([guideCode isEqualToString:guideInfo.guideCode]) {
                guideInfo.guideShowCount=[NSString stringWithFormat:@"%ld",guideInfo.guideShowCount.integerValue+1];
                guideInfo.guideShowDate=currentDateStr;
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            USGuideViewLocalInfo * guideInfo=[[USGuideViewLocalInfo alloc] init];
            guideInfo.guideCode=guideCode;
            guideInfo.guideShowCount=@"1";
            guideInfo.guideShowDate=currentDateStr;
            NSMutableArray * muArr=[guideLocalModel.guideDataArray mutableCopy];
            [muArr addObject:guideInfo];
            guideLocalModel.guideDataArray=[muArr copy];
        }
    }
    else{
        guideLocalModel = [[USGuideViewLocalModel alloc] init];
        guideLocalModel.remainder=@"0";
        NSMutableArray * arr = [NSMutableArray new];
        USGuideViewLocalInfo * guideInfo=[[USGuideViewLocalInfo alloc] init];
        guideInfo.guideCode=guideCode;
        guideInfo.guideShowCount=@"1";
        guideInfo.guideShowDate=currentDateStr;
        [arr addObject:guideInfo];
        guideLocalModel.guideDataArray=[arr copy];
    }
    guideLocalModel.lastShowDate=currentDateStr;
    [self saveLocalGuideModel:guideLocalModel];
}

//匹配删除本地存的无用数据
- (void)deleteLocalGuideUselessCache:(NSMutableArray *)filteredArray{
    USGuideViewLocalModel * guideLocalModel=[self getLocalGuideModel];
    NSMutableArray * guideLocalArr=[guideLocalModel.guideDataArray mutableCopy];
    if (!guideLocalModel) {
        return;
    }
    //有删除操作 逆序遍历
    for (USGuideViewLocalInfo * localGuideInfo in guideLocalArr.reverseObjectEnumerator) {
        BOOL findOld=NO;
        for (FeaturedModel_GuidePageIndex * guideInfo in filteredArray) {
            if ([guideInfo.guide_code isEqualToString:localGuideInfo.guideCode]) {
                findOld=YES;
                break;
            }
        }
        if (!findOld) {
            [guideLocalArr removeObject:localGuideInfo];
        }
    }
    if (guideLocalArr.count < guideLocalModel.guideDataArray.count) {
        guideLocalModel.guideDataArray=[guideLocalArr copy];
        [self saveLocalGuideModel:guideLocalModel];
    }
}

- (USGuideViewLocalModel *)getLocalGuideModel{
    //读取本地存储的弹框数据
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:KEY_LocalGuideModel];
    // unarchiveObjectWithFile会调用initWithCoder
    USGuideViewLocalModel * guideLocalModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return guideLocalModel;
}
- (void)saveLocalGuideModel:(USGuideViewLocalModel *)guideLocalModel{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:KEY_LocalGuideModel];
    [NSKeyedArchiver archiveRootObject:guideLocalModel toFile:filePath];
}

#pragma mark - <StatusBarHidden>
- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

#pragma mark - <getter>
- (UleNetworkExcute *)networkClient_UstaticCDN{
    if (!_networkClient_UstaticCDN) {
        _networkClient_UstaticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_UstaticCDN;
}

- (UIImageView *)mLaunchCoverView
{
    if (!_mLaunchCoverView) {
        _mLaunchCoverView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _mLaunchCoverView.backgroundColor = [UIColor whiteColor];
        _mLaunchCoverView.image = [UIImage imageNamed:[DeviceInfoHelper queryLaunchImage]];
    }
    return _mLaunchCoverView;
}

- (UIScrollView *)mScrollView
{
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,__MainScreen_Width,__MainScreen_Height)];
        _mScrollView.pagingEnabled = YES;
        _mScrollView.clipsToBounds = YES;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.userInteractionEnabled = YES;
        _mScrollView.bounces = NO;
        _mScrollView.backgroundColor = [UIColor whiteColor];
        _mScrollView.delegate = self;
    }
    return _mScrollView;
}

- (SMPageControl *)mPageControl
{
    if(!_mPageControl) {
        _mPageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-UleGuideViewPageControlHeight-10.0, __MainScreen_Width, UleGuideViewPageControlHeight)];
        _mPageControl.backgroundColor = [UIColor clearColor];
        [_mPageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_mPageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        _mPageControl.indicatorDiameter=7;
        _mPageControl.currentPage = 0;
        _mPageControl.hidesForSinglePage = YES;
    }
    return _mPageControl;
}

- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 80.0, 10.0 + kStatusBarHeight, 70.0, 30.0);
        _skipBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.3];
        _skipBtn.layer.cornerRadius = 15;
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:15.5];
        [_skipBtn addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipBtn;
}

- (ZFPlayerControlView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [ZFPlayerControlView new];
        _playerControlView.fastViewAnimated = YES;
        _playerControlView.autoHiddenTimeInterval = 0;
        _playerControlView.fullScreenOnly = YES;
        _playerControlView.activity.hidden = YES;
        _playerControlView.fastProgressView.hidden = YES;
        [_playerControlView.bottomPgrogress removeFromSuperview];
        
        UIButton *playerGes = [UIButton buttonWithType:UIButtonTypeCustom];
        [playerGes addTarget:self action:@selector(clickVideo) forControlEvents:UIControlEventTouchUpInside];
        [_playerControlView.portraitControlView addSubview:playerGes];
        
        playerGes.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _playerControlView;
}

- (ZFPlayerController *)player
{
    if (!_player) {
        ZFAVPlayerManager *manager = [[ZFAVPlayerManager alloc] init];
        _player = [ZFPlayerController playerWithPlayerManager:manager containerView:self.view];
        _player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        _player.controlView = self.playerControlView;
        _player.shouldAutoPlay = NO;
        _player.disableGestureTypes = ZFPlayerDisableGestureTypesAll;
    }
    return _player;
}

- (NSMutableArray *)mSourceArr
{
    if (!_mSourceArr) {
        _mSourceArr = [NSMutableArray array];
    }
    return _mSourceArr;
}

#pragma mark - <过滤>
- (NSMutableArray *)getFilterArrayWithSource:(NSArray *)sourceArray{
    NSMutableArray *filterArr = [NSMutableArray array];
    for (FeaturedModel_GuidePageIndex *itemModel in sourceArray) {
        BOOL isCanInput = [UleModulesDataToAction canInputDataMin:itemModel.min_version withMax:itemModel.max_version withDevice:itemModel.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (isCanInput&&[self filterProvince:itemModel]) {
            [filterArr addObject:itemModel];
        }
    }
    return filterArr;
}

//筛选省份,没配默认不限制省份
- (BOOL)filterProvince:(FeaturedModel_GuidePageIndex *)info
{
    if ([NSString isNullToString:info.showProvince].length>0&&[US_UserUtility sharedLogin].mIsLogin) {
        if ([US_UserUtility sharedLogin].m_provinceCode.length > 0 && [info.showProvince containsString:[US_UserUtility sharedLogin].m_provinceCode]) {
            return [self filtereData:info];
        }
    } else {
        return [self filtereData:info];
    }
    return NO;
}
//有效时间匹配
- (BOOL)filtereData:(FeaturedModel_GuidePageIndex *)info{
    //判断是否在活动期间内（必须是有效起止时间）
    //没有配置时间默认没有一直有效
    if ([self validateWithTime:info.guide_time] || [NSString isNullToString:info.guide_time].length <= 0) {
        return YES;
    }
    return NO;
}
//当前时间是否在某个时间段内
- (BOOL)validateWithTime:(NSString *)timeStr {
    //必须配置有效起止时间
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"#"];
    if (timeArr.count > 1 && ([NSString stringWithFormat:@"%@", timeArr[0]].length > 0 && [NSString stringWithFormat:@"%@", timeArr[1]].length > 0)) {
        NSString *startTime = timeArr[0];
        NSString *expireTime = timeArr[1];
        NSDate *today = [NSDate date];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *start = [dateFormat dateFromString:startTime];
        NSDate *expire = [dateFormat dateFromString:expireTime];

        if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
            return YES;
        }
        return NO;
    }
    return NO;
}


@end
