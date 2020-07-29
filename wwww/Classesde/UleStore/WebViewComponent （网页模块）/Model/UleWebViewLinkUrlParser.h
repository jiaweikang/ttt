//
//  UleWebViewLinkUrlParser.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDetailViewController.h"
#import "USWebDetailHeader.h"
#import "USShareView.h"
NS_ASSUME_NONNULL_BEGIN

@interface UleWebViewLinkUrlParser : NSObject
@property (nonatomic, weak) WebDetailViewController * webViewController;
- (BOOL)action_popView:(NSString *)linkUrl;

- (BOOL)action_gotoHomeViewController:(NSString *)linkUrl;

- (BOOL)action_gotoVipManager:(NSString *)linkUrl;

- (BOOL)action_share:(NSString *)linkUrl;

- (BOOL)action_ylxdnewShare:(NSString *)linkUrl;

- (BOOL)action_updataImage:(NSString *)linkUrl;

- (BOOL)action_withdrawclaim:(NSString *)linkUrl;

- (BOOL)action_invitefriends:(NSString *)linkUrl;

- (BOOL)action_jumpVC:(NSString *)linkUrl;

- (BOOL)action_saveFavorite:(NSString *)linkUrl;

- (BOOL)action_inviteTeam:(NSString *)linkUrl;

- (BOOL)action_newDrawLottery:(NSString *)linkUrl;

- (BOOL)action_showRedpacketRain:(NSString *)linkUrl;

- (BOOL)shareWithShareInfo:(NSString *)shareInfo;

- (BOOL)webShareWithShareModel:(USShareModel *)shareModel;
@end

NS_ASSUME_NONNULL_END
