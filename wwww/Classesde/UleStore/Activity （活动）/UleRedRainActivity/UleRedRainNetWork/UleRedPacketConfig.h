//
//  UleRedPacketConfig.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#ifndef UleRedPacketConfig_h
#define UleRedPacketConfig_h

#define LoadBundleImage(imageName)      [UIImage imageNamed:[@"UleRedPacketRainResource.bundle" stringByAppendingPathComponent:imageName]]

//#define kStatusBarH   CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define  HORIZONTA(x)  ((SCREEN_WIDTH)/320.0 *(x))

#define  HORIZONTA750(x)  ((SCREEN_WIDTH)/750.0 *(x))

#define UleRedPacketRainChannel @"600000"//红包雨活动渠道code 邮乐小店600000

#define UleRedpacketRainNotity @"RedPacketsNotify"  //设置提醒人数
#define UleRedpacketRain     @"RedPacketsRain"      //点击人数（点击是进到红包雨里就算）
#define UleRedpacketShare    @"RedPacketsShare"     //分享人数 （点击过分享的）
#define UleRedpacketJoin    @"RedPacketsJoin"       //参与活动人数（点中过红包）
//域名
#define kHost            @"https://service.ule.com/"
#define kHostBeta        @"https://service.beta.ule.com/"

#define kTrackHost       @"https://track.ule.com/"
#define kTrackHostBeta   @"https://track.beta.ule.com/"

//接口名
#define klotterydrawApi      @"appact/redenvelopes/lottry"

#define ktrackLogApi     @"apiLog/log/act.do"


//加密秘钥和向量
#define SECRET_KEY    @"32f4Klfm3PoBYt68"
#define SECRET_IV     @"kjHg76VbC09Ousww"

//活动规则链接，每个客户端自己配置
#define kRulePath     @"https://www.ule.com/event/2018/0805/rule_xd.html"





#endif /* UleRedPacketConfig_h */
