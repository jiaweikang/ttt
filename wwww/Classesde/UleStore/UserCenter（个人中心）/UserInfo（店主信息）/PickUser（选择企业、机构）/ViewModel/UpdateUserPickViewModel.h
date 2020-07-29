//
//  UpdateUserPickViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"
#import "AttributionPickCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateUserPickCollectionViewEndScrollBlock)(CGFloat offsetX);
typedef void(^UpdateUserPickCollectionViewDidSelectNew)(void);
typedef void(^UpdateUserPickCollectionViewCompleteBlock)(void);
@interface UpdateUserPickViewModel : UleBaseViewModel
@property (nonatomic, copy)NSString     *org_provinceId;
@property (nonatomic, copy)NSString     *org_cityId;
@property (nonatomic, copy)NSString     *org_countryId;
@property (nonatomic, copy)NSString     *org_subStationId;

@property (nonatomic, copy)NSString     *org_provinceName;
@property (nonatomic, copy)NSString     *org_cityName;
@property (nonatomic, copy)NSString     *org_countryName;
@property (nonatomic, copy)NSString     *org_subStationName;

@property (nonatomic, copy)NSString     *postOrgType;
@property (nonatomic, strong)AttributionPickCellModel   *enter_lastSelectedCellModel;//企业
@property (nonatomic, copy)UpdateUserPickCollectionViewEndScrollBlock   didEndScrollBlock;
@property (nonatomic, copy)UpdateUserPickCollectionViewDidSelectNew     didSelectNew;

- (void)loadOrganizeInfoWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName;

- (void)fetchEnterpriseData:(NSDictionary *)dic;

//认证用户默认增加省
- (void)addUserAuthDefaultData;

//获取最小机构
- (NSString *)getCurrentOrganizationNameLowest;
//获取机构名
- (NSString *)getLastOrganizeName:(NSUInteger)pageIndex;
@end

NS_ASSUME_NONNULL_END
