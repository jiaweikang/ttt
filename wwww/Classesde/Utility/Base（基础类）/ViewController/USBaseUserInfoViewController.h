//
//  USBaseUserInfoViewController.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "RegisterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface USBaseUserInfoViewController : UleBaseViewController
{
    CGFloat bottomViewHeight;
    BOOL    isUserChanged;//用户是否操作过
    
    /*****省市县支局ID*****/
    NSString *orgType;
    NSString *provinceID;
    NSString *cityID;
    NSString *areaID;
    NSString *townID;
    //名称
    NSString *enterpriseName;//企业名称
    NSString *provinceName;//省
    NSString *cityName;//市
    NSString *areaName;//县
    NSString *townName;//支局
}
@property (nonatomic, strong)RegisterTopView    *p_topView;
@property (nonatomic, strong)RegisterCenterView *p_centerView;
@property (nonatomic, strong)RegisterBottomView *p_bottomView;

@property (nonatomic, assign, readonly)BOOL switchStatusOn;

- (void)setSwitchViewStatus:(BOOL)isOn;

- (void)bottomBtnAction;

@end

NS_ASSUME_NONNULL_END
