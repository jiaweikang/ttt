//
//  US_WalletInfo.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/31.
//  strongright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface WalletInfo : NSObject
@property (nonatomic, strong) NSString *bindingCardCount;      //银行卡
@property (nonatomic, strong) NSString *redPackageBalance;     //红包
@property (nonatomic, strong) NSString *redPackageBalance919; //919红包余额
@property (nonatomic, strong) NSString *myListingBalance; //自有商品货款
@property (nonatomic, strong) NSString *uleCardBalance;        //邮乐卡
@property (nonatomic, strong) NSString *useableCouponCount;    //优惠券
@property (nonatomic, strong) NSString *commissionBalance;     //佣金余额
@property (nonatomic, strong) NSString *validLimit;
@property (nonatomic, strong) NSString *creditLimit;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *accountBalance;
@property (nonatomic, strong) NSString *availablePoint;
@property (nonatomic, strong) NSString *isOpenSYG;
@property (nonatomic, strong) NSString *accountA001;
@property (nonatomic, strong) NSString *accountA002;
@property (nonatomic, strong) NSString *accountA003;
@property (nonatomic, strong) NSString *accountA004;

@end
@interface US_WalletInfo : NSObject
@property (nonatomic, strong) NSString * returnMessage;
@property (nonatomic, strong) NSString * returnCode;
@property (nonatomic, strong) WalletInfo * data;
@end

NS_ASSUME_NONNULL_END
