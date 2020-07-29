//
//  USUniversalAlertModelManager.h
//  u_store
//
//  Created by mac_chen on 2019/2/20.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeatureModel_ActivityDialog.h"
#import "ShareCreateId.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ManagerDoneBlock)(NSMutableArray *handleArr);
typedef void(^ShareRequestSuccessBlock)(NSString *shareUrl, ShareCreateData *data);

@interface USUniversalAlertModelManager : NSObject

+ (instancetype)sharedManager;

- (void)getShareUrlWithData:(NSMutableDictionary *)data successBlock:(ShareRequestSuccessBlock)shareRequestSuccessBlock;
/**
 * 获取首页活动弹框
 */
- (void)startRequestActivityDialog;

//记录展示次数
- (void)setAlertShowTimes:(NSString *)activeId;
////记录本次打开app展示过的用户 非本地
//- (void)setIsShowUniversalAlert;

//@property (nonatomic, assign) BOOL isLoadUniversalData; //本次打开app是否成功请求过弹框数据，请求过不再请求
//@property (nonatomic, assign) BOOL isShowUniversalAlert; //本次打开app是否展示过弹框（跟用户走）
//@property (nonatomic, assign) BOOL isShow; //现在是否存在弹框，存在则不重复创建
//@property (nonatomic, copy) NSMutableArray *localDataArr;
//@property (nonatomic, strong) NSDictionary *pushInfo; //推送参数

@end

NS_ASSUME_NONNULL_END
