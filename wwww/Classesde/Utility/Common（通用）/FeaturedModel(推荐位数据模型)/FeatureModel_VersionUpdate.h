//
//  FeatureModel_VersionUpdate.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionIndexInfo : NSObject

@property(nonatomic,copy) NSString *checkListingIds;
@property(nonatomic,copy) NSString *link;
@property(nonatomic,copy) NSString *checkPrice;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,copy) NSString *_id;
@property(nonatomic,copy) NSString *checkStoreIds;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *sectionId;
@property(nonatomic,copy) NSString *priority;
@property(nonatomic,copy) NSString *key;
@property(nonatomic,copy) NSString *attribute1;//最新版本号
@property(nonatomic,copy) NSString *attribute2;//更新提示语
@property(nonatomic,copy) NSString *attribute3;//appStore下载地址
@property(nonatomic,copy) NSString *attribute4;//是否强制更新
@property(nonatomic,copy) NSString *attribute5;
@property(nonatomic,copy) NSString *attribute6;// 新闻
@property(nonatomic,copy) NSString *attribute7;//最新的强制更新版本
@property(nonatomic,copy) NSString *attribute9;//预览链接是否自己拼 1-请求接口 0/""-自己拼
@property(nonatomic,copy) NSString *beltflag;//1：展示    0：不展示   默认不展示
@property(nonatomic,copy) NSString *attribute10;
@property(nonatomic,copy) NSString *attribute11;//首页爽十一弹框跳转链接
@property(nonatomic,copy) NSString *attribute12;//首页爽十一弹框跳转时间段
@property(nonatomic,copy) NSString *attribute13;//域名限制，（多个域名用“#”分割）
@property(nonatomic,copy) NSString *commission_title;//一品多价佣金显示文案
@property(nonatomic,copy) NSString *poststore_my_update; //是否需要请求个人中心接口
@property(nonatomic,copy) NSString *index_listings_flag;//首页商品来源 1-千人千面接口   0-正常cdn接口
@end

@interface FeatureModel_VersionUpdate : NSObject
@property(nonatomic,copy) NSString *total;
@property(nonatomic,copy) NSString *returnCode;
@property(nonatomic,copy) NSString *returnMessage;
@property(nonatomic,strong) NSMutableArray *indexInfo;
@end

NS_ASSUME_NONNULL_END
