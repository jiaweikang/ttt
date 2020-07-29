//
//  WithdrawCashPromoteView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/7.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WithdrawCashPromoteType){
    WithdrawCashPromoteTypeWithdraw,//提现
    WithdrawCashPromoteTypeRealname,//未实名认证
    WithdrawCashPromoteTypeBindcard//未绑卡
};

typedef void(^WithdrawCashConfirmBlock)(WithdrawCashPromoteType type);

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawCashPromoteView : UIView

+ (WithdrawCashPromoteView *)withdrawCashPromoteViewWithType:(WithdrawCashPromoteType)type andNum:(NSString *)num confirmBlock:(WithdrawCashConfirmBlock)block;
@end

NS_ASSUME_NONNULL_END
