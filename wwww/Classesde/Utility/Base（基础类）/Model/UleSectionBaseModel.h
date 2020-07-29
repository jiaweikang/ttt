//
//  UleSectionBaseModel.h
//  UleApp
//
//  Created by chenzhuqing on 2018/11/14.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UleSectionBaseModel : NSObject
@property (nonatomic, strong) NSString * headViewName;
@property (nonatomic, strong) NSString * footViewName;
@property (nonatomic, assign) CGFloat headHeight;
@property (nonatomic, assign) CGFloat footHeight;
@property (nonatomic, strong) NSMutableArray * cellArray;
@property (nonatomic, strong) NSString * identify;
@property (nonatomic, strong) id sectionData;
@property (nonatomic, strong) id headData;
@property (nonatomic, strong) id footData;

- (instancetype) initWithIdentifier:(NSString *) identify;
@end

NS_ASSUME_NONNULL_END
