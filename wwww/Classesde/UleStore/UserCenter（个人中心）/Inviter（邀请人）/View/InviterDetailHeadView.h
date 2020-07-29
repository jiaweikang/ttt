//
//  InviterDetailHeadView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviterDetailData.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviterDetailHeadView : UIView
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setModel:(InviterDetailStoreData *)model;
@end

NS_ASSUME_NONNULL_END
