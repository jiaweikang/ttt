//
//  UleRedPacketRainManager.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleRedPacketRainManager.h"
#import "UleRedPacketRain.h"
#import "RedRainNetWorkClient.h"
#import "UleRedPacketRainAwardView.h"
#import "UleRedPacketRainRuleView.h"
#import "UleRedPacketConfig.h"
#import "NSData+UleRedPacketRain.h"
#import "UleRedpacketSecurityKit.h"
#import "NSString+RedRain.h"

#define WinnersList      @"5元优惠券|10元优惠券|20元优惠券|30元优惠券|50元优惠券|788元TRU抵扣券|188元奖励金"

@implementation UleRedPacketRainModel

@end

@interface UleRedPacketRainManager ()

@property (nonatomic, strong) UleRedPacketRain * packetRain;
@property (nonatomic, strong) RedRainNetWorkClient * client;
@property (nonatomic, strong) UleRedPacketRainAwardView * awardView;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) NSString * uleChannel;
@property (nonatomic, strong) NSString * uleChannelCode;
@property (nonatomic, strong) UleRedPacketRainModel * redPacketRainModel;
@property (nonatomic, strong) UleRedpacketRainClickBlock clickBlock;
@property (nonatomic, assign) BOOL runEnvironment;
@property (nonatomic, assign) BOOL isIncreaseCashDraw;
@end

@implementation UleRedPacketRainManager

+ (instancetype) instance{
    static UleRedPacketRainManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UleRedPacketRainManager alloc] init];
    });
    return instance;
}

+ (void) startUleRedPacketRainWithModel:(UleRedPacketRainModel *)model environment:(BOOL)isprd increaseCashDarw:(BOOL)isIncrease ClickEvent:(UleRedpacketRainClickBlock)clickBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        UleRedPacketRainManager * manager=[UleRedPacketRainManager instance];
        manager.runEnvironment=isprd;
        manager.isIncreaseCashDraw=isIncrease;
        manager.clickBlock =[clickBlock copy];
        manager.redPacketRainModel=model;
        [manager showRedRainView];
    });
}

+ (void)showRedRainResultWithModel:(UleRedPacketRainModel *)model environment:(BOOL)isprd increaseCashDarw:(BOOL)isIncrease ClickEvent:(UleRedpacketRainClickBlock)clickBlock
{
    __weak typeof(self) weakself=self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UleRedPacketRainManager * manager=[UleRedPacketRainManager instance];
        manager.runEnvironment=isprd;
        manager.isIncreaseCashDraw=isIncrease;
        manager.clickBlock =[clickBlock copy];
        manager.redPacketRainModel=model;
//        [manager showRedRainView];
        [[weakself instance] startRequestGetAward];
    });
}

+ (void)startRecordLogWithEventName:(NSString *)eventName environment:(BOOL)isprd withModel:(UleRedPacketRainModel *)redModel{
    UleRedPacketRainManager * manager=[UleRedPacketRainManager instance];
    manager.runEnvironment=isprd;
    [manager recordLogWithEventName:eventName withModel:redModel];
}

- (void) showRedRainView{
    __weak typeof(self) weakself=self;
    NSArray * winners=[WinnersList componentsSeparatedByString:@"|"];
    [UleRedPacketRain showRedPacketReinWithWinners:winners packetPreShowEnd:^{
        [weakself recordLogWithEventName:UleRedpacketRain withModel:weakself.redPacketRainModel];
    } packetRainFinished:^(UleRedPacketRain *obj, id info) {
        weakself.packetRain=obj;
        NSInteger clickNum=[info integerValue];
        if (clickNum>3) {
            [weakself.packetRain addSubview:weakself.activityIndicatorView];
            [weakself startRequestGetAward];
        }else{
            [weakself.packetRain hiddenRedPacketRain];
            [weakself showGetNoneAward];
        }
    } redpacketRainClickLog:^{
        [weakself recordLogWithEventName:UleRedpacketJoin withModel:weakself.redPacketRainModel];
    }];
}

+ (void)hiddenUleRdPacketRain{
    UleRedPacketRainManager * manager=[UleRedPacketRainManager instance];
    if (manager.packetRain) {
        [manager.packetRain removeFromSuperview];
        manager.packetRain=nil;
    }
    if (manager.awardView) {
        [manager.awardView removeFromSuperview];
        manager.awardView=nil;
    }
}

