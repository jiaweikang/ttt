//
//  UpdateUserViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserViewModel.h"
#import "PostOrgModel.h"
#import "UpdateUserHeaderModel.h"
#import "UpdateUserListCellModel.h"
#import "FindStoreInfoModel.h"
#import "USImagePicker.h"
#import "UleBaseViewController.h"
#import <NSData+Base64.h>
#include "sys/stat.h"
#import "US_MystoreManangerApi.h"
#import "UserHeadImg.h"
#import "US_UpdateUserPickEnterpriseVC.h"
#import "US_UpdateUserPickOrganizeVC.h"
#import "US_UpdateUserInfoView.h"
#import <UIView+ShowAnimation.h>
#import "UleModulesDataToAction.h"
#import "US_LoginApi.h"
#import "US_UpdateUserInfoVC.h"
#import "DeviceInfoHelper.h"

@interface UpdateUserViewModel ()
{
    //默认的省id
    NSString *defaultOrgType;
    NSString *defaultProvinceID;
    NSString *defaultProvinceName;
}
@property (nonatomic,strong)UleNetworkExcute *networkClient_API;
@end

@implementation UpdateUserViewModel
- (void)dealloc{
//    if (_networkClient_API) {
//        [_networkClient_API cancel];
//    }
}
- (instancetype)init{
    if (self=[super init]) {
        defaultOrgType=@"0";
        defaultProvinceID=@"58093";
        defaultProvinceName=@"邮乐";
        if ([US_UserUtility sharedLogin].enterpriseFlag) {
            self.enterpriseId=[US_UserUtility sharedLogin].m_orgType;
            self.provinceID=[US_UserUtility sharedLogin].m_provinceCode;
            self.cityID=[US_UserUtility sharedLogin].m_cityCode;
            self.countryID=[US_UserUtility sharedLogin].m_areaCode;
            self.substationID=[US_UserUtility sharedLogin].m_townCode;
            self.enterpriseName=[US_UserUtility sharedLogin].m_orgName;
            self.provinceName=[US_UserUtility sharedLogin].m_provinceName;
            self.cityName=[US_UserUtility sharedLogin].m_cityName;
            self.countryName=[US_UserUtility sharedLogin].m_areaName;
            self.substationName=[US_UserUtility sharedLogin].m_townName;
        }else{
            self.enterpriseId=defaultOrgType;
            self.provinceID=defaultProvinceID;
            self.provinceName=defaultProvinceName;
        }
        [self loadSectionModel];
    }
    return self;
}

- (void)loadSectionModel{
    NSArray *firstTitles=@[@"店铺LOGO",@"店铺名称",@"手机号码",@"店铺分享介绍"];
    NSArray *firstContents=@[@"",NonEmpty([US_UserUtility sharedLogin].m_stationName),NonEmpty([US_UserUtility sharedLogin].m_mobileNumber),@""];
 
    UpdateUserHeaderModel *sectionModel=[[UpdateUserHeaderModel alloc]init];
    sectionModel.headViewName=@"UpdateUserHeaderView";
    sectionModel.headHeight=35;
    sectionModel.titleStr=@"基本信息";
    [self.mDataArray addObject:sectionModel];
    for (int i=0; i<firstTitles.count; i++) {
        UpdateUserListCellModel *cellModel=[[UpdateUserListCellModel alloc]initWithCellName:@"UpdateUserListCell"];
        cellModel.titleStr=firstTitles[i];
        cellModel.contentStr=firstContents[i];
        if (i==0) {
            cellModel.cellName=@"UpdateUserListCell1";
            cellModel.headImg=[US_UserUtility sharedLogin].m_userHeadImage;
            cellModel.headImgUrl=[US_UserUtility sharedLogin].m_userHeadImgUrl;
        }else if (i==2) {
            cellModel.isHideArrow=YES;
        }else if (i==3) {
            cellModel.cellName=@"UpdateUserListCell2";
            cellModel.subTitleStr=[US_UserUtility sharedLogin].m_storeDesc;
        }
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [self cellClickAtIndexPath:indexPath];
            
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mDataArray addObject:self.secondSectionModel];
}

