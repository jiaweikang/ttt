//
//  ProtocolAlertView.h
//  u_store
//
//  Created by jiangxintong on 2018/12/17.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProtocolAlertConfirmBlock)(void);

//注册成功进入首页的弹框
@interface ProtocolAlertView : UIView

+ (ProtocolAlertView *)protocolAlertView:(ProtocolAlertConfirmBlock)confirmBlock;

@end

