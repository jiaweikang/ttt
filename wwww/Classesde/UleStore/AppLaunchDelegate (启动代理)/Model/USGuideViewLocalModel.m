//
//  USGuideViewLocalModel.m
//  UleStoreApp
//
//  Created by xulei on 2020/1/7.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "USGuideViewLocalModel.h"

@implementation USGuideViewLocalInfo
MJExtensionCodingImplementation

@end

@implementation USGuideViewLocalModel
MJExtensionCodingImplementation

+(NSDictionary *)mj_objectClassInArray{
    return @{@"guideDataArray":@"USGuideViewLocalInfo"};
}
@end
