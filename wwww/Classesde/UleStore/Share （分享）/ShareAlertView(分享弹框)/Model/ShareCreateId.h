//
//  ShareCreateId.h
//  u_store
//
//  Created by ule_aofeilin on 15/11/4.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
//小程序
@interface ShareMiniWxInfo : NSObject
@property (nonatomic, copy) NSString *path;//小程序地址
@property (nonatomic, copy) NSString *originalId;//小程序id
@end

@interface ShareCreateResult : NSObject
@property (nonatomic, copy) NSString *attribute1;//标题
@property (nonatomic, copy) NSString *attribute2;//副标题

@end

@interface ShareCreateData : NSObject

@property (nonatomic, strong)       NSNumber *shareId;
@property (nonatomic, copy)         NSString *shareUrl3;
@property (nonatomic, strong)       NSMutableArray *sectionList;
@property (nonatomic, copy)         NSString *shareUrl4; // add in 20170725
@property (nonatomic, copy)         NSString *favsListingStr;//分享弹框上方的内容 20191205
@property (nonatomic, copy)         NSString *additionalShareInfo;
@property (nonatomic, copy)         NSString *shareCommissionLongText;
//分享按钮按顺序动态配置：微信##朋友圈##多图分享##二维码##小程序##复制链接##店铺海报##活动海报分享##软文分享 0##1##2##3##4##5##6##7##8
@property (nonatomic, copy)         NSString *shareOptions;
//首页精选商品 使用此分享方式配置
@property (nonatomic, copy)         NSString *shareOptionsIndex;
@property (nonatomic, copy)         NSString * imageBanner; //海报分享中间横幅
@property (nonatomic, copy)         NSString * articleUrl;//软文分享跳转链接
@property (nonatomic, strong)       ShareMiniWxInfo   *miniWxShareInfo;
@end

@interface ShareCreateId : NSObject
@property (nonatomic, copy) NSString            *returnCode;
@property (nonatomic, copy) NSString            *returnMessage;
@property (nonatomic, strong) ShareCreateData   *data;

@end

