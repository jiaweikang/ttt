//
//  CommentTextCellModel.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"

@interface CommentTextCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * productStars;
@property (nonatomic, strong) NSString * commentInfo;
@property (nonatomic, strong) NSString * imgeUrl;
@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) NSMutableArray * labelsArray;
@property (nonatomic, strong) NSMutableArray * selectLabelsArray;//已选label
@property (nonatomic, strong) NSMutableArray * selectCommentPicsArray;
@property (nonatomic, strong) NSMutableArray * selectCommentPicHttpsArray;
@end