- (void)startRequestGetAward{
//    [self.activityIndicatorView startAnimating];
    NSMutableDictionary * params=[[NSMutableDictionary alloc] init];
    [params setObject:self.redPacketRainModel.activityCode.length>0?self.redPacketRainModel.activityCode:@"" forKey:@"activityCode"];
    NSData *data = [self.redPacketRainModel.userId dataUsingEncoding:NSUTF8StringEncoding];
    NSData *IV2Data = [SECRET_IV dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [UleRedpacketSecurityKit RD_EncryptWithData:data WithM1:SECRET_KEY withM2:[IV2Data bytes]];
    NSString *en_str =[NSData RD_encode:m_data];
    [params setObject:en_str.length>0?en_str:@"" forKey:@"userOnlyId"];
    [params setObject:self.redPacketRainModel.channel.length>0?self.redPacketRainModel.channel:@"" forKey:@"channel"];
    [params setObject:self.redPacketRainModel.deviceId.length>0?self.redPacketRainModel.deviceId:@"" forKey:@"deviceId"];
    [params setObject:self.redPacketRainModel.fieldId.length>0?self.redPacketRainModel.fieldId:@"" forKey:@"fieldId"];
    
    NSString * signStr=[NSString stringWithFormat:@"%@%@%@%@%@",self.redPacketRainModel.activityCode,self.redPacketRainModel.fieldId,self.redPacketRainModel.channel,self.redPacketRainModel.userId,self.redPacketRainModel.deviceId];
    NSMutableDictionary * headDic=[[NSMutableDictionary alloc] init];
    if (signStr.length>0) {
        NSString *sha1 = [UleRedpacketSecurityKit RD_EncodeHash:SECRET_IV text:signStr];
        [headDic setObject:sha1 forKey:@"sign"];
    }
    NSString * host=self.runEnvironment==YES?kHost:kHostBeta;
    NSString * apiName=klotterydrawApi;
    RedRainRequest * requset=[RedRainRequest initWithApiName:apiName rootUrl:host params:params head:headDic];
    __weak typeof(self) weakself=self;
    [self.client beginRequest:requset onResponse:^(id obj, NSDictionary *dic) {
        NSLog(@"===finish===");
//        [weakself.activityIndicatorView stopAnimating];
        [weakself.packetRain hiddenRedPacketRain];
        weakself.packetRain=nil;
        [weakself parseDrawAwardData:dic];
    } onError:^(id obj, NSError *error) {
        NSLog(@"===Error==");
//        [weakself.activityIndicatorView stopAnimating];
        [weakself.packetRain hiddenRedPacketRain];
        weakself.packetRain=nil;
        [weakself showGetNoneAward];
    }];
}



- (void)recordLogWithEventName:(NSString *)eventName withModel:(UleRedPacketRainModel *)redModel{
    
    NSMutableDictionary * params=[[NSMutableDictionary alloc] init];
    [params setObject:redModel.activityCode.length>0?redModel.activityCode:@"" forKey:@"activityCode"];
    [params setObject:redModel.userId.length>0?redModel.userId:@"" forKey:@"userID"];
    [params setObject:redModel.channel.length>0?redModel.channel:@"" forKey:@"channel"];
    [params setObject:redModel.deviceId.length>0?redModel.deviceId:@"" forKey:@"deviceId"];
    [params setObject:redModel.fieldId.length>0?redModel.fieldId:@"" forKey:@"fieldId"];
    [params setObject:eventName.length>0?eventName:@"" forKey:@"eventName"];
    [params setObject:redModel.province.length>0?redModel.province:@"" forKey:@"province"];
    [params setObject:redModel.orgCode.length>0?redModel.orgCode:@"" forKey:@"orgCode"];
    
    NSString * signStr=[NSString stringWithFormat:@"%@%@%@",eventName,redModel.deviceId,redModel.channel];
    NSMutableDictionary * headDic=[[NSMutableDictionary alloc] init];
    if (signStr.length>0) {
        NSString *sha1 = [UleRedpacketSecurityKit RD_EncodeHash:SECRET_IV text:signStr];
        [headDic setObject:sha1 forKey:@"sign"];
    }
    NSString * host=self.runEnvironment==YES?kTrackHost:kTrackHostBeta;
    RedRainRequest * request=[RedRainRequest initWithApiName:ktrackLogApi rootUrl:host params:params head:headDic];
    [self.client beginRequest:request onResponse:^(id obj, NSDictionary *dic) {
        NSLog(@"Log=%@",dic);
    } onError:^(id obj, NSError *error) {
        
    }];
}

#pragma mark - <parse data>
- (void)parseDrawAwardData:(NSDictionary *)dic{
    if (self.isIncreaseCashDraw) {
        //增加次数
        [US_UserUtility increaseLimitForRedPacket];
    }
    if (dic) {
        NSDictionary * content=dic[@"content"];
        NSMutableArray * models=[[NSMutableArray alloc] init];
        NSArray * prizeInfos=content[@"prizeInfos"];
        NSString * flags=[NSString stringWithFormat:@"%@",dic[@"shareFlag"]];
        BOOL isShowShareBtn=YES;
        if (flags&&[flags isKindOfClass:[NSString class]]&&[flags isEqualToString:@"0"]) {
            isShowShareBtn=NO;
        }
        for (int i=0; i<prizeInfos.count; i++) {
            NSDictionary * dic=prizeInfos[i];
            UleAwardCellModel * cellModel=[[UleAwardCellModel alloc] init];
            NSString * money=[NSString stringWithFormat:@"%@",dic[@"prizeMoney"]];
            cellModel.money=[self transforMoney:money];
            cellModel.awardTypeStr=dic[@"prizeType"];
            cellModel.limitPurchase=dic[@"prizeDesc"];
            NSString * limitMoney=dic[@"fullcutAmountLimit"]?[NSString stringWithFormat:@"%@",dic[@"fullcutAmountLimit"]]:@"";
            cellModel.limitMoney=[self transforMoney:limitMoney];
            NSString * startTime=dic[@"expiredStartDate"];
            NSString * endTime=dic[@"expiredEndDate"];
            
            NSArray *filterArr = @[@"奖金", @"奖励金", @"赏金", @"现金"];
            if ([filterArr containsObject:[NSString isNullToString:cellModel.awardTypeStr]]) {
                cellModel.awardType=UleAwardCashType;
                cellModel.expiryDate=endTime.length>0?endTime:@"";
            }else {
                cellModel.awardType=UleAwardCouponType;
                cellModel.expiryDate=(startTime.length>0&&endTime.length>0)?[NSString stringWithFormat:@"%@至%@",startTime,endTime]:@"";
            }
            cellModel.activityDate=self.redPacketRainModel.activityDate;
            cellModel.wishes=self.redPacketRainModel.wishes;
            [models addObject:cellModel];
        }
        if (models.count<=0) {
            UleAwardCellModel * cellModel=[[UleAwardCellModel alloc] init];
            cellModel.awardType=UleAwardNoneType;
            cellModel.activityDate=self.redPacketRainModel.activityDate;
            cellModel.wishes=self.redPacketRainModel.wishes;
            [models addObject:cellModel];
        }
        __weak typeof(self) weakself=self;
        self.awardView=[UleRedPacketRainAwardView showAwardViewWithDataArray:models channel:self.redPacketRainModel.channel isShowShareBtn:isShowShareBtn clickBlock:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
            if (event == UleRedpacketRainEventShare) {
                [weakself recordLogWithEventName:UleRedpacketShare withModel:weakself.redPacketRainModel];
            }
            if (weakself.clickBlock) {
                weakself.clickBlock(event,models);
            }
        }];
        
        
    }else{
        [self showGetNoneAward];
    }
}

