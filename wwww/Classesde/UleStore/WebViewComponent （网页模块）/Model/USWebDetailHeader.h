//
//  USWebDetailHeader.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#ifndef USWebDetailHeader_h
#define USWebDetailHeader_h

#import "UleWebViewApiBridge.h"
#import "UleWebProgressLayer.h"
#import "USCookieHelper.h"
#import <UleReachability.h>
#import "UleWebViewLinkUrlParser.h"

static NSString *const ule_buy            =     @"ulebuy://";
static NSString *const ule_Mobile         =     @"ulemobile://";

static NSString *const isNeedSearch       =     @"isSearch";
static NSString *const uleNeedNavBar      =     @"uleneednativetitle=true";
static NSString *const uleNotNeedNavBar   =     @"uleneednativetitle=false";

static NSString *const US_orderPaySuccess =     @"action&&jsOrderSuccess::1";//支付成功
static NSString *const US_saveFavorite    =     @"action$$addtofavorites";
static NSString *const uleNeedShare       =     @"needShare=true";
static NSString *const uleNotNeedShare    =     @"needShare=false";



static NSString *const US_updateImage     =     @"action&&takephoto&&&&";
static NSString *const US_withdrawClaim   =     @"action&&withdrawclaim&&&&";//订单审核撤销申请成功
static NSString *const US_inviteFriends   =     @"action&&invitefriends";//邀请好友开店
static NSString *const US_inviteTeam      =     @"invitefriend";//战队邀请好友
static NSString *const US_popView         =     @"ulepopview";
static NSString *const US_popToFatherView =     @"ulepoptofatherview";//和US_popView 相同
static NSString *const US_gotoHomeView    =     @"ulehomepage";
static NSString *const US_vipchonse       =     @"vipchoose";
static NSString *const US_share           =     @"uleshare";
static NSString *const US_ylxdShare       =     @"ylxdshare";
static NSString *const US_newDrawLottery  =     @"newdrawcashlottery";//type=1 红包雨结果页 type=2现金抽奖结果页
static NSString *const US_showRedpacketRain =   @"showredpacketrain";//下红包雨
static NSString *const US_jumpVC          =     @"action&&";
static NSString *const US_ResignActive    =     @"uleAppWillResignActive()";

#define kUleWebActionDic  @{US_popView:@"action_popView:",\
US_popToFatherView:@"action_popView:",\
US_gotoHomeView:@"action_gotoHomeViewController:",\
US_vipchonse:@"action_gotoVipManager:",\
US_share:@"action_share:",\
US_ylxdShare:@"action_ylxdnewShare:",\
US_updateImage:@"action_updataImage:",\
US_withdrawClaim:@"action_withdrawclaim:",\
US_inviteFriends:@"action_invitefriends:",\
US_jumpVC:@"action_jumpVC:",\
US_saveFavorite:@"action_saveFavorite:",\
US_inviteTeam:@"action_inviteTeam:",\
US_newDrawLottery:@"action_newDrawLottery:",\
US_showRedpacketRain:@"action_showRedpacketRain:",\
}\

#endif /* USWebDetailHeader_h */
