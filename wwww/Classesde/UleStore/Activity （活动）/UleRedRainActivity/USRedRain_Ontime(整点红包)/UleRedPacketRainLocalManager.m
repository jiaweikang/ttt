//
//  UleRedPacketRainManager.m
//  UleApp
//
//  Created by zemengli on 2018/7/24.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleRedPacketRainLocalManager.h"
#import "US_NetworkExcuteManager.h"
#import "UleRedPacketRainManager.h"
#import "UleRedPacketRainCountDownView.h"
#import "UleGetTimeTool.h"
#import "UIView+ShowAnimation.h"
#import "UleCountDownManager.h"
#import "NSObject+YYModel.h"
#import "NSString+FTDate.h"
#import "US_RedPacketApi.h"
#import "USRedPacketCashManager.h"
#import "US_LocalNotification.h"
#import "USLocationManager.h"
#import "US_LoginManager.h"
#import "USAuthorizetionHelper.h"

#define kRedRainLocalNotificationTitle  @"一亿红包即将来袭，立即开抢，手慢无"
#define kShowedActivityStartViewArr                    @"ShowedActivityStartView"
#define kShowedActivityCountDownViewArr                @"ShowedActivityCountDownView"

typedef enum : NSUInteger {
    mViewType_ActivityCountDown,//倒计时
    mViewType_ActivityStart, //活动开始
} viewType;

@interface UleRedPacketRainLocalManager ()
{
    
}
@property (nonatomic, strong) UleNetworkExcute * networkClient_CDN;
@property (nonatomic, copy)   NSString     * mRedPacketRain_theme;
@property (nonatomic, copy)   NSString     * mRedPacketRainInfoURL;
@property (nonatomic, copy)   NSString     * mRedPacketCash_theme;
@property (nonatomic, copy)   NSString     * mRedPacketCashInfoURL;

@property (nonatomic, strong) NSMutableArray * fieldModelArray;
@property (nonatomic, strong) NSMutableArray * localNotiDateArr;
@property (nonatomic, strong) NSString      * difftime;//本地时间与服务器时间时间差

@end

@implementation UleRedPacketRainLocalManager

-(void)dealloc{
//    if (_networkClient_CDN) {
//        [_networkClient_CDN cancel];
//    }
}

/** 单例 */
+ (instancetype)sharedManager {
    
    static UleRedPacketRainLocalManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[UleRedPacketRainLocalManager alloc] init];
        });
    }
    return sharedManager;
}


