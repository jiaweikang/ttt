//
//  FeaturedModel_UserCenter.m
//  u_store
//
//  Created by mac_chen on 2019/4/22.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "FeaturedModel_UserCenter.h"
#import <MJExtension/MJExtension.h>

@implementation FeaturedModel_UserCenterIndex
MJExtensionCodingImplementation
//+ (NSDictionary *)modelCustomPropertyMapper{
//    return @{@"_id":@"id"};
//}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"_id":@"id"};
}

@end

@implementation FeaturedModel_UserCenter
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    
//    return @{@"indexInfo" : [FeaturedModel_UserCenterIndex class]};
//}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"indexInfo":@"FeaturedModel_UserCenterIndex"};
}

@end
