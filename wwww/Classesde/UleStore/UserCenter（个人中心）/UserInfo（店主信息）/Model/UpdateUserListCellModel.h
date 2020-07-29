//
//  UpdateUserListCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpdateUserListCellModel : UleCellBaseModel
@property(nonatomic, copy)NSString  *titleStr;
@property(nonatomic, copy)NSString  *subTitleStr;
@property(nonatomic, strong)UIImage  *headImg;
@property(nonatomic, copy)NSString  *headImgUrl;
@property(nonatomic, copy)NSString  *contentStr;
@property(nonatomic, assign)BOOL    isHideArrow;
@property(nonatomic, assign)BOOL    isHideLine;
@end

NS_ASSUME_NONNULL_END
