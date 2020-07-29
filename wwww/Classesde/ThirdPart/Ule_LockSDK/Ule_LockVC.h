//
//  Ule_LockVC.h
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "UleBaseViewController.h"
#import "Ule_LockConst.h"
#import "Ule_LockIndicator.h"
#import "Ule_LockPasswordFile.h"
#import "Ule_LockView.h"

@interface Ule_LockVC : UleBaseViewController<Ule_LockViewDelegate>

/** 
 *  界面移除的回调
 */
@property (copy, nonatomic) void (^didRemovedBlock)(void);

/**
 *  当前类型
 */
@property (nonatomic,assign) UleLockVCType nLockViewType;

/**
 *  是否已经加载
 */
@property (nonatomic,assign) BOOL lockIsShow;

/**
 *  初始化
 *
 *  @param ntype 指定类型
 *
 *  @return 实例
 */
- (instancetype)initWithType:(UleLockVCType)ntype;

/**
 *  隐藏除头像外子View
 */
- (void)hiddenLockViewUI;

@end
