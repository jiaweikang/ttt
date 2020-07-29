//
//  InviteMemberData.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterMemberData.h"
@implementation InviterInfo

@end


@implementation InviterData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [InviterInfo class]
             };
}
@end


@implementation InviterMemberData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [InviterData class]
             };
}
@end
