//
//  UserHeadImg.h
//  u_store
//
//  Created by 刘培壮 on 15/5/20.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHeadImgData : NSObject
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *picUrl;
@end

@interface UserHeadImg : NSObject
@property (nonatomic,copy) NSString *returnCode;
@property (nonatomic,copy) NSString *returnMessage;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic, strong) UserHeadImgData *data;
@end