//
//  US_ShareRecordModel.m
//  u_store
//
//  Created by 王昆 on 16/4/1.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "US_ShareRecordModel.h"

@implementation ShareDetailInfo


@end

@implementation ShareDetailData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [ShareDetailInfo class]
             };
}

@end


@implementation US_ShareRecordModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShareDetailData class]
             };
}

@end
