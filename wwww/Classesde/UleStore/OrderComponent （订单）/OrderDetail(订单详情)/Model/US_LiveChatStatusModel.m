//
//  US_LiveChatStatusModel.m
//  UleStoreApp
//
//  Created by mac_chen on 2020/3/24.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_LiveChatStatusModel.h"

@implementation US_LiveChatStatusInfo

@end

@implementation US_LiveChatStatusModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_LiveChatStatusInfo class]};
}

@end
