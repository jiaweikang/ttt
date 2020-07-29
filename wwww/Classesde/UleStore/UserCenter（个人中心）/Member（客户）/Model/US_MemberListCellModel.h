//
//  US_MemberListCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MemberListCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * imageUrl;//图片
@property (nonatomic, strong) NSString * name;//姓名
@property (nonatomic, strong) NSString * mobileNum;//手机号
@property (nonatomic, strong) NSString * addr;//地址

@property (nonatomic, strong) NSString * cardNum;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, assign) NSInteger seqId;
@end

NS_ASSUME_NONNULL_END
