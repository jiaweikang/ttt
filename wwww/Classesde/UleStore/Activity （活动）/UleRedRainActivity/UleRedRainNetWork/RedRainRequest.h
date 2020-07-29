//
//  RedRainRequest.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/30.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedRainRequest : NSObject
@property (nonatomic, copy) NSURL * url;
@property (nonatomic, strong) NSMutableDictionary * params;
@property (nonatomic, strong) NSMutableDictionary * hparams;

+ (instancetype)initWithApiName:(NSString *)apiNam
                        rootUrl:(NSString *)rootUrl
                         params:(NSMutableDictionary *)params
                           head:(NSMutableDictionary *)headParams;
@end
