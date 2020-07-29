//
//  US_OrderCommentViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"
#import "MyWaybillOrderInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_OrderCommentViewModel : UleBaseViewModel

@property (nonatomic, strong) NSMutableArray * picUrlArray;

- (void)handleOriginData:(WaybillOrder *)result;

- (void)frechLabelsInfoDic:(NSDictionary *)dic;

- (void)addUploadImagePicUrlString:(NSString *)picStr forItemId:(NSString *)itemId;

- (NSMutableArray *)getSelectedPicArray;

- (NSString *)getCommentProductId;

- (NSString *)getCommentContent;

- (NSString *)getProductStar;

- (NSString *)getCommentPicsHttpString;

- (NSString *)getLogisticsStar;

- (NSString *)getServersStar;

- (void)cleanCommentPicsUrlArray;
@end

NS_ASSUME_NONNULL_END
