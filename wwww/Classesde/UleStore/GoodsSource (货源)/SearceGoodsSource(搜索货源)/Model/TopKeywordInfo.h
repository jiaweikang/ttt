//
//  TopKeywordInfo.h
//  UleApp
//
//  Created by chenzhuqing on 2017/3/28.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopKeywordInfo : NSObject

@property(nonatomic,copy) NSString *requestNum;
@property(nonatomic,copy) NSString *keyWord;

@end


@interface TopKeywordRequestBack : NSObject
@property(nonatomic,copy) NSString        *returnCode;
@property(nonatomic,copy) NSString        *returnMessage;
@property(nonatomic,strong) NSMutableArray  *keyWordInfo;

@end
