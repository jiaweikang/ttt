//
//  RedRainNetWorkClient.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/30.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedRainRequest.h"

typedef void(^UleResponseObject)(id obj,NSDictionary * dic);
typedef void(^UleErrorObject)(id obj,NSError * error);
@interface RedRainNetWorkClient : NSObject

- (void) beginRequest:(RedRainRequest *)request onResponse:(UleResponseObject)success onError:(UleErrorObject)error;

@end
