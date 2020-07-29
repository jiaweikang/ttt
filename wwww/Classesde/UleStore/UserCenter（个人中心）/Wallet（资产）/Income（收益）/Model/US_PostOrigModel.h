//
//  US_PostOrigModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/8.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface US_postOrigData : NSObject

@property(nonatomic,copy)   NSString        *_id;
@property(nonatomic,copy)   NSString        *code;
@property(nonatomic,copy)   NSString        *name;
@property(nonatomic,copy)   NSString        *parentId;
@property(nonatomic,copy)   NSString        *parentCode;
@property(nonatomic,copy)   NSString        *levelCode;
@property(nonatomic,copy)   NSString        *levelName;
@property(nonatomic,copy)   NSString        *status;
@property(nonatomic,copy)   NSString        *remark;
@property(nonatomic,copy)   NSString        *createTime;
@property(nonatomic,copy)   NSString        *createUser;
@property(nonatomic,copy)   NSString        *updateTime;
@property(nonatomic,copy)   NSString        *updateUser;
@property(nonatomic,copy)   NSString        *provinceCode;
@property(nonatomic,copy)   NSString        *provinceName;
@property(nonatomic,copy)   NSString        *regionProvinceCode;

@property(nonatomic,copy)   NSString        *villageQuota;
@property(nonatomic,copy)   NSString        *dmsCode;
@property(nonatomic,copy)   NSString        *dmsName;
@property(nonatomic,copy)   NSString        *firstLetter;
@property(nonatomic,copy)   NSString        *keyWord;

@property(nonatomic,assign) BOOL       selected;//被选中
@end


@interface US_PostOrigModel : NSObject
@property(nonatomic,copy) NSString *returnCode;
@property(nonatomic,copy) NSString *returnMessage;
@property(nonatomic,strong) NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