- (void)fetchDefaultEnterprise:(NSDictionary *)dic{
    PostOrgModel *respModel = [PostOrgModel yy_modelWithDictionary:dic];
    if (respModel.data.count>0) {
        PostOrgData *defaultData=[respModel.data firstObject];
        NSString *defaultID = [NSString isNullToString:[NSString stringWithFormat:@"%ld", (long)defaultData._id]];
        NSString *defaultName = [NSString isNullToString:[NSString stringWithFormat:@"%@", defaultData.name]];
        if (defaultID.length>0) {
            self->defaultProvinceID=defaultID;
        }
        if (defaultName.length>0) {
            self->defaultProvinceName=defaultName;
        }
        
        UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
        if (secondSectionModel.switchStatus==UpdateUserSwitchStatusOff) {
            self.provinceID=self->defaultProvinceID;
            self.provinceName=self->defaultProvinceName;
        }
    }
}

- (void)cellClickAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                [self showImagePickVC];
                break;
            case 1:
            {
                UpdateUserHeaderModel *sectionModel=(UpdateUserHeaderModel *)self.mDataArray[indexPath.section];
                UpdateUserListCellModel *cellModel = (UpdateUserListCellModel *)sectionModel.cellArray[indexPath.row];
                
                US_UpdateUserInfoView *updateUserInfoView = [US_UpdateUserInfoView initWithTitle:@"店铺名称" placeholder:cellModel.contentStr alertType:ChangeStoreNameType confirmBlock:^(NSString * _Nonnull info) {
                    [US_UserUtility saveStationName:info];
                    [[NSNotificationCenter defaultCenter]postNotificationName:Notify_EditStoreInfo object:nil userInfo:nil];
                }];
                [updateUserInfoView showViewWithAnimation:AniamtionAlert];
            }
                break;
            case 2:
                break;
            case 3:
            {
                UpdateUserHeaderModel *sectionModel=(UpdateUserHeaderModel *)self.mDataArray[indexPath.section];
                UpdateUserListCellModel *cellModel = (UpdateUserListCellModel *)sectionModel.cellArray[indexPath.row];
                
                US_UpdateUserInfoView *updateUserInfoView = [US_UpdateUserInfoView initWithTitle:@"店铺分享介绍" placeholder:cellModel.subTitleStr alertType:ChangeStoreInfoType confirmBlock:^(NSString * _Nonnull info) {
                    [US_UserUtility saveStoreDesc:info];
                    [[NSNotificationCenter defaultCenter]postNotificationName:Notify_EditStoreInfo object:nil userInfo:nil];
                }];
                [updateUserInfoView showViewWithAnimation:AniamtionAlert];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
            {
                UpdateUserHeaderModel *sectionModel=(UpdateUserHeaderModel *)self.mDataArray[indexPath.section];
                UpdateUserListCellModel *cellModel = (UpdateUserListCellModel *)sectionModel.cellArray[indexPath.row];
                
                US_UpdateUserInfoView *updateUserInfoView = [US_UpdateUserInfoView initWithTitle:@"真实姓名" placeholder:cellModel.contentStr alertType:ChangeUserNameType confirmBlock:^(NSString * _Nonnull info) {
                    [US_UserUtility saveUserName:info];
                    [[NSNotificationCenter defaultCenter]postNotificationName:Notify_EditStoreInfo object:nil userInfo:nil];
                }];
                [updateUserInfoView showViewWithAnimation:AniamtionAlert];
            }
                break;
            case 1:
            {
                UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
                if (secondSectionModel.userType==UpdateUserTypeTeam || secondSectionModel.userType==UpdateUserTypeAuth || secondSectionModel.userType==UpdateUserTypeAuthInReview || secondSectionModel.userType==UpdateUserTypeShuaiKang) {
                    return;
                }
                US_UpdateUserPickEnterpriseVC *pickEnterpriseVC=[[US_UpdateUserPickEnterpriseVC alloc]init];
                [self.rootVC presentViewController:pickEnterpriseVC animated:YES completion:nil];
            }
                break;
            case 2:
            {
                if (self.enterpriseId.length>0) {
                    UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
                    if (secondSectionModel.userType==UpdateUserTypeTeam) {
                        return;
                    }
                    US_UpdateUserPickOrganizeVC *pickOrganizeVC=[[US_UpdateUserPickOrganizeVC alloc]initWithOrgType:self.enterpriseId andOrgName:self.enterpriseName andUserType:secondSectionModel.userType identifierTips:self.identifierTips];
                    [self.rootVC presentViewController:pickOrganizeVC animated:YES completion:nil];
                }else{
                    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"请选择所属企业" afterDelay:1.5];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)refreshViewWithUserInfo:(NSDictionary *)userInfo{
    UpdateUserListCellModel *cellModel3=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:3 inSection:0]];
    cellModel3.subTitleStr =[US_UserUtility sharedLogin].m_storeDesc;
    UpdateUserListCellModel *cellModel1=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:1 inSection:0]];
    cellModel1.contentStr=[US_UserUtility sharedLogin].m_stationName;
    UpdateUserListCellModel *cellModel2=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:0 inSection:1]];
    cellModel2.contentStr=[US_UserUtility sharedLogin].m_userName;
    NSString * headImage=userInfo[@"headImage"];
    if (headImage&&headImage.length>0) {
        UpdateUserListCellModel *cellModel0=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
        cellModel0.headImgUrl=headImage;
    }
}

