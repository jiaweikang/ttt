//
//  LoginSuccessModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/7.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginSuccessAuthMap : NSObject
@property (nonatomic , assign) NSInteger              carInsurance;

@end

@interface LoginSuccessModel : NSObject
@property (nonatomic , copy) NSString              * mobileNumber;
@property (nonatomic , copy) NSString              * contractCode;
@property (nonatomic , copy) NSString              * latitude;
@property (nonatomic , copy) NSString              * delFlag;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * regCityName;
@property (nonatomic , copy) NSString              * currentProvince;
@property (nonatomic , copy) NSString              * orgProvince;
@property (nonatomic , copy) NSString              * orgAreaName;
@property (nonatomic , copy) NSString              * storeName;
@property (nonatomic , copy) NSString              * orgType;
@property (nonatomic , copy) NSString              * orgCity;
@property (nonatomic , copy) NSString              * currentCity;
@property (nonatomic , copy) NSString              * userFlag;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * userToken;
@property (nonatomic , copy) NSString              * lastOperaterId;
@property (nonatomic , copy) NSString              * areaId;
@property (nonatomic , copy) NSString              * orgTown;
@property (nonatomic , copy) NSString              * provinceId;
@property (nonatomic , copy) NSString              * longitude;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * orgTownName;
@property (nonatomic , copy) NSString              * recommendUserId;
@property (nonatomic , copy) NSString              * stationName;
@property (nonatomic , copy) NSString              * usrOnlyid;
@property (nonatomic , copy) NSString              * isUserProtocol;
@property (nonatomic , copy) NSString              * stationInfo3;
@property (nonatomic , copy) NSString              * recommendChannel;
@property (nonatomic , copy) NSString              * enterpriseOrgFlag;
@property (nonatomic , copy) NSString              * electronicProtocolId;
@property (nonatomic , copy) NSString              * deviceInfo;
@property (nonatomic , copy) NSString              * townId;
@property (nonatomic , copy) NSString              * donateFlag;
@property (nonatomic , copy) NSString              * qualificationFlag;
@property (nonatomic , copy) NSString              * orgArea;
@property (nonatomic , copy) NSString              * ip;
@property (nonatomic , copy) NSString              * storeDesc;
@property (nonatomic , copy) NSString              * provinceName;
@property (nonatomic , copy) NSString              * ownerId;
@property (nonatomic , copy) NSString              * storeLogo;
@property (nonatomic , copy) NSString              * ownerType;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * cityId;
@property (nonatomic , copy) NSString              * imageUrl;
@property (nonatomic , copy) NSString              * areaName;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * storeState;
@property (nonatomic , copy) NSString              * enterpriseName;
@property (nonatomic , copy) NSString              * hardInfo;
@property (nonatomic , copy) NSString              * townName;
@property (nonatomic , copy) NSString              * usrName;
@property (nonatomic , copy) NSString              * orgCityName;
@property (nonatomic , copy) NSString              * lockFlag;
@property (nonatomic , strong) LoginSuccessAuthMap  * AuthMap;
@property (nonatomic , copy) NSString              * protocolUrl;
@property (nonatomic , copy) NSString              * lastOperaterType;
@property (nonatomic , copy) NSString              * orgProvinceName;
@property (nonatomic , assign) NSInteger              websiteType;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * protocolId;
@property (nonatomic , copy) NSString              * orgCode;
@property (nonatomic , copy) NSString              * postalCode;
@property (nonatomic , copy) NSString              * regProvinceName;
@property (nonatomic , copy) NSString              * identified;//0-非认证员工 1-认证员工
@property (nonatomic , copy) NSString              * yzgFlag;//是否开通邮掌柜业务 0-未开通 1-开通
/***最低一级机构 20190924***/
@property (nonatomic , copy) NSString              * lastOrgId;
@property (nonatomic , copy) NSString              * lastOrgName;

@end

NS_ASSUME_NONNULL_END
