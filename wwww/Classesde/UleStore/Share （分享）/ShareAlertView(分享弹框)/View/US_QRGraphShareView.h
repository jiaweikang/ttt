//
//  US_QRGraphShareView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/12.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USShareModel.h"
#import "ShareTemplateModel.h"
#import "USShareView.h"

typedef void(^QRGraphFinishBlock)(void);

typedef NS_ENUM(NSUInteger, USGraphShareViewType) {
    USGraphShareViewTypeOne = 1,
    USGraphShareViewTypeTwo,
};

NS_ASSUME_NONNULL_BEGIN

@interface US_QRGraphShareView : UIView

+ (instancetype)getQRGraphShareViewWithModel:(USShareModel *)shareModel withTemplate:(ShareTemplateList *)templateModel;
+ (void)showQRGraphShareViewWithModel:(USShareModel *)shareModel withTemplate:(ShareTemplateList *)templateModel callBack:(USShareViewBlock) shareCallBack;

- (void)transformContentViewToImageAndSaveToLocal:(QRGraphFinishBlock) saveFinish;
@end

NS_ASSUME_NONNULL_END
