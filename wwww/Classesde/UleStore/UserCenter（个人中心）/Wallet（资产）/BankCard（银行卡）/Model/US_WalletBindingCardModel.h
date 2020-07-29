//
//  US_WalletBindingCardModel.h
//  u_store
//
//  Created by wangkun on 16/6/24.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US_WalletBindingCardTime : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *minutes;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *nanos;
@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *timezoneOffset;
@property (nonatomic, copy) NSString *year;
@end

@interface US_WalletBindingCardInfo : NSObject
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankEnAbbr;
@property (nonatomic, copy) NSString *bankRemark;
@property (nonatomic, copy) NSString *buyerIpAddr;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *cardKind;
@property (nonatomic, copy) NSString *cardNoCipher;
@property (nonatomic, copy) NSString *cardProvince;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *certNoCipher;
@property (nonatomic, copy) NSString *certType;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *limitAmount;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *mobileNumberCipher;
@property (nonatomic, copy) NSString *PINCode;
@property (nonatomic, copy) NSString *PINCreateTime;
@property (nonatomic, copy) NSString *signNo;
@property (nonatomic, copy) NSString *signNoCipher;
@property (nonatomic, copy) NSString *smartpayStatus;
@property (nonatomic, copy) NSString *usrName;
@property (nonatomic, copy) NSString *usrNameCipher;
@property (nonatomic, copy) NSString *usrOnlyid;
@property (nonatomic, strong) US_WalletBindingCardTime *createTime;
@property (nonatomic, strong) US_WalletBindingCardTime *smartpayOpenTime;
@property (nonatomic, strong) US_WalletBindingCardTime *updateTime;

@end


@interface US_WalletBindingCard : NSObject
@property (nonatomic, strong) NSMutableArray *cardList;
@end

@interface US_WalletBindingCardModel : NSObject
@property (nonatomic, strong) US_WalletBindingCard *data;
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@end
