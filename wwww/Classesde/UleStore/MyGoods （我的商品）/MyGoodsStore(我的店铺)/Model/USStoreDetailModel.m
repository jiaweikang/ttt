//
//  USStoreDetailModel.m
//  u_store
//
//  Created by jiangxintong on 2019/1/24.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USStoreDetailModel.h"

@implementation PromotionListItem
MJExtensionCodingImplementation

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"_id":@"id"
             };
}

@end

@implementation USStoreDetailListingItem
MJExtensionCodingImplementation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"promotionList" : [PromotionListItem class]};
}


@end



@implementation USStoreDetailInfo
MJExtensionCodingImplementation

@end



@implementation USStoreDetailData
MJExtensionCodingImplementation

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"Listings" : [USStoreDetailListingItem class],
             @"storeInfo": [USStoreDetailInfo class],
             };
}


@end



@implementation USStoreDetailModel
MJExtensionCodingImplementation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [USStoreDetailData class]};
}

@end
