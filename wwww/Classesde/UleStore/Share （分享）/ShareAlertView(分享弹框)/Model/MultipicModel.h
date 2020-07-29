//
//  MultipicData.h
//  u_store
//
//  Created by xstones on 2017/1/10.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultipicList : NSObject
@property (nonatomic, strong) NSMutableArray    *imageList;
@property (nonatomic, strong) NSMutableArray    *imageList2;
@end

@interface MultipicData : NSObject
@property (nonatomic, strong) NSMutableArray    *resultList;

@end

@interface MultipicModel : NSObject
@property (nonatomic, copy) NSString        *returnCode;
@property (nonatomic, copy) NSString        *returnMessage;
@property (nonatomic, strong) MultipicData  *data;

@end
