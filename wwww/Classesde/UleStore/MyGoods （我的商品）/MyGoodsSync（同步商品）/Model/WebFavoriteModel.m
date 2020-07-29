//
//  WebFavoriteModel.m
//  u_store
//
//  Created by xstones on 2018/3/20.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "WebFavoriteModel.h"

@implementation WebFavoriteList

@end

@implementation WebFavoriteData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"favsListingListInfo" : [WebFavoriteList class],
             };
}
@end

@implementation WebFavoriteModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [WebFavoriteData class],
             };
}

@end
