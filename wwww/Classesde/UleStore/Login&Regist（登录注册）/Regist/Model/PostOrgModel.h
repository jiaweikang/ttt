//
//  PostOrgModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostOrgData :NSObject
@property (nonatomic , copy) NSString              * bureauNature;
@property (nonatomic , copy) NSString              * servicePopulation;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * parentCode;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * substationAttribute;
@property (nonatomic , copy) NSString              * provinceCode;
@property (nonatomic , copy) NSString              * keyWord;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * levelCode;
@property (nonatomic , assign) NSInteger              updateUser;
@property (nonatomic , copy) NSString              * territoryType;
@property (nonatomic , copy) NSString              * serviceRadius;
@property (nonatomic , copy) NSString              * levelName;
@property (nonatomic , copy) NSString              * dmsCode;
@property (nonatomic , copy) NSString              * manageType;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * isSingleWebsite;
@property (nonatomic , copy) NSString              * dmsName;
@property (nonatomic , assign) NSInteger              _id;
@property (nonatomic , copy) NSString              * provinceName;
@property (nonatomic , copy) NSString              * isSupplementVillagesWebsite;
@property (nonatomic , assign) NSInteger              parentId;
@property (nonatomic , copy) NSString              * shortName;
@property (nonatomic , copy) NSString              * villageQuota;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              createUser;
@property (nonatomic , copy) NSString              * regionProvinceCode;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * firstLetter;
@property (nonatomic , copy) NSString              * address;

@property (nonatomic, assign)BOOL               isSelected;

@end

@interface PostOrgModel : NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , strong) NSMutableArray      * data;

@end

NS_ASSUME_NONNULL_END
