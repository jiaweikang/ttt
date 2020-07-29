//
//  US_QueryAuthInfo.h
//  UleStoreApp
//
//  Created by zemengli on 2019/2/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CertificationInfo : NSObject
@property (nonatomic,strong) NSString *cardNo;
@property (nonatomic,strong) NSString *cardNoCipher;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *createUser;
@property (nonatomic,strong) NSString *idcardNo;
@property (nonatomic,strong) NSString *idcardNoCipher;
@property (nonatomic,strong) NSString *mobileNumber;
@property (nonatomic,strong) NSString *mobileNumberCipher;
@property (nonatomic,strong) NSString *usrName;
@property (nonatomic,strong) NSString *usrNameCipher;
@end

@interface US_QueryAuthData : NSObject
@property (nonatomic,strong) CertificationInfo *certificationInfo;
@end


@interface US_QueryAuthInfo : NSObject
@property (nonatomic,strong) NSString *returnCode;
@property (nonatomic,strong) NSString *returnMessage;
@property (nonatomic,strong)  US_QueryAuthData*data;
@end

NS_ASSUME_NONNULL_END