- (void)setRedPacketRainLocalNotificationWithTitle:(NSString *)title keystr:(NSString *)keystr interval:(NSTimeInterval)interval{
    
    if (![[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"] && self.isRedRainActivity) {
        NSMutableArray *fireDateArr = [NSMutableArray array];
        for (int i = 0; i < self.localNotiDateArr.count; i++) {
            UleRedPacketRainModel *redRainModel = [self.localNotiDateArr objectAtIndex:i];
            if ([fireDateArr containsObject:redRainModel.startDate]){continue;}
            [fireDateArr addObject:redRainModel.startDate];
        }
        [[US_LocalNotification sharedManager] localNotificationRegist:fireDateArr titleStr:title keyStr:keystr interval:interval];
    }
}

- (void)handleLocalNotification{
    //先取消推送
    [[US_LocalNotification sharedManager] cancelRedPacketRainLocalNotification:UleRedPacketNotiKeys];
    //先判断提醒是否开启
    BOOL remaindIsOpen=[self getRemaindIsOpen];
    
    if (!remaindIsOpen||![USAuthorizetionHelper currentNotificationAllowed]) {
        return;
    }
    //把当天场次和第二天场次  一起创建推送
    //每场活动的本地推送
//    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSMutableArray * notificationKeyArr=[NSMutableArray new];
    if ([self.localNotiDateArr count]>0) {
//        for (int i=0; i<[self.fieldModelArray count]; i++) {
//            UleRedPacketRainModel * redRainModel = [self.fieldModelArray objectAtIndex:i];
//            //          找到即将开始场次 创建提前两分钟提醒
//            NSTimeInterval  interval = (redRainModel.startTime-currentTime)/1000;
//            if (interval>2*60) {
//                [notificationKeyArr addObject:redRainModel.startDate];
                [self setRedPacketRainLocalNotificationWithTitle:kRedRainLocalNotificationTitle keystr:UleRedPacketNotiKeys interval:0];
//            }
//        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:notificationKeyArr forKey:UleRedPacketNotiKeys];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//处理活动场次数据
- (void)handleRedRainActivityData:(id)retObj{
    [self.fieldModelArray removeAllObjects];
    UleRedPacketRainActivityInfo * activityInfo = [UleRedPacketRainActivityInfo yy_modelWithDictionary:retObj];
    BOOL isActivityActive=activityInfo.content.count>0;
    if (self.permissionBlock) {
        self.permissionBlock(isActivityActive);
    }
    //如果当天没有场次，则不处理
    if (!isActivityActive) {
        //清除本地推送
        [self handleLocalNotification];
        return;
    }
    //当天所有活动场次 根据themeCode匹配 然后装进数组 然后按开始时间升序排序
    for (RedRainActivityInfoContent * infoContent in activityInfo.content) {
        //找到主题对应的所有的活动
        if ([infoContent.themeCode isEqualToString:self.mRedPacketRain_theme]) {
            for (int i=0; i<[infoContent.fieldInfos count]; i++) {
                RedRainFieldInfo * fieldInfo=[infoContent.fieldInfos objectAtIndex:i];
                //筛出无用数据
                if (fieldInfo.startTime.length<=0||fieldInfo.endTime.length<=0) {
                    continue;
                }
                NSDate * startDate = [fieldInfo.startTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * endDate = [fieldInfo.endTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval startTime=[startDate timeIntervalSince1970]*1000;
                NSTimeInterval endTime=[endDate timeIntervalSince1970]*1000;
                UleRedPacketRainModel * redRainModel=[[UleRedPacketRainModel alloc]init];
                redRainModel.startTime=startTime;
                redRainModel.endTime=endTime;
                redRainModel.startDate=fieldInfo.startTime;
                redRainModel.endDate=fieldInfo.endTime;
                redRainModel.activityCode=infoContent.activityCode;
                redRainModel.fieldId=fieldInfo.fieldId;
                [self.fieldModelArray addObject:redRainModel];
            }
        }
    }
    
    //如果有第二天的活动场次 根据themeCode匹配 然后装进数组 不用排序 只为创建本地推送用
    if (activityInfo.tomorrowContent && [activityInfo.tomorrowContent.fieldInfos count]>0) {
        //找到主题对应的所有的活动
        if ([activityInfo.tomorrowContent.themeCode isEqualToString:self.mRedPacketRain_theme]) {
            for (int i=0; i<[activityInfo.tomorrowContent.fieldInfos count]; i++) {
                RedRainFieldInfo * fieldInfo=[activityInfo.tomorrowContent.fieldInfos objectAtIndex:i];
                NSDate * startDate = [fieldInfo.startTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * endDate = [fieldInfo.endTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval startTime=[startDate timeIntervalSince1970]*1000;
                NSTimeInterval endTime=[endDate timeIntervalSince1970]*1000;
                UleRedPacketRainModel * redRainModel=[[UleRedPacketRainModel alloc]init];
                redRainModel.startTime=startTime;
                redRainModel.endTime=endTime;
                redRainModel.startDate=fieldInfo.startTime;
                redRainModel.endDate=fieldInfo.endTime;
                redRainModel.activityCode=activityInfo.tomorrowContent.activityCode;
                redRainModel.fieldId=fieldInfo.fieldId;
                [self.fieldModelArray addObject:redRainModel];
            }
        }
    }
    //根据活动开始时间排序
    if ([self.fieldModelArray count]>1) {
        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
        NSArray * array = [[self.fieldModelArray copy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        self.fieldModelArray = [array mutableCopy];
        self.localNotiDateArr = [array mutableCopy];
    }
}

//开启定时 一直判断活动是否开始
- (void)countDownHandleRedRainData{
    //找到了正在进行的活动 如果没显示过 就直接开抢
    if ([self findStartActivity]) {
        //如果立即开抢 没显示过 就直接显示
        if (![self viewIsShowedWithViewType:mViewType_ActivityStart]) {
            [self showtRedRainActivityStartView];
        }
    }
}

//找到是否有已开始活动
- (BOOL)findStartActivity{
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    if ([self.fieldModelArray count]>0) {
        for (int i=0; i<[self.fieldModelArray count]; i++) {
            UleRedPacketRainModel * redRainModel = [self.fieldModelArray objectAtIndex:i];
            //找出当前在哪一个活动中
            if (currentTime>redRainModel.startTime && currentTime<redRainModel.endTime) {
//                NSLog(@"______找到当前已经开始场次");
                self.redRainModel=redRainModel;
                return YES;
            }
        }
    }
    return NO;
}

//找到将要开始活动
- (BOOL)findWillStartActivity{
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSInteger willShowFieldindex=-1;//下一场即将开始的活动index
    if ([self.fieldModelArray count]>0) {
        for (int i=0; i<[self.fieldModelArray count]; i++) {
            UleRedPacketRainModel * redRainModel = [self.fieldModelArray objectAtIndex:i];
            if (currentTime<redRainModel.startTime) {
//                NSLog(@"______找到即将开始场次");
                willShowFieldindex=i;
                break;
            }
        }
    }
    if(willShowFieldindex>-1){
        self.redRainModel=[self.fieldModelArray objectAtIndex:willShowFieldindex];
        return YES;
    }
    else{
        return NO;
    }
}

//下拉刷新 直接显示倒计时或者活动开始
- (void)pullDownRefreshHandleRedRainData{
    
    //找到了正在进行的活动 就直接开抢
    if ([self findStartActivity]) {
        [self showtRedRainActivityStartView];
    }
    else{
        //没有找到当前场次 找到下一场的话
        if ([self findWillStartActivity]) {
            //显示倒计时弹框
            NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
            [self showtRedRainCountDownView:(self.redRainModel.startTime-currentTime)/1000];
        }
    }
}

//启动 倒计时和活动开始 显示一次后不再显示
- (void)openAppHandleRedRainData{

    //找到了正在进行的活动 就直接开抢
    if ([self findStartActivity]) {
        if (![self viewIsShowedWithViewType:mViewType_ActivityStart]) {
            [self showtRedRainActivityStartView];
        }
    }
    else if ([self findWillStartActivity]) {
        //没有找到当前场次 找到下一场的话
        if (![self viewIsShowedWithViewType:mViewType_ActivityCountDown]) {
            NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
            [self showtRedRainCountDownView:(self.redRainModel.startTime-currentTime)/1000];
        }
    }
}

//倒计时或者开抢 是否显示过
- (BOOL)viewIsShowedWithViewType:(viewType)viewType{
    NSString * startDateStr=self.redRainModel.startDate;
    if (startDateStr.length<=0) {
        return YES;
    }
    NSMutableArray * showedCountDownViewArr = [[[NSUserDefaults standardUserDefaults] objectForKey:viewType==mViewType_ActivityCountDown?kShowedActivityCountDownViewArr:kShowedActivityStartViewArr] mutableCopy];
    if ([showedCountDownViewArr containsObject:startDateStr]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)setViewShowedWithViewType:(viewType)viewType{
    NSString * startDateStr=self.redRainModel.startDate;
    if (startDateStr.length<=0) {
        return;
    }
    NSMutableArray * showedCountDownViewArr = [[[NSUserDefaults standardUserDefaults] objectForKey:viewType==mViewType_ActivityCountDown?kShowedActivityCountDownViewArr:kShowedActivityStartViewArr] mutableCopy];
    if (!showedCountDownViewArr) {
        showedCountDownViewArr=[NSMutableArray new];
    }
    if ([showedCountDownViewArr containsObject:startDateStr]) {
        return;
    }
    [showedCountDownViewArr addObject:startDateStr];
    [[NSUserDefaults standardUserDefaults] setObject:showedCountDownViewArr forKey:viewType==mViewType_ActivityCountDown?kShowedActivityCountDownViewArr:kShowedActivityStartViewArr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)enterGameAction{
    //http://h5.tom.cn/thirdPart/ule/zhifeijiylxd/index.html?game_id=229&mobile=17621306963&province=上海&channel=ios&client=ylxd
    NSString * urlStr = [NSString stringWithFormat:@"%@&mobile=%@&province=%@&channel=ios&client=ylxd",self.enterGameiOSURL,[US_UserUtility sharedLogin].m_mobileNumber,[self getProvince]];
    NSMutableDictionary * dic  = @{@"key":urlStr,
                                   @"title":@"游戏",
                                   @"hasnavi":@"1"}.mutableCopy;
    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
}

- (NSString *)getProvince{
    NSString * provinceStr = @"";
    if ([USLocationManager sharedLocation].lastProvince.length > 0) {
        if ([USLocationManager sharedLocation].lastProvince.length >= 2) {
            provinceStr=[[USLocationManager sharedLocation].lastProvince substringToIndex:2];
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

#pragma mark - UleCountDownManager delegate 定时
- (void)countDownString:(NSString *)text{
    [self countDownHandleRedRainData];
}

- (void)countDownStart{
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    //最后一场活动的结束时间
    UleRedPacketRainModel * redRainModel = [self.fieldModelArray lastObject];
    //开启首页定时
    [[UleCountDownManager shareInstanceWithDelegate:self] countDownWithCurrentTime:[NSString stringWithFormat:@"%f",currentTime]  WithEndTime:[NSString stringWithFormat:@"%f",redRainModel.endTime]];
}

- (void)countDownStop{
    [[UleCountDownManager shareInstanceWithDelegate:self] closeTimeAndRemoveObserver];
}

//显示活动开始 开抢红包弹框
- (void)showtRedRainActivityStartView{
    //未登录不显示
    if (self.isShowingActivityView) {
        return;
    }
    if (self.redRainModel.fieldId.length<=0 || self.redRainModel.activityCode.length<=0) {
        return;
    }
    self.redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
    self.redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
    self.redRainModel.channel=UleRedPacketRainChannel;
    self.redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
    // 红包雨活动开始提醒弹框日志
    [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsStartDialog" environment:[UleStoreGlobal shareInstance].config.envSer withModel:self.redRainModel];
    //记录下 开抢弹框 已显示过
    [self setViewShowedWithViewType:mViewType_ActivityStart];
    
    /**** 邮乐年货节 改为活动开始直接开抢 2018.12.26 ***/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //没登录先登录
//        if (![UleUserInfoClass isUserLogin]) {
//            [UleLoginManager showLoginViewController:@"RedRainStart" withTarget:self withParam:nil];
//        }else{
            //开抢
            [self startRedRain];
//        }
    });
}



//开抢
- (void)startRedRain{
    if (self.redRainModel.fieldId.length>0 && self.redRainModel.activityCode.length>0) {
        self.redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
        self.redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
        self.redRainModel.channel=UleRedPacketRainChannel;
        self.redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
        self.redRainModel.activityDate=self.mRedRainThemeModel_4.interval;
        self.redRainModel.wishes=self.mRedRainThemeModel_4.failText;
        [UleRedPacketRainManager startUleRedPacketRainWithModel:self.redRainModel environment:[UleStoreGlobal shareInstance].config.envSer>0?YES:NO increaseCashDarw:NO ClickEvent:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
            switch (event) {
                case UleRedpacketRainEventShare:
                    [[USRedPacketCashManager sharedManager] showShareViewWithDataArray:obj andShareText:self.mRedRainThemeModel_4.shareText];
                    break;
                case UleRedpacketRainEventToHomePage:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoHomePage];
                    break;
                case UleRedpacketRainEventToMain:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoMainVenue];
                    break;
                case UleRedpacketRainEventToUse:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoUse];
                    break;
                case UleRedpacketRainEventOneMore:
                    
                    break;
                default:
                    break;
            }
        }];
    }
}

//显示活动倒计时
- (void)showtRedRainCountDownView:(NSTimeInterval)countDownTimeInterval{
    //未登录不显示
    if (self.isShowingActivityView) {
        return;
    }
    self.redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
    self.redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
    self.redRainModel.channel=UleRedPacketRainChannel;
    self.redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
    // 红包雨活动未开始提醒弹框日志
    [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsUnStartDialog" environment:[UleStoreGlobal shareInstance].config.envSer withModel:self.redRainModel];
    
    //记录下 倒计时 已显示过
    [self setViewShowedWithViewType:mViewType_ActivityCountDown];
    
    //先判断提醒是否开启
    BOOL remaindIsOpen=[self getRemaindIsOpen];
    UleRedPacketRainCountDownView * countDownView=[[UleRedPacketRainCountDownView alloc]initWithFrame:CGRectMake(0, 0, SCALEWIDTH(310), [UleRedPacketRainLocalManager sharedManager].enterGameImageUrl.length>0?SCALEWIDTH(480):SCALEWIDTH(420)) withType:remaindIsOpen?UleRedPacketRainViewType_ActivityCountDown_Remind_ON:UleRedPacketRainViewType_ActivityCountDown_Remind_OFF];
    [countDownView showViewWithAnimation:AniamtionAlert];
    [countDownView startCountDownWithSecondTime:countDownTimeInterval];
    //点击开启或者关闭提醒
    @weakify(self);
    countDownView.clickBlock = ^(UleRedPacketRainViewType buttonType) {
        @strongify(self);
        //当前开启 点击关闭提醒
        if (buttonType==UleRedPacketRainViewType_ActivityCountDown_Remind_ON) {
            [self setRemaind:YES];
            self.redRainModel.channel=UleRedPacketRainChannel;
            self.redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
            self.redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
            self.redRainModel.province=[USLocationManager sharedLocation].lastProvince;
            self.redRainModel.orgCode=[US_UserUtility sharedLogin].m_provinceCode;
            //开启提醒  记日志
            [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsNotify" environment:[UleStoreGlobal shareInstance].config.envSer>0?YES:NO withModel:self.redRainModel];
            //创建本地推送
            [self handleLocalNotification];
        }
        //当前关闭 点击开启提醒
        else if (buttonType==UleRedPacketRainViewType_ActivityCountDown_Remind_OFF) {
            [self setRemaind:NO];
            //取消本地推送
            [[US_LocalNotification sharedManager] cancelRedPacketRainLocalNotification:UleRedPacketNotiKeys];
            //            [self cancelRedPacketRainLocalNotification];
        }
    };
}

#pragma mark - request
//获取活动主题信息
- (void)requestRedPacketRainTheme{
    if (self.mRedPacketRain_theme.length<=0||self.mRedPacketCash_theme.length<=0) {
        //没有主题 先请求主题 再请求活动场次
        @weakify(self);
        [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketTheme] success:^(id responseObject) {
            @strongify(self);
            RedRainThemes * themeData = [RedRainThemes yy_modelWithDictionary:responseObject];
            self.isRedRainActivity=[themeData.flag boolValue];
            self.enterGameImageUrl=themeData.double_image_url;
            self.enterGameiOSURL=themeData.double_url;
            if (self.permissionBlock) {
                self.permissionBlock(self.isRedRainActivity);
            }
            //活动开启期间才请求活动场次数据
            if ([themeData.flag boolValue]) {
                for (RedRainTheme * themeObj in themeData.themes) {
                    //根据活动场景类型找到对应的活动主题
                    if([themeObj.type isEqualToString:UleRedPacketTypeRain]){
//                        self.mRedRainThemeModel_4=themeObj;
//                        self.mRedPacketRain_theme=themeObj.theme;
                    }else if ([themeObj.type isEqualToString:UleRedPacketTypeCash]){
                        self.mRedRainThemeModel_1=themeObj;
                        self.mRedPacketCash_theme=themeObj.theme;
                        [US_UserUtility sharedLogin].redPacketLimitCount=themeObj.limit;
                    }
                }
                //整点红包雨主题
//                if (self.mRedPacketRain_theme.length>0) {
//                    [self requestRedPacketRainInfo];
//                }
                //现金红包主题
                if (self.mRedPacketCash_theme.length>0) {
                    [self requestRedPacketCashInfo];
                }
            }
            else {
                /*
                //非活动期间
                //取消所有本地推送
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                 */
                //移除弹框状态缓存
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:kShowedActivityCountDownViewArr];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:kShowedActivityStartViewArr];
                 
            }
        } failure:^(UleRequestError *error) {
            
        }];
    }else {
        /*
        //如果已经获取了主题 就直接请求活动场次
        if(self.mRedPacketRain_theme.length > 0){
            [self requestRedPacketRainInfo];
        }
         */
        if (self.mRedPacketCash_theme.length > 0) {
            [self requestRedPacketCashInfo];
        }
    }
    
}
//根据主题 获取红包雨场次信息
- (void)requestRedPacketRainInfo{
    [self countDownStop];
    @weakify(self);
    [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketInfoRainWithTheme:self.mRedPacketRain_theme] success:^(id responseObject) {
        @strongify(self);
        //红包雨场次
        [self handleRedRainActivityData:responseObject];
        //下拉刷新
        if (self.isPullDownRefresh) {
            [self pullDownRefreshHandleRedRainData];
        }
        //app启动
        else {
            [self openAppHandleRedRainData];
        }
        [self handleLocalNotification];
        //开启首页倒计时
        [self countDownStart];
    } failure:^(UleRequestError *error) {
        
    }];
}
//根据主题 获取现金红包场次信息
- (void)requestRedPacketCashInfo{
    @weakify(self);
    [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketInfoRainWithTheme:self.mRedPacketCash_theme] success:^(id responseObject) {
        @strongify(self);
        //现金红包场次
        UleRedPacketRainActivityInfo * activityInfo = [UleRedPacketRainActivityInfo yy_modelWithDictionary:responseObject];
        //遍历所有活动
        for (RedRainActivityInfoContent * infoContent in activityInfo.content) {
            //找到主题对应的活动就停止
            if ([infoContent.themeCode isEqualToString:self.mRedPacketCash_theme]) {
                //取第一个场次
                RedRainFieldInfo * fieldInfo=[infoContent.fieldInfos firstObject];
                NSDate * startDate = [fieldInfo.startTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * endDate = [fieldInfo.endTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval startTime=[startDate timeIntervalSince1970]*1000;
                NSTimeInterval endTime=[endDate timeIntervalSince1970]*1000;
                self.cashRedFieldInfo=[[UleRedPacketRainModel alloc]init];
                self.cashRedFieldInfo.startTime=startTime;
                self.cashRedFieldInfo.endTime=endTime;
                self.cashRedFieldInfo.startDate=fieldInfo.startTime;
                self.cashRedFieldInfo.endDate=fieldInfo.endTime;
                self.cashRedFieldInfo.activityCode=infoContent.activityCode;
                self.cashRedFieldInfo.fieldId=fieldInfo.fieldId;
                break;
            }
        }
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)setRemaind:(BOOL)open{
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:@"setRemaind"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)getRemaindIsOpen{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"setRemaind"];
}

#pragma mark -  <getter setter>
- (UleNetworkExcute *)networkClient_CDN{
    if (!_networkClient_CDN) {
        _networkClient_CDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_CDN;
}

- (UleRedPacketRainModel *)redRainModel{
    if (_redRainModel==nil) {
        _redRainModel=[[UleRedPacketRainModel alloc]init];
    }
    return _redRainModel;
}

//当天活动场次
- (NSMutableArray *)fieldModelArray{
    if (_fieldModelArray==nil) {
        _fieldModelArray = [NSMutableArray new];
    }
    return _fieldModelArray;
}

//当天活动场次推送时间
- (NSMutableArray *)localNotiDateArr{
    if (_localNotiDateArr==nil) {
        _localNotiDateArr = [NSMutableArray new];
    }
    return _localNotiDateArr;
}

@end


