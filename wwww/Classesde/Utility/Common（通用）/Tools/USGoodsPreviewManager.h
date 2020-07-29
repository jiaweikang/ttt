//
//  USGoodsPreviewManager.h
//  u_store
//
//  Created by xulei on 2018/8/28.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewController.h"
@interface USGoodsPreviewManager : NSObject

+ (instancetype)sharedManager;

-(void)pushToPreviewControllerWithListId:(NSString *)listid andSearchKeyword:(NSString *)keyword andPreviewType:(NSString *)pType andHudVC:(UleBaseViewController *)currentVC;

@end
