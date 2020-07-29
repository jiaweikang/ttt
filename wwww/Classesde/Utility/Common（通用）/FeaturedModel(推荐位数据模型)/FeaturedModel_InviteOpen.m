//
//  FeaturedModel_InviteOpen.m
//  UleStoreApp
//
//  Created by xulei on 2019/12/5.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "FeaturedModel_InviteOpen.h"

@implementation FeaturedModel_InviteOpenIndex

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"};
}

@end

@implementation FeaturedModel_InviteOpen

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"indexInfo" : [FeaturedModel_InviteOpenIndex class]};
}

@end
