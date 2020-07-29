//
//  US_UleCardListInfo.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_UleCardDetail : NSObject
@property (nonatomic, copy) NSString * cardNo;        //卡号
@property (nonatomic, copy) NSString * parValue;      //总值
@property (nonatomic, copy) NSString * balance;       //余额
@property (nonatomic, copy) NSString * cardTypeid;    //邮乐卡类型：佣金卡和普通卡
@property (nonatomic, copy) NSString * bindingTime;   //绑定时间
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;

@end

@interface US_UleCardList : NSObject
@property (nonatomic, strong) NSMutableArray *uleCardList;
@end

@interface US_UleCardListInfo : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) US_UleCardList *data;
@end

NS_ASSUME_NONNULL_END