- (void)refreshAttributionViewWithUserInfo:(NSDictionary *)userInfo{
    NSString *enterpriseID=[NSString isNullToString:[userInfo objectForKey:@"enterpriseID"]];
    NSString *selectProvinceID=[NSString isNullToString:[userInfo objectForKey:@"provinceId"]];
    NSString *selectCityID=[NSString isNullToString:[userInfo objectForKey:@"cityId"]];
    NSString *selectCountryID=[NSString isNullToString:[userInfo objectForKey:@"countryId"]];
    NSString *selectSubStationID=[NSString isNullToString:[userInfo objectForKey:@"subStationId"]];
    NSString *selectProvinceName=[NSString isNullToString:[userInfo objectForKey:@"provinceName"]];
    NSString *selectCityName=[NSString isNullToString:[userInfo objectForKey:@"cityName"]];
    NSString *selectCountryName=[NSString isNullToString:[userInfo objectForKey:@"countryName"]];
    NSString *selectSubStationName=[NSString isNullToString:[userInfo objectForKey:@"subStationName"]];

    if (enterpriseID.length>0)          self.enterpriseId=enterpriseID;
    self.provinceID=selectProvinceID;
    self.cityID=selectCityID;
    self.countryID=selectCountryID;
    self.substationID=selectSubStationID;
    self.provinceName=selectProvinceName;
    self.cityName=selectCityName;
    self.countryName=selectCountryName;
    self.substationName=selectSubStationName;
    
    NSString *enterpriseName=[NSString isNullToString:[userInfo objectForKey:@"enterpriseName"]];
    NSString *organizeName=[NSString isNullToString:[userInfo objectForKey:@"organizeName"]];
    if (enterpriseName.length>0) {
        UpdateUserListCellModel *cellModel_enterprise=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:1 inSection:1]];
        cellModel_enterprise.contentStr=enterpriseName;
        self.enterpriseName=enterpriseName;
        UpdateUserListCellModel *cellModel_organize=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:2 inSection:1]];
        cellModel_organize.contentStr=@"";
        UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
        if ([self.enterpriseId isEqualToString:@"1000"]) {
            secondSectionModel.userType=UpdateUserTypeShuaiKang;
            cellModel_enterprise.isHideArrow=YES;
        }
    }
    if (organizeName.length>0) {
        UpdateUserListCellModel *cellModel_organize=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:2 inSection:1]];
        cellModel_organize.contentStr=organizeName;
        UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
        if (secondSectionModel.userType==UpdateUserTypeNone||secondSectionModel.userType==UpdateUserTypeShuaiKang) {
            NSDictionary *requestParams=@{@"orgType":[NSString isNullToString:self.enterpriseId],
                                          @"orgProvince":selectProvinceID,
                                          @"orgCity":selectCityID,
                                          @"orgArea":selectCountryID,
                                          @"orgTown":selectSubStationID,
                                          @"orgName":[NSString isNullToString:self.enterpriseName],
                                          @"orgProvinceName":selectProvinceName,
                                          @"orgCityName":selectCityName,
                                          @"orgAreaName":selectCountryName,
                                          @"orgTownName":selectSubStationName
                                          };
            US_UpdateUserInfoVC *rootVC=(US_UpdateUserInfoVC*)self.rootVC;
            [rootVC startRequestModifyUserInfo:requestParams];
            return;
        }
    }
    
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)refreshSecondSectionCells{
    [self.secondSectionModel.cellArray removeAllObjects];
    if (self.secondSectionModel.switchStatus==UpdateUserSwitchStatusOn) {
        [self.secondSectionModel.cellArray addObjectsFromArray:[self getNewSecondCellModelsWithSectionModel:self.secondSectionModel]];
    }
}

