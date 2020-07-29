//
//  USDrawLotteryResultView.h
//  u_store
//
//  Created by xulei on 2019/2/25.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger
{
    USDrawLotteryResultTypeSuccess,
    USDrawLotteryResultTypeFail
}USDrawLotteryResultType;

@interface USDrawLotteryResultModel : NSObject
@property (nonatomic , copy) NSString              * prizeTypeDesc_v2;
@property (nonatomic , copy) NSString              * pcBatchId;
@property (nonatomic , copy) NSString              * prizeMoney;
@property (nonatomic , copy) NSString              * prizeType;
@property (nonatomic , copy) NSString              * prizeDesc;
@property (nonatomic , assign) NSInteger              collectionId;
@property (nonatomic , copy) NSString              *collectionName;
@property (nonatomic , copy) NSString              * text_url;//文本券跳转链接
@property (nonatomic , copy) NSString              * expiredEndDate;
@end

@interface USDrawLotteryResultView : UIView
@property (nonatomic, strong)USDrawLotteryResultModel   *model;


@end

NS_ASSUME_NONNULL_END
