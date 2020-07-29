//
//  AuthorizeRealViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "AuthorizeRealViewModel.h"
#import "AuthorizeCellModel.h"
#import "US_QueryAuthInfo.h"

@implementation AuthorizeRealViewModel

- (void)handleAuthorizeInfo:(CertificationInfo *)info
{
    NSArray *imageNameList = @[@"authorize_img_icon_name",@"authorize_img_icon_id",@"authorize_img_icon_phone"];
    NSArray *textList = @[[NSString isNullToString:info.usrName],[NSString isNullToString:info.idcardNo],[NSString isNullToString:info.mobileNumber]];
    UleSectionBaseModel *sectionModel = [[UleSectionBaseModel alloc]init];
    sectionModel.headHeight = KScreenScale(10);
    for (int i=0; i<3; i++) {
        AuthorizeCellModel *cellModel = [[AuthorizeCellModel alloc]initWithCellName:@"AuthorizeRealNameCell"];
        cellModel.imageName = [imageNameList objectAt:i];
        cellModel.titleText = [textList objectAt:i];
        [sectionModel.cellArray addObject:cellModel];
    }
    UleSectionBaseModel *sectionModel1 = [[UleSectionBaseModel alloc]init];
    sectionModel1.headHeight = KScreenScale(20);
    AuthorizeCellModel *cellModel1 = [[AuthorizeCellModel alloc]initWithCellName:@"AuthorizeRealNameCell1"];
    cellModel1.imageName = @"authorize_img_icon_bank";
    cellModel1.titleText = @"中国邮政储蓄银行";
    cellModel1.contentText = info.cardNo;
    [sectionModel1.cellArray addObject:cellModel1];
    [self.mDataArray addObjectsFromArray:@[sectionModel,sectionModel1]];
}

@end
