//
//  USShareModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishBlock)(BOOL success);

typedef void(^SuccessBlock)(id responseObj);
typedef void(^FailedBlock)(NSError * error);

@interface USShareModel : NSObject
@property (nonatomic, copy) NSString * shareTitle;//分享title
@property (nonatomic, copy) NSString * shareContent;//分享内容
@property (nonatomic, copy) NSString * shareUrl;//分享链接
@property (nonatomic, copy) NSString * listId;
@property (nonatomic, copy) NSString * listName;
@property (nonatomic, strong) NSMutableArray * listImage;
@property (nonatomic, strong) NSMutableArray * listImage2;//商品广告二维码分享 运营额外配置的图片
@property (nonatomic, copy) NSString * sharePrice;//
@property (nonatomic, copy) NSString * marketPrice;//市场价
@property (nonatomic, copy) NSString * shareCommission;//佣金
@property (nonatomic, copy) NSString * shareImageUrl;//专供分享微信和朋友圈用 没有取listImage的第一张
@property (nonatomic, copy) NSString *favsListingStr;//分享弹框上方文案
@property (nonatomic, copy) NSString *jsFunction;//分享成功回调
@property (nonatomic, copy) NSString *isOldShareMode;//1-旧分享（微信好友、朋友圈）  0-新分享（带多图）
@property (nonatomic, copy) NSString *gameFlag;//1-游戏分享
@property (nonatomic, copy) NSString *ruleDescription;//规则描述 20191218
@property (nonatomic, copy) NSString *posterImageUrl;//活动海报底图
@property (nonatomic, copy) NSString *posterTips;//活动海报提示语
@property (nonatomic, copy) NSString *imageBanner; //海报分享中间横幅
@property (nonatomic, copy) NSString *articleUrl; //软文分享跳转链接
@property (nonatomic, copy) NSString *zoneId;//分销商品的专区id
//日志
@property (nonatomic, copy) NSString *logPageName;//页面名称
@property (nonatomic, copy) NSString *logShareFrom;//分享来源
@property (nonatomic, copy) NSString *tel;// 日志点击的tel值
@property (nonatomic, copy) NSString *srcid;

@property (nonatomic, copy) NSString *shareFrom;
@property (nonatomic, copy) NSString *shareChannel;
@property (nonatomic, assign) BOOL isNeedSaveQRImage;
//@property (nonatomic, copy) NSString * shareType;//1111
@property (nonatomic, copy) NSString * messageCopyStr;
@property (nonatomic, strong) NSNumber *insuranceFlag;//1-微保分享
@property (nonatomic, copy) NSString * additionalShareInfo;
@property (nonatomic, copy) NSString *shareCommissionLongText;
@property (nonatomic, strong) NSData * shareImageData;//单图分享

//小程序
@property (nonatomic, copy) NSString *WXMiniProgram_pageUrl;//兼容低版本的网页链接
@property (nonatomic, copy) NSString *WXMiniProgram_path;//页面路径
@property (nonatomic, copy) NSString *WXMiniProgram_OriginalId;//小程序id
@property (nonatomic, copy) NSString *WXMiniProgram_Type;//分享小程序类型1正式版，0体验版
@property (nonatomic, copy) NSString *WXMiniProgram_Title;//小程序分享标题
@property (nonatomic, copy) NSString *WXMiniProgram_DialogName;//弹框中小程序标题

//分享按钮按顺序动态配置：微信##朋友圈##多图分享##二维码##小程序##复制链接##店铺海报##活动海报分享##软文分享 0##1##2##3##4##5##6##7##8
@property (nonatomic, copy) NSString *shareOptions;
@property (nonatomic, assign) BOOL isHome_jinxuan_GoodsShare;//首页精选分享

+ (instancetype) initWithJsonStr:(NSString *)jsonStr;


- (void)startRequestShareInfor:(SuccessBlock) success failed:(FailedBlock)failed;

- (void)startRequestMultiPicInfo:(SuccessBlock) success failed:(FailedBlock)failed;

- (void)startRequestInsuranceShareInfor:(SuccessBlock)success failed:(FailedBlock)failed;

- (void)startRequestFenxiaoShareInfo:(SuccessBlock)success failed:(FailedBlock)failed;

+ (NSString *)tranforCommitionStr:(NSString *)commintion;
@end

NS_ASSUME_NONNULL_END
