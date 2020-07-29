//
//  RegisterView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/12.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleModulesDataToAction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RegisterViewDelegate  <NSObject>
@optional
- (void)registViewShowHudWithText:(NSString *)text delay:(NSTimeInterval)interval;
- (void)registViewShiftSwitchStatusIsOn:(BOOL)isOn;
- (void)registViewProtocolDetailAction;
- (void)registViewConfirmToRegistAction;
- (void)registViewPushToPick:(NSInteger)pushType;//1-选择企业 2-选择机构

- (void)registPushNewViewController:(UleUCiOSAction *)moduleAction;
@end

@interface RegisterTopView : UIView
@property (nonatomic, strong)UITextField    *phoneNum_TF;
@property (nonatomic, strong)UISwitch   *switchControl;
@property (nonatomic, weak) id<RegisterViewDelegate> registTopviewDelegate;
@property (nonatomic, strong) NSString  *storeName;

- (void)setMobileNum:(NSString *)phoneNum isUserInteractionEnabled:(BOOL)isEnabled;
- (void)setRegistTopStoreName:(NSString *)storeName;

//- (void)lockRegistTopView;
- (void)showTeamExitView:(BOOL)isShow;
@end


@interface RegisterCenterView : UIView
@property (nonatomic, strong)NSString   *realName;
@property (nonatomic, weak) id<RegisterViewDelegate> registCenterviewDelegate;
@property (nonatomic, strong)UITextField    *enterprise_TF;//企业
@property (nonatomic, strong)UITextField    *organization_TF;//机构

- (void)setRegistCenterRealName:(NSString *)realName;
- (void)setRegistCenterEnterpriseName:(NSString *)enterPriseName;
- (void)setRegistCenterOrganizationName:(NSString *)organizationName;

- (void)lockRegistCenterView:(BOOL)isLock;
@end


@interface RegisterBottomView : UIView
//@property (nonatomic, strong)UIButton       *protocolSelBtn;
@property (nonatomic, strong)UIButton       *registBtn;
@property (nonatomic, weak)id<RegisterViewDelegate> registBottomViewDelegate;

- (void)removeSignAgreementView;

@end

NS_ASSUME_NONNULL_END
