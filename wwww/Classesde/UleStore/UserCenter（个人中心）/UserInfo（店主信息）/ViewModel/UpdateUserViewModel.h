//
//  UpdateUserViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UpdateUserListCellModel,UpdateUserHeaderModel;
@interface UpdateUserViewModel : UleBaseViewModel
@property (nonatomic,strong)UpdateUserHeaderModel   *secondSectionModel;
@property (nonatomic, copy)NSString *storeNameStandardUrl;
/*****企业******/
@property (nonatomic, copy)NSString *enterpriseId;//相当于orgType
/*****省市县支局ID*****/
@property (nonatomic, copy)NSString *provinceID;
@property (nonatomic, copy)NSString *cityID;
@property (nonatomic, copy)NSString *countryID;
@property (nonatomic, copy)NSString *substationID;

@property (nonatomic, copy)NSString *enterpriseName;
@property (nonatomic, copy)NSString *provinceName;
@property (nonatomic, copy)NSString *cityName;
@property (nonatomic, copy)NSString *countryName;
@property (nonatomic, copy)NSString *substationName;

//认证用户提示
@property (nonatomic, copy)NSString *identifierTips;

//获取数据模型
- (UpdateUserListCellModel *)getCurrentCellModeAtIndex:(NSIndexPath *)indexPath;
//默认非企业数据
- (void)fetchDefaultEnterprise:(NSDictionary *)dic;
//更新基本信息页面
- (void)refreshViewWithUserInfo:(NSDictionary *)userInfo;
//更新企业结构信息页面
- (void)refreshAttributionViewWithUserInfo:(NSDictionary *)userInfo;
//刷新secondCells
- (void)refreshSecondSectionCells;
//修改接口成功后修改页面
- (void)refreshOrganizeViewAfterRequestSuccess;
@end

NS_ASSUME_NONNULL_END
