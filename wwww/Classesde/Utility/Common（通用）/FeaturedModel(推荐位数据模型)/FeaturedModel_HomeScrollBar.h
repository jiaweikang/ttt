//
//  FeaturedModel_HomeScrollBar.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/9.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeaturedModel_HomeScrollBarIndex : NSObject
@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *listingId;
@property (nonatomic, copy) NSString *defImgUrl;
@end

@interface FeaturedModel_HomeScrollBar : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
