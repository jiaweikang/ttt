//
//  USMemberListData.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface US_MemberInfo : NSObject

@property(nonatomic,strong)NSString *sumbit;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *fullName;
@property(nonatomic,strong)NSString *updateTime;
@property(nonatomic,strong)NSString *customerName;
@property(nonatomic,strong)NSString *cardNum;
@property(nonatomic,strong)NSString *simpleName;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,assign)NSInteger integral;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *idcard;
@property(nonatomic,strong)NSString *villageNo;
@property(nonatomic,strong)NSString *tel;
@property(nonatomic,strong)NSString *createUser;
@property(nonatomic,strong)NSString *jawboneMoney;
@property(nonatomic,strong)NSString *addr;
@property(nonatomic,assign)NSInteger seqId;
@end

@interface USMemberListData_data : NSObject
@property (nonatomic ,copy) NSString *totalPage;
@property (nonatomic ,copy) NSString *totalRecord;
@property (nonatomic ,copy) NSString *cpage;
@property (nonatomic ,strong) NSMutableArray *retLst;
@end


@interface USMemberListData : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) USMemberListData_data *data;
@end

NS_ASSUME_NONNULL_END
