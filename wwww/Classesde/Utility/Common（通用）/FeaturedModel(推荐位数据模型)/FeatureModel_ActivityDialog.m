//
//  FeatureModel_ActivityDialog.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_ActivityDialog.h"

@implementation ActivityDialogIndexInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"_id":@"id"};
}

@end

@implementation FeatureModel_ActivityDialog
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"indexInfo" : [ActivityDialogIndexInfo class]};
}

@end
