//
//  UpdateUserHeaderModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleSectionBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UpdateUserType) {
    UpdateUserTypeNone,//无战队，无认证
    UpdateUserTypeTeam,//有战队
    UpdateUserTypeAuth,//认证
    UpdateUserTypeAuthInReview,//认证用户审核中
    UpdateUserTypeShuaiKang
};
typedef NS_ENUM(NSInteger, UpdateUserSwitchStatus) {
    UpdateUserSwitchStatusNone,
    UpdateUserSwitchStatusOn,
    UpdateUserSwitchStatusOff
};
typedef void(^UpdateUserHeaderViewSwitchStatusBlock)(UISwitch *sw);
typedef void(^UpdtateUserHeaderViewQuitTeamBlock)(void);
@interface UpdateUserHeaderModel : UleSectionBaseModel
@property (nonatomic, copy) NSString    * titleStr;
@property (nonatomic, assign)UpdateUserSwitchStatus switchStatus;
@property (nonatomic, assign)UpdateUserType         userType;
@property (nonatomic, copy)NSString     * contentStr;
@property (nonatomic, copy)UpdateUserHeaderViewSwitchStatusBlock    switchShiftBlock;
@property (nonatomic, copy)UpdtateUserHeaderViewQuitTeamBlock       quitTeamBlock;
@end


@interface UserInfoTeamInfo : NSObject
@property (nonatomic, assign)BOOL       canEdit;
@property (nonatomic, copy)NSString *auditText;
@property (nonatomic, copy)NSString *context;//(*认证员工只能在省内修改机构)
@property (nonatomic, copy)NSString *context2;//1.邮政认证员工只能在当前省内更换机构##2.审核将在15天内完成，请耐心等待

@end

@interface UserInfoTeamModel : NSObject
@property (nonatomic, copy)NSString *returnCode;
@property (nonatomic, copy)NSString *returnMessage;
@property (nonatomic, strong)UserInfoTeamInfo *data;

@end
NS_ASSUME_NONNULL_END