//如果有小数点，就保留两位，没有小数点，就去整数。
- (NSString *)transforMoney:(NSString *)moneyStr{
    NSString * result;
    if([moneyStr rangeOfString:@"."].location!=NSNotFound){
        result=[NSString stringWithFormat:@"%.2f",[moneyStr doubleValue]];
    }else{
        result=moneyStr;
    }
    return result;
}


- (void)showGetNoneAward{
    UleAwardCellModel * cellmodel=[[UleAwardCellModel alloc] init];
    cellmodel.awardType=UleAwardNoneType;
    cellmodel.activityDate=self.redPacketRainModel.activityDate;
    cellmodel.wishes=self.redPacketRainModel.wishes;
    __weak typeof(self) weakself=self;
    self.awardView =[UleRedPacketRainAwardView showAwardViewWithDataArray:@[cellmodel] channel:self.redPacketRainModel.channel isShowShareBtn:NO clickBlock:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
        if (weakself.clickBlock) {
            weakself.clickBlock(event,nil);
        }
    }];
}

#pragma mark - <setter and getter>

- (RedRainNetWorkClient *)client{
    if (!_client) {
        _client=[[RedRainNetWorkClient alloc] init];
    }
    return _client;
}

- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.hidesWhenStopped = NO;
        _activityIndicatorView.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2.0, ([UIScreen mainScreen].bounds.size.height-100)/2.0, 100, 100);
    }
    return _activityIndicatorView;
}

@end
