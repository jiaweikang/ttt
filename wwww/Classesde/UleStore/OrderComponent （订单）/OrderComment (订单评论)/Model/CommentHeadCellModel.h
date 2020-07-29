//
//  CommentHeadCellModel.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"

@interface CommentHeadCellModel : UleCellBaseModel

@property (nonatomic, strong) NSString * serverStars;
@property (nonatomic, strong) NSString * logisticStars;
@property (nonatomic, strong) NSString * feedback;

@end
