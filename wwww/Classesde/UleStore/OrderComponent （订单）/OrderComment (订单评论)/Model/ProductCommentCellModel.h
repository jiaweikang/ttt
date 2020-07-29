//
//  ProductCommentCellModel.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/25.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
@interface ProductCommentCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString * headImageUrl;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * submitDate;
@property (nonatomic, copy) NSString * productQuality;
@property (nonatomic, copy) NSString * productAttribute;
@property (nonatomic, copy) NSArray * commentImgUrlArray;

//评论列表用到
@property (nonatomic, copy) NSString * merchantExplain;
@property (nonatomic, copy) NSString * merchantPlusExplain;
@property (nonatomic, copy) NSString * plusComment;
//评论列表用到
@end
