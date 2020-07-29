//
//  USGuideViewLocalModel.h
//  UleStoreApp
//
//  Created by xulei on 2020/1/7.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USGuideViewLocalInfo : NSObject
@property (nonatomic , copy) NSString              * guideCode;//广告页code
@property (nonatomic , copy) NSString              * guideShowDate;//广告页显示日期
@property (nonatomic , copy) NSString              * guideShowCount;//已显示次数
@end

@interface USGuideViewLocalModel : NSObject
@property (nonatomic, strong) NSArray   *guideDataArray;
@property (nonatomic, copy) NSString *        remainder;//余数
@property (nonatomic, copy) NSString *        lastShowDate;//最后一次显示的日期
@end

NS_ASSUME_NONNULL_END
