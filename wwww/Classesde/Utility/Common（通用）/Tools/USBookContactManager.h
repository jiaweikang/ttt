//
//  USBookContactManager.h
//  u_store
//
//  Created by jiangxintong on 2019/1/23.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USBookContactManager : NSObject

+ (instancetype)sharedInstance;
- (void)getCallback:(void(^)(NSDictionary *params))callback;

@end
