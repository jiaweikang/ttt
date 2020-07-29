//
//  LogoutModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface LogoutSectionData : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *content;
@end

@interface LogoutData : NSObject
@property (nonatomic, strong) LogoutSectionData *top;
@property (nonatomic, strong) LogoutSectionData *middle;
@property (nonatomic, strong) LogoutSectionData *bottom;
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *failMsg;
@end

@interface LogoutModel : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) LogoutData *data;
@end

NS_ASSUME_NONNULL_END
