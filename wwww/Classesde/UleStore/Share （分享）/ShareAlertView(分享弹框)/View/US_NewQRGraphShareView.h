//
//  US_NewQRGraphShareView.h
//  UleStoreApp
//
//  Created by lei xu on 2020/5/9.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USShareView.h"

NS_ASSUME_NONNULL_BEGIN
@class USShareModel;
@interface US_NewQRGraphShareView : UIView
+ (instancetype)showNewQRGraphShareViewWithModel:(USShareModel *)shareModel callBack:(USShareViewBlock) shareCallBack;

@end

NS_ASSUME_NONNULL_END
