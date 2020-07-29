//
//  RedRainRequest.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/30.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "RedRainRequest.h"

@implementation RedRainRequest
+ (instancetype)initWithApiName:(NSString *)apiNam
                        rootUrl:(NSString *)rootUrl
                         params:(NSMutableDictionary *)params
                           head:(NSMutableDictionary *)headParams;{
    RedRainRequest * request= [[RedRainRequest alloc] init];
    if (self) {
        request.url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rootUrl,apiNam]];
        request.params=params;
        request.hparams=headParams;
    }
    return request;
}
@end
