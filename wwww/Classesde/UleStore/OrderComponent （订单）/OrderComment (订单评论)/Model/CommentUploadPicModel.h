//
//  CommentUploadPicModel.h
//  u_store
//
//  Created by jiangxintong on 2018/11/21.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentUploadPicModel : NSObject
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *imageUrl;
@end

@interface CommentUploadPicBaseModel : NSObject
@property (nonatomic, strong) NSString *returnCode;
@property (nonatomic, strong) NSString *returnMessage;
@property (nonatomic, strong) CommentUploadPicModel *data;
@end

NS_ASSUME_NONNULL_END
