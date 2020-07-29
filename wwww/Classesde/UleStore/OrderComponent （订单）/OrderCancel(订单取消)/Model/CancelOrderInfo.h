//
//  CancelOrderInfo.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoItemData : NSObject

@property(strong, nonatomic)NSString*      link;
@property(strong, nonatomic)NSString*      _id;
@property(strong, nonatomic)NSString*      imgUrl;
@property(strong, nonatomic)NSString*      sectionId;
@property(strong, nonatomic)NSString*      title;
@property(strong, nonatomic)NSString*      priority;
@property(strong, nonatomic)NSString*      key;
@property(strong, nonatomic)NSString*      attribute1;
@property(strong, nonatomic)NSString*      attribute2;
@property(strong, nonatomic)NSString*      attribute3;
@property(strong, nonatomic)NSString*      attribute4;
@property(strong, nonatomic)NSString*      attribute5;

@end


@interface CancelOrderInfo : NSObject
@property(strong, nonatomic)NSString*      returnMessage;
@property(strong, nonatomic)NSString*      returnCode;
@property(strong, nonatomic)NSString*      total;
@property(strong, nonatomic)NSMutableArray*      indexInfo;
@end
