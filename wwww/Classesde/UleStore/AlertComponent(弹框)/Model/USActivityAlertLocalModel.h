//
//  USActivityAlertModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/7/24.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USActivityLocalAlertInfo : NSObject<NSCopying>
@property (nonatomic , copy) NSString              * activityCode;//活动code
@property (nonatomic , copy) NSString              * alertShowDate;//弹框显示日期
@property (nonatomic , copy) NSString              * alertShowCount;//弹框显示次数
@end

@interface  USActivityAlertLocalModel : NSObject<NSCopying>
@property (nonatomic, copy) NSArray *        alertDataArr;
@property (nonatomic, copy) NSString *        remainder;//余数
@property (nonatomic, copy) NSString *        lastShowDate;//最后一次显示的日期
@end
NS_ASSUME_NONNULL_END
