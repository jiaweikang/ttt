//
//  US_GoodsCatergory.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsCatergory.h"
#import <MJExtension/MJExtension.h>

@implementation CategroyItem
MJExtensionCodingImplementation

@end

@implementation US_GoodsCatergoryData
MJExtensionCodingImplementation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"categoryItems" : [CategroyItem class]};
}

@end

@implementation US_GoodsCatergory
MJExtensionCodingImplementation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_GoodsCatergoryData class]};
}
@end
