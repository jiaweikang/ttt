//
//  OrderCellButton.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/5.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "OrderCellButton.h"

@implementation OrderCellButton

- (instancetype)init{
    self = [super init];
    if (self) {
        self.titleLabel.font=[UIFont systemFontOfSize:13];
        self.tintColor=[UIColor convertHexToRGB:kLightTextColor];
        self.layer.borderWidth=0.5;
        [self setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor convertHexToRGB:kDarkTextColor] forState:UIControlStateNormal];
    }
    return self;
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)setButtonState:(OrderButtonState)buttonState{
    _buttonState=buttonState;
    self.hidden=NO;
    [self setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor convertHexToRGB:kDarkTextColor] forState:UIControlStateNormal];
    switch (buttonState) {
        case OrderButtonStateCanPay:{
            [self setTitle:@"去支付" forState:UIControlStateNormal];
            [self setBackgroundImage:[self createImageWithColor:kNavBarBackColor] forState:UIControlStateNormal];
            self.tintColor=[UIColor clearColor];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateCanRecive:{
            [self setTitle:@"确认签收" forState:UIControlStateNormal];
            [self setBackgroundImage:[self createImageWithColor:kNavBarBackColor] forState:UIControlStateNormal];
            self.tintColor=[UIColor clearColor];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateCanComment:{
            [self setTitle:@"去评论" forState:UIControlStateNormal];
            [self setBackgroundImage:[self createImageWithColor:kNavBarBackColor] forState:UIControlStateNormal];
            self.tintColor=[UIColor clearColor];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateCanCanCel:{
            [self setTitle:@"取消订单" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateCanDelete:{
            [self setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateCanQueryProcess:{
            [self setTitle:@"取消进度" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateBuyAgain:{
            [self setTitle:@"再次购买" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateLogistic:{
            [self setTitle:@"查看物流" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateGroupDetail:{
            [self setTitle:@"拼团详情" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateReturnGoods:{
            [self setTitle:@"退换货" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateSendout:{
            [self setTitle:@"发货" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateRemindDelevery:{
            [self setTitle:@"提醒发货" forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateRemindDeleveryDisable:{
            [self setTitle:@"提醒发货" forState:UIControlStateNormal];
            [self setBackgroundImage:[self createImageWithColor:[UIColor convertHexToRGB:@"f2f2f2"]] forState:UIControlStateNormal];
        }
            break;
        case OrderButtonStateHidden:{
            self.hidden=YES;
        }
            break;
        default:
            break;
    }
}

@end
