//
//  ShareParseTool.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ule_ShareView.h>
#import "USShareModel.h"
#import "ShareTemplateModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShareParseTool : NSObject

+ (Ule_ShareModel *) frechJsonStrToModel:(NSString *) jsonStr;

+ (void)downloadImagesAndSaveToLocation:(NSArray *)imageList completion:(void(^)(NSError *error))completeBlock;

+ (void)saveToPasteboard:(NSString *)targetStr;

+ (ShareTemplateList *) getLocalShareTemplateModel;

//清除用户选择的分享模板
+(void)clearUserPickTemplate;
@end

NS_ASSUME_NONNULL_END
