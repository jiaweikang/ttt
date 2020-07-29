//
//  WithdrawResultModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawResultData : NSObject
@property (nonatomic, copy) NSString    *presentRecordHint;

@end

@interface WithdrawResultModel : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) WithdrawResultData  *data;

@end
NS_ASSUME_NONNULL_END
