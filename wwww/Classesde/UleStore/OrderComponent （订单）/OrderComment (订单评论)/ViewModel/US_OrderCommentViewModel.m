







//
//  US_OrderCommentViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderCommentViewModel.h"
#import "CommentHeadCellModel.h"
#import "CommentTextCellModel.h"
#import "FeatureModel_UleHome.h"
#import "UleModulesDataToAction.h"
@implementation US_OrderCommentViewModel

- (void)handleOriginData:(WaybillOrder *)result{
    UleSectionBaseModel * sectionOne=[[UleSectionBaseModel alloc] init];
    sectionOne.footHeight=10;
    sectionOne.cellArray=[self handleCommentData:result];
    [self.mDataArray addObject:sectionOne];
    UleSectionBaseModel * sectionTwo=[[UleSectionBaseModel alloc] init];
    CommentHeadCellModel * headCellModel= [self handleServiceData:result];
    [sectionTwo.cellArray addObject:headCellModel];
    [self.mDataArray addObject:sectionTwo];
    
    
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)frechLabelsInfoDic:(NSDictionary *)dic{
    FeatureModel_UleHome * uleFeature=[FeatureModel_UleHome yy_modelWithDictionary:dic];
    if (uleFeature.indexInfo.count<=0||uleFeature==nil) {
        return;
    }
    UleIndexInfo *indexinfo = uleFeature.indexInfo[0];
    NSString *defaultText = indexinfo.default_text;
    NSMutableArray *labelsArr = [NSMutableArray new];
    for (UleIndexInfo *indexInfo in uleFeature.indexInfo) {
        BOOL isCanInput = [UleModulesDataToAction canInputDataMin:indexInfo.minversion withMax:indexInfo.maxversion withDevice:indexInfo.devicetype withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (isCanInput) {
            [labelsArr addObject:indexInfo.label_text];
        }
    }
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    for (int i=0; i<[sectionOne.cellArray count]; i++) {
        CommentTextCellModel *textCellModel = [sectionOne.cellArray objectAt:i];
        textCellModel.commentInfo = defaultText;
        textCellModel.labelsArray = [labelsArr mutableCopy];
    }
    labelsArr = nil;
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (CommentHeadCellModel *)handleServiceData:(WaybillOrder *)myWaybillOrderInfo {
    CommentHeadCellModel *headCellModel = [[CommentHeadCellModel alloc] initWithCellName:@"CommentHeadCell"];
    headCellModel.serverStars = @"5";
    headCellModel.logisticStars = @"5";
    headCellModel.feedback = myWaybillOrderInfo.feedback;
    return headCellModel;
}

- (NSMutableArray *)handleCommentData:(WaybillOrder *)myWaybillOrderInfo {
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (DeleveryInfo *delivery in myWaybillOrderInfo.delevery) {
        for (PrdInfo *item in delivery.prd) {
            if ([item.is_comment isEqualToString:@"false"] && ![item.is_comment isEqual:[NSNull null]]) {
                CommentTextCellModel *textCellModel = [[CommentTextCellModel alloc] initWithCellName:@"CommentTextCell"];
                textCellModel.productStars = @"5";
                textCellModel.imgeUrl = [self getImageUrlFromProductPic:item.product_pic];
                textCellModel.itemId = item.item_id;
                textCellModel.selectLabelsArray = [NSMutableArray new];
                textCellModel.selectCommentPicsArray = [NSMutableArray new];
                textCellModel.selectCommentPicHttpsArray = [NSMutableArray new];
                [modelArray addObject:textCellModel];
            }
        }
        
    }
    return modelArray;
}

- (void)addUploadImagePicUrlString:(NSString *)picStr forItemId:(NSString *)itemId{
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        if ([textCellModel.itemId isEqualToString:itemId]) {
            [textCellModel.selectCommentPicHttpsArray addObject:picStr];
        }
    }
}

- (NSString *)getImageUrlFromProductPic:(NSString *)productPic {
    NSString *imageUrl = @"";
    NSArray *array = [productPic componentsSeparatedByString:@"|*|"];
    if (array.count>0) {
        imageUrl = [NSString getImageUrlString:kImageUrlType_M withurl:array[0]];
    }
    return imageUrl;
}

- (NSMutableArray *)getSelectedPicArray{
    NSMutableArray * selectedPicArray=[[NSMutableArray alloc] init];
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        for (int j=0; j<textCellModel.selectCommentPicsArray.count; j++) {
            NSDictionary *commentPicDic = [NSDictionary dictionaryWithObjectsAndKeys: textCellModel.selectCommentPicsArray[j], @"imageBase64",textCellModel.itemId,@"itemId", nil];
            [selectedPicArray addObject:commentPicDic];
        }
    }
    return selectedPicArray;
}

- (NSString *)getCommentProductId{
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    NSString *prdId = @"";
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel * textCellModel = sectionOne.cellArray[i];
        if (i==0) {
            prdId = textCellModel.itemId;
        } else {
            prdId = [NSString stringWithFormat:@"%@,%@", prdId, textCellModel.itemId];
        }
    }
    return prdId;
}

- (NSString *)getCommentContent{
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    NSString *content = @"";
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        if (i==0) {
            content = textCellModel.commentInfo;
        } else {
            content = [NSString stringWithFormat:@"%@|*|%@", content, textCellModel.commentInfo];
        }
    }
    return content;
}

- (NSString *)getProductStar{
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    NSString *prdStar = @"";
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        if (i==0) {
            prdStar = textCellModel.productStars;
        } else {
            prdStar = [NSString stringWithFormat:@"%@,%@", prdStar, textCellModel.productStars];
        }
    }
    return prdStar;
}

- (NSString *)getCommentPicsHttpString{
    UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    NSString *commentPicsHttpString = @"";
    for (int i=0; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        for (NSString *url in textCellModel.selectCommentPicHttpsArray) {
            commentPicsHttpString = [commentPicsHttpString stringByAppendingString:[NSString stringWithFormat:@"%@,", url]];
        }
        if([commentPicsHttpString length] > 0&&textCellModel.selectCommentPicHttpsArray.count>0){
            commentPicsHttpString = [commentPicsHttpString substringToIndex:([commentPicsHttpString length]-1)]; //去掉最后一个","
        }
        if (i != sectionOne.cellArray.count-1) {
            commentPicsHttpString = [commentPicsHttpString stringByAppendingString:@"|*|"];
        }
    }
    NSLog(@"commentPicsHttpString:%@", commentPicsHttpString);
    return commentPicsHttpString;
}

- (NSString *)getLogisticsStar{
    NSString * logisticStar=@"";
    UleSectionBaseModel * sectionTwo=self.mDataArray.lastObject;
    CommentHeadCellModel * headCellModel= sectionTwo.cellArray.firstObject;
    if (headCellModel) {
        logisticStar=headCellModel.logisticStars;
    }
    return logisticStar;
}

- (NSString *)getServersStar{
    NSString * serversStar=@"";
    UleSectionBaseModel * sectionTwo=self.mDataArray.lastObject;
    CommentHeadCellModel * headCellModel= sectionTwo.cellArray.firstObject;
    if (headCellModel) {
        serversStar=headCellModel.serverStars;
    }
    return serversStar;
}

- (void)cleanCommentPicsUrlArray{
     UleSectionBaseModel * sectionOne=self.mDataArray.firstObject;
    for (int i=0 ; i<sectionOne.cellArray.count; i++) {
        CommentTextCellModel *textCellModel = sectionOne.cellArray[i];
        [textCellModel.selectCommentPicHttpsArray removeAllObjects];
    }
}
@end
