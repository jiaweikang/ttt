//
//  MyStoreViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyStoreViewModelBlock)(id obj);

@interface MyStoreViewModel : UleBaseViewModel
@property (nonatomic, strong) NSString * commisionValue;
@property (nonatomic, strong) NSString * visitorValue;
@property (nonatomic, strong) NSString * orderValue;
@property (nonatomic, strong) NSString * headBackImageUrl;
@property (nonatomic, strong) NSString * headBackgroudColor;
@property (nonatomic, strong) NSString * strategyImageUrl;
@property (nonatomic, strong) NSString * promote_iosAction;
@property (nonatomic, copy) NSString * withdrawCommison;//提现收益

- (void)getCommisionInfo;

- (void)getShareInfo;

- (void)getNewPushMessageCountSuccess:(MyStoreViewModelBlock) success;

- (void)getMiddleButtonsIsRequestNewData:(BOOL)isReq;

- (void)getWithdrawCommision;

- (void)getShareOrderCount;

@end

NS_ASSUME_NONNULL_END