- (void)refreshOrganizeViewAfterRequestSuccess{
    UpdateUserHeaderModel *secondSectionModel=self.secondSectionModel;
    if (secondSectionModel.switchStatus==UpdateUserSwitchStatusOn) {
        [secondSectionModel.cellArray removeAllObjects];
        [secondSectionModel.cellArray addObjectsFromArray:[self getNewSecondCellModelsWithSectionModel:secondSectionModel]];
    }else if (secondSectionModel.switchStatus==UpdateUserSwitchStatusOff) {
        [secondSectionModel.cellArray removeAllObjects];
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

#pragma mark - <换头像>
- (void)showImagePickVC{
    @weakify(self);
    [USImagePicker startWKImagePicker:self.rootVC cameraFailCallBack:^(NSInteger code){
        @strongify(self);
        switch (code) {
            case 1:
                [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"该设备不支持拍照" afterDelay:1.5];
                break;
            case 2:
                //相机权限不通过
                [(UleBaseViewController*)self.rootVC showAlertNormal:[NSString stringWithFormat:@"相机开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"相机\">\"%@\"",[DeviceInfoHelper getAppName]]];
                break;
            default:
                break;
        }
    } photoAlbumFailCallBack:^{
        //相册权限不通过
        [(UleBaseViewController*)self.rootVC showAlertNormal:[NSString stringWithFormat:@"相册开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"照片\">\"%@\"",[DeviceInfoHelper getAppName]]];
    } chooseCallBack:^(NSDictionary<NSString *,id> *info) {
        if(![[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
            [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"只能上传图片" afterDelay:1.5];
            return;
        }
        UIImage *original = [info objectForKey:UIImagePickerControllerEditedImage];
        [self uploadPhotoImage:original];
    } cancelCallBack:^{
    }];
}
- (void)uploadPhotoImage:(UIImage *)image{
    //将截好的图片存到本地
    NSError *err;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&err];
    }
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
    NSData *imageData;
    if([self fileSizeAtPath:filePath] > 512*512)
    {
        imageData = UIImageJPEGRepresentation(image, 512*512/[self fileSizeAtPath:filePath]);
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    NSString *hash = [imageData base64EncodedString];
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在上传头像"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MystoreManangerApi buildUploadImageWithStreamData:hash] success:^(id responseObject) {
        @strongify(self);
        [LogStatisticsManager onClickLog:User_ModifyIcon andTev:@""];
        [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"上传成功" afterDelay:2];
        UserHeadImg *headImg = [UserHeadImg yy_modelWithDictionary:responseObject];
        NSString *imageLink=headImg.data.imageUrl?headImg.data.imageUrl:headImg.data.picUrl;
        [US_UserUtility saveUserHeadImgUrl:imageLink];
        UpdateUserListCellModel *cellModel=[self getCurrentCellModeAtIndex:[NSIndexPath indexPathForRow:0 inSection:0]];
        cellModel.headImg=[UIImage imageWithData:imageData];
        cellModel.headImgUrl=@"";
        if (self.sucessBlock) {
            self.sucessBlock(self.mDataArray);
        }
    } failure:^(UleRequestError *error) {
        [(UleBaseViewController*)self.rootVC showErrorHUDWithError:error];
    }];
}
//图片长度
- (long long) fileSizeAtPath:(NSString*) filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}
#pragma mark - <getters>
- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}

