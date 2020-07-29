//
//  US_QRScannerModel.h
//  u_store
//
//  Created by chenzhuqing on 2019/3/6.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_ScannerAction : NSObject
@property (nonatomic, copy) NSString * android_action;
@property (nonatomic, copy) NSString * ios_action;
@end


@interface US_QRScannerModel : NSObject
@property (nonatomic, copy) NSString * returnMessage;
@property (nonatomic, copy) NSString * returnCode;
@property (nonatomic, strong) US_ScannerAction * data;

@end

NS_ASSUME_NONNULL_END
