//
//  US_EnterpriseDataModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseDataModel.h"

@implementation PromotionList
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}

@end

@implementation SaleRange


@end


@implementation US_EnterpriseRecommendList
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"saleRange":[SaleRange class],
             @"promotionList":[PromotionList class]
             };
}

@end

@implementation US_EnterpriseRecommendData

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"recommendDaily":[US_EnterpriseRecommendList class]};
}

@end

@implementation US_EnterpriseRecommend

@end


@implementation US_EnterpriseBannerData

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}

- (id)copyWithZone:(NSZone *)zone
{
    US_EnterpriseBannerData *data = [[US_EnterpriseBannerData allocWithZone:zone] init];
    data.customAtt_title=self.customAtt_title;
    data.log_title=self.log_title;
    data.link_title=self.link_title;
    data.android_action=self.android_action;
    data._id=self._id;
    data.moduleKey=self.moduleKey;
    data.max_version=self.max_version;
    data.orgunitId=self.orgunitId;
    data.imageList=self.imageList;
    data.imageList=[[NSArray alloc]initWithArray:self.imageList copyItems:YES];
    data.ios_action=self.ios_action;
    data.salePrice=self.salePrice;
    data.sales_volume=self.sales_volume;
    data.orgType=self.orgType;
    data.startTime=self.startTime;
    data.min_version=self.min_version;
    data.titlecolor=self.titlecolor;
    data.customAtt_link=self.customAtt_link;
    data.customDesc=self.customDesc;
    data.groupsort=self.groupsort;
    data.priority=self.priority;
    data.tag_imgs=[[NSArray alloc]initWithArray:self.tag_imgs copyItems:YES];
    data.back_image=self.back_image;
    data.delFlag=self.delFlag;
    data.endTime=self.endTime;
    data.related_module_key=self.related_module_key;
    data.customTitle=self.customTitle;
    data.updateTime=self.updateTime;
    data.customImgUrl=self.customImgUrl;
    data.wh_rate=self.wh_rate;
    data.link=self.link;
    data.listingId=self.listingId;
    data.data=self.data;
    data.commission=self.commission;
    data.device_type=self.device_type;
    data.backImage=self.backImage;
    data.createTime=self.createTime;
    data.moduleType=self.moduleType;
    data.totalSold=self.totalSold;
    data.moduleId=self.moduleId;
    data.title=self.title;
    data.groupid=self.groupid;
    data.moduleName=self.moduleName;
    return data;
}

@end

@implementation US_EnterpriseBanner

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data":[US_EnterpriseBannerData class]};
}

@end
