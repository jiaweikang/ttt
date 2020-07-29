//
//  USMemberListData.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "USMemberListData.h"
@implementation US_MemberInfo


@end

@implementation USMemberListData_data
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"retLst" : [US_MemberInfo class]
             };
}
@end

@implementation USMemberListData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [USMemberListData_data class]
             };
}
@end
