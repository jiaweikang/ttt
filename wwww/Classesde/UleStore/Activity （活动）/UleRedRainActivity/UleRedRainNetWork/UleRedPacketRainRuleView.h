//
//  UleRedPacketRainRuleView.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/2.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UleRedPacketRainRuleView : UIView

/**
 显示规则页面

 @param rootView 父视图页面
 @param htmlpath 规则html链接地址
 */
+ (void)showRuleViewAtRootView:(UIView *)rootView ruleHtmlPath:(NSString *)htmlpath;
@end
