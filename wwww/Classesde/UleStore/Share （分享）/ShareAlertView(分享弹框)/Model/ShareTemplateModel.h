//
//  ShareTemplateModel.h
//  u_store
//
//  Created by xstones on 2017/7/24.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareTemplateList : NSObject <NSCoding>
@property (nonatomic, copy) NSString    *_id;
@property (nonatomic, copy) NSString    *imgUrl;
@property (nonatomic, copy) NSString    *modelNo;
@property (nonatomic, copy) NSString    *sectionId;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *C_CONF_shareImageIFirst;
@property (nonatomic, copy) NSString    *priority;
@property (nonatomic, copy) NSString    *link;
@property (nonatomic, copy) NSString    *shareImagelFirst;
@property (nonatomic, copy) NSString    *key;

@property (nonatomic, assign) BOOL      cellSelected;//是否被选中(记录用户选中的模板)
@end


@interface ShareTemplateModel : NSObject
@property (nonatomic, copy) NSString                *total;
@property (nonatomic, copy) NSString                *returnCode;
@property (nonatomic, strong) NSMutableArray        *indexInfo;
@end
