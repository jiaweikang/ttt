//
//  XiaoNengChat.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "XiaoNengChat.h"

@interface XiaoNengChat ()

@end

@implementation XiaoNengChat

- (void)viewDidLoad {
    //先修改小能链接再调用父类加载
    NSString *chatUrlStr = [NSString isNullToString:[self.m_Params objectForKey:@"key"]];
    if (chatUrlStr.length>0) {
        chatUrlStr=[NSString stringWithFormat:@"%@?userName=%@&mobile=%@", chatUrlStr, [US_UserUtility sharedLogin].m_userName, [US_UserUtility sharedLogin].m_mobileNumber];
        [self.m_Params setObject:chatUrlStr forKey:@"key"];
    }
    
    [super viewDidLoad];
}


@end
