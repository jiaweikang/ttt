
//
//  ShareParseTool.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "ShareParseTool.h"
#import "US_NetworkExcuteManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <FileController.h>
#import "NSString+Addition.h"
#import "USImageDownloadManager.h"
#import <TZImageManager.h>
@implementation ShareParseTool

+ (Ule_ShareModel *) frechJsonStrToModel:(NSString *) jsonStr{
    Ule_ShareModel * shareModel=[[Ule_ShareModel alloc] init];
    NSArray *paramsArray = [jsonStr componentsSeparatedByString:@"##"];
    for (NSInteger i = 0; i < [paramsArray count]; i++) {
        switch (i) {
            case 0:
                shareModel.title = paramsArray[0];
                break;
            case 1:
                shareModel.content = paramsArray[1];
                break;
            case 2:
                shareModel.imageUrl = paramsArray[2];
                break;
            case 3:
                shareModel.linkUrl = paramsArray[3];
                break;
            case 4:
                shareModel.title = paramsArray[4];
                break;
            case 5:
                shareModel.jsCallbackFunc = paramsArray[5];
                break;
            default:
                break;
        }
    }
    //防止头像为空不能分享
    if (shareModel.imageUrl.length==0||[shareModel.imageUrl isEqualToString:@"null"]||[shareModel.imageUrl containsString:@"undefined"]) {
        shareModel.imageUrl=@"https://pic.ule.com/item/user_0102/desc20180809/bfba9e1c84be4de5_-1x-1.png";
    }
    shareModel.imageUrl=[NSString removeDuplicateHTTP:shareModel.imageUrl];
    //记录
    if ([shareModel.linkUrl rangeOfString:@"shareId"].location!=NSNotFound) {
        if (shareModel.content.length==0||[shareModel.content isEqualToString:@"null"]) {
            shareModel.content=@"发现一件好商品，分享给你哦!";
        }
        
    }else {//分享店铺
        if (shareModel.content.length==0||[shareModel.content isEqualToString:@"null"]) {
            shareModel.content=@"发现一家好店铺，分享给你哦!";
        }
    }
    return shareModel;
}

+ (void)downloadImagesAndSaveToLocation:(NSArray *)imageList completion:(nonnull void (^)(NSError * _Nonnull))completeBlock{
    NSMutableArray *downImageList=[NSMutableArray array];
    [imageList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<8) {
            if ([obj rangeOfString:@"ule.com"].location!=NSNotFound) {
                obj = [NSString multiShareGetImageUrlString:kImageUrlType_XL withurl:obj];
            }
            [downImageList addObject:obj];
        }
    }];
    [[USImageDownloadManager sharedManager]downloadImageList:downImageList success:^(NSMutableArray * _Nullable resultArr) {
        [imageList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[TZImageManager manager]savePhotoWithImage:[resultArr objectAt:idx] completion:^(PHAsset *asset, NSError *error) {
                if (idx==resultArr.count-1&&!error) {
                    if (completeBlock) {
                        completeBlock(nil);
                    }
                }
            }];
        }];
    } fail:^(NSError * _Nullable error) {
        if (completeBlock) {
            completeBlock(error);
        }
    }];
}

+ (void)saveToPasteboard:(NSString *)targetStr {
    NSString *listName=@"";
    if (targetStr.length>0){
        listName=targetStr;
    }
    NSString *boardStr=[NSString stringWithFormat:@"[识别图中二维码了解更多] %@", [NSString isNullToString:listName].length > 0 ? listName : @""];
    //剪切板
    UIPasteboard *board=[UIPasteboard generalPasteboard];
    [board setString:boardStr];
}
+ (ShareTemplateList *) getLocalShareTemplateModel{
    NSArray *originTempArr=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:TemplateCachePlist]]];
    ShareTemplateList * templateModel=nil;
    for (int i=0; i<originTempArr.count; i++) {
        ShareTemplateList *originList=originTempArr[i];
        if (originList.cellSelected) {
            templateModel=originList;
            break;
        }
    }
    if (templateModel==nil) {
        templateModel=[[ShareTemplateList alloc] init];
        templateModel.modelNo=@"1";
    }
    return templateModel;
}

//清除用户选择的分享模板
+(void)clearUserPickTemplate{
    NSArray *originTempArr=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:TemplateCachePlist]]];
    for (int i=0; i<originTempArr.count; i++) {
        ShareTemplateList *list=originTempArr[i];
        list.cellSelected=NO;
    }
    if (originTempArr.count>0) {
        [NSKeyedArchiver archiveRootObject:originTempArr toFile:[FileController fullpathOfFilename:TemplateCachePlist]];
    }
}
@end