- (UpdateUserListCellModel *)getCurrentCellModeAtIndex:(NSIndexPath *)indexPath{
    UpdateUserHeaderModel *sectionModel=[self.mDataArray objectAt:indexPath.section];
    return [sectionModel.cellArray objectAt:indexPath.row];
}
- (NSMutableArray *)getNewSecondCellModelsWithSectionModel:(UpdateUserHeaderModel*)secondSectionModel{
    NSMutableArray *array=[NSMutableArray array];
    NSArray *secondTitles=@[@"真实姓名",@"所属企业",@"所属机构"];
    NSArray *secondContents=@[[US_UserUtility sharedLogin].m_userName,[NSString isNullToString:self.enterpriseName],[self getCurrentOrganizationNameLowest]];
    for (int i=0; i<secondTitles.count; i++) {
        UpdateUserListCellModel *cellModel=[[UpdateUserListCellModel alloc]initWithCellName:@"UpdateUserListCell"];
        cellModel.titleStr=secondTitles[i];
        cellModel.contentStr=secondContents[i];
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [self cellClickAtIndexPath:indexPath];
        };
        if (i==1&&(secondSectionModel.userType==UpdateUserTypeTeam || secondSectionModel.userType==UpdateUserTypeAuth || secondSectionModel.userType==UpdateUserTypeAuthInReview || secondSectionModel.userType==UpdateUserTypeShuaiKang)) {
            cellModel.isHideArrow=YES;
        }else if (i==2&&secondSectionModel.userType==UpdateUserTypeTeam) {
            cellModel.isHideArrow=YES;
        }
        cellModel.isHideLine=i==2?YES:NO;
        [array addObject:cellModel];
    }
    return array;
}
- (NSString *)getCurrentOrganizationNameLowest{
    NSString *lowestOrganName=@"";
    if ([NSString isNullToString:self.substationName].length>0) {
        lowestOrganName=[NSString isNullToString:self.substationName];
    }else if ([NSString isNullToString:self.countryName].length>0) {
        lowestOrganName=[NSString isNullToString:self.countryName];
    }else if ([NSString isNullToString:self.cityName].length>0) {
        lowestOrganName=[NSString isNullToString:self.cityName];
    }else if ([NSString isNullToString:self.provinceName].length>0) {
        lowestOrganName=[NSString isNullToString:self.provinceName];
    }
    return lowestOrganName;
}
- (UpdateUserHeaderModel *)secondSectionModel{
    if (!_secondSectionModel) {
        _secondSectionModel=[[UpdateUserHeaderModel alloc]init];
        _secondSectionModel.headViewName=@"UpdateUserHeaderView1";
        if ([[US_UserUtility sharedLogin].identifiedFlag isEqualToString:@"1"]) {
            //认证用户
            _secondSectionModel.headHeight=70;
            _secondSectionModel.userType=UpdateUserTypeAuth;
            _secondSectionModel.contentStr=@"您是邮乐认证员工，若想修改机构信息需经过审核";
        }else if ([[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"]) {
            _secondSectionModel.headHeight=50;
            _secondSectionModel.userType=UpdateUserTypeShuaiKang;
            _secondSectionModel.contentStr=@"";
        }else {
            _secondSectionModel.headHeight=50;
            _secondSectionModel.userType=UpdateUserTypeNone;
            _secondSectionModel.contentStr=@"";
        }
        _secondSectionModel.titleStr=@"企业信息";
        _secondSectionModel.switchStatus=[US_UserUtility sharedLogin].enterpriseFlag?UpdateUserSwitchStatusOn:UpdateUserSwitchStatusOff;
        if (_secondSectionModel.switchStatus==UpdateUserSwitchStatusOn) {
            [_secondSectionModel.cellArray addObjectsFromArray:[self getNewSecondCellModelsWithSectionModel:_secondSectionModel]];
        }
        @weakify(self);
        _secondSectionModel.quitTeamBlock = ^{
            @strongify(self);
            NSString *action = [NSString stringWithFormat:@"WebDetailViewController::0&&key::%@/event/2018/0816/dist/index.html#/##hasnavi::0",[UleStoreGlobal shareInstance].config.ulecomDomain];
            UleUCiOSAction *moduleAction = [UleModulesDataToAction resolveModulesActionStr:action];
            if (self.rootVC) {
                [self.rootVC pushNewViewController:moduleAction.mViewControllerName isNibPage:moduleAction.mIsXib withData:moduleAction.mParams];
            }
        };
        _secondSectionModel.switchShiftBlock = ^(UISwitch * _Nonnull sw) {
            @strongify(self);
            if (self.mDataArray.count>1) {
                if (!sw.isOn) {
                    self.enterpriseId=@"";
                    self.provinceID=@"";
                    self.cityID=@"";
                    self.countryID=@"";
                    self.substationID=@"";
                    self.enterpriseName=@"";
                    self.provinceName=@"";
                    self.cityName=@"";
                    self.countryName=@"";
                    self.substationName=@"";
                    self->_secondSectionModel.switchStatus=UpdateUserSwitchStatusOn;
                    [self->_secondSectionModel.cellArray removeAllObjects];
                    [self->_secondSectionModel.cellArray addObjectsFromArray:[self getNewSecondCellModelsWithSectionModel:self->_secondSectionModel]];
                    if (self.sucessBlock) {
                        self.sucessBlock(nil);
                    }
                }else {
                    NSDictionary *params=@{@"orgType":self->defaultOrgType,
                                           @"orgProvince":self->defaultProvinceID,
                                           @"orgSwitchStatus":[NSNumber numberWithInteger:UpdateUserSwitchStatusOff]
                                           };
                    US_UpdateUserInfoVC *rootVC=(US_UpdateUserInfoVC*)self.rootVC;
                    [rootVC startRequestModifyUserInfo:params];
                }
            }
        };
    }
    return _secondSectionModel;
}
@end
