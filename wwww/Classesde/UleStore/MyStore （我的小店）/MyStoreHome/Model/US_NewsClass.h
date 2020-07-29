//
//  US_NewsClass.h
//  u_store
//
//  Created by shengyang_yu on 15/12/21.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US_NewsBase : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * url;


@end

@interface US_NewsClass : NSObject

@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * returnCode;
@property (nonatomic, copy) NSString * returnMessage;
@property (nonatomic, copy) NSString * ptime;
@property (nonatomic, copy) NSMutableArray * list;


@end
