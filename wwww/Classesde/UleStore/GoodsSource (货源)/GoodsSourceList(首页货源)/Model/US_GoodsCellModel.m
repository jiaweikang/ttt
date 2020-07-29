//
//  US_GoodsCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/7.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsCellModel.h"
#import "FeaturedModel_HomeScrollBar.h"
#import "FileController.h"
#import "NSString+FTDate.h"

@implementation US_GoodsCellModel


//- (instancetype)initWithItem:(HomeBtnItem *)item{
//    self = [super init];
//    if (self) {
//        _item=item;
//        NSInteger groupID=[_item.groupid integerValue];
//        switch (groupID) {
//            case 1:{
//                self.height=__MainScreen_Width/2.14;
//                self.weidth=__MainScreen_Width;
//                self.cellName = @"US_GoodsSourceBannerView";
//            }
//                break;
//            case 2:{;
//                self.cellName=@"US_GoodsSourceGroupBuyCell";
//                self.weidth=__MainScreen_Width;
//                self.height=150;
//            }
//                
//                break;
//            case 3:{
//                self.cellName=@"US_GoodsSourceProfitCell";
//                self.minItemSpace=0.5;
//                self.weidth=(__MainScreen_Width-0.5)/2.0;
//                self.height= KScreenScale(520);
//            }
//                break;
//            case 4:{
//                self.cellName=@"US_GoodsSourceListCell";
//                self.minItemSpace=10;
//                self.minLinSpace=10;
//                self.minCellOffset=10;
//                self.weidth=(__MainScreen_Width-self.minCellOffset*2-self.minItemSpace)/2.0;
//                self.height= KScreenScale(328);
//                
//            }
//                break;
//            case 1000:
//                break;
//                
//            default:
//                break;
//        }
//    }
//    return self;
//}

- (instancetype)initWithRecommendItem:(NewHomeRecommendData *)item{
    self = [super initWithCellName:@"US_GoodsHomeType1Cell"];
    if (self) {
        self.data=item;
        self.isSharedToday=[self judgeSharedTodayByListID:item.listingId];
        self.minItemSpace=KScreenScale(14);
        self.minLinSpace=KScreenScale(14);
        self.minCellOffset=KScreenScale(20);
        self.weidth=(__MainScreen_Width-self.minCellOffset*2-self.minItemSpace)/2.0;
        self.height= KScreenScale(570);//self.isSharedToday?KScreenScale(545):KScreenScale(520);
        NSString * imageUrl=@"";
        if (item.imgUrl.length>0) {
            imageUrl=item.imgUrl;
        }else if (item.customImgUrl.length>0){
            imageUrl=item.customImgUrl;
        }
        self.imgeUrl=imageUrl;
        self.listingId=item.listingId;
        self.minPrice=item.salePrice;
        self.maxPrice=@"";
        NSInteger saleCount = [item.sales_volume integerValue]+[item.totalSold integerValue];
        self.totalSold=[NSString stringWithFormat:@"%@",@(saleCount)];
        self.listingName=item.customTitle;
        self.commission=item.commission;
        self.iconImage=item.iconImage;
        self.isJifen=item.jiFenListing;
        self.jifenPrice=item.jiFenPrice;
        self.jifenTitle=item.jiFenTitle;
    }
    return self;
}

- (instancetype)initWithHomeBannerIndexInfo:(HomeBannerIndexInfo *)item{
    self = [super initWithCellName:@"US_GoodsHomeType2Cell"];
    if (self) {
        self.data=item;
        self.imgeUrl=item.imgUrl;
        self.weidth=__MainScreen_Width;
        CGFloat width=__MainScreen_Width-10;
        CGFloat height = [item.wh_rate floatValue]>0 ? width/[item.wh_rate floatValue] : width/2.14;
        self.height=height;
        self.minLinSpace=5;
      
    }
    return self;
}

- (instancetype)initWithYouLiaoItem:(UleIndexInfo *)item{
    self = [super initWithCellName:@"US_GoodsHomeType3Cell"];
    if (self) {
        self.data=item;
        self.imgeUrl=item.imgUrl;
        self.weidth=__MainScreen_Width;
        self.height= KScreenScale(180)+10;
    }
    return self;
}

- (instancetype)initWithSecureDataItem:(NewHomeRecommendData *)item{
    self = [super initWithCellName:@"US_GoodsHomeType4Cell"];
    if (self) {
        self.data=item;
        self.weidth=__MainScreen_Width;
        self.height=KScreenScale(180);
        self.minLinSpace=5;
    }
    return self;
}

- (instancetype)initWithHomeCategoryListItem:(US_GoodsCatergoryListItem *)item{
    self = [super initWithCellName:@"US_GoodsSourceListCell"];
    if (self) {
        self.data=item;
        self.minItemSpace=5;
        self.minLinSpace=5;
        self.minCellOffset=5;
        self.weidth=(__MainScreen_Width-self.minCellOffset*2-self.minItemSpace)/2.0;
        self.height= KScreenScale(520);
        self.imgeUrl=item.imgUrl;
        self.listingId=item.listingId;
        self.minPrice=item.salePrice;
        self.maxPrice=@"";
        self.totalSold=[NSString stringWithFormat:@"%@",item.totalSold];
        self.listingName=item.listingName;
        self.commission=[item.commission stringValue];
//        self.iconImage=item.iconImage;
        
    }
    return self;
}

- (instancetype)initWithStoreyBtns:(NSMutableArray *)array{
    if (self=[super initWithCellName:@"US_GoodsSourceStoreyCell"]) {
        HomeBannerIndexInfo *item=[array firstObject];
        self.minCellOffset=0;
        self.minLinSpace=0;
        self.weidth=__MainScreen_Width;
        CGFloat height=KScreenScale(136)+KScreenScale(18);
        if (array.count>10) {
            height=KScreenScale(136)*2+KScreenScale(26)+KScreenScale(50);
        }else if (array.count>5){
            height=KScreenScale(136)*2+KScreenScale(26)+KScreenScale(20);
        }
        self.height=height;
        self.btnsArray=array;
        self.sortId=item.groupsort;
    }
    return self;
}

- (instancetype)initWithStoreyListItem:(HomeBannerIndexInfo *)item widthRatio:(CGFloat)ratio{
    if (self=[super initWithCellName:@"US_GoodsSourceStoreyCell1"]) {
        self.minCellOffset=0;
        self.minLinSpace=0;
        CGFloat cellWidth=__MainScreen_Width*ratio;
        CGFloat cellHeight=[item.wh_rate floatValue]>0?cellWidth/[item.wh_rate floatValue]:cellWidth/2.14;
        self.weidth=cellWidth;
        self.height=cellHeight;
        self.imgeUrl=[NSString isNullToString:item.imgUrl];
        self.iosActionStr=[NSString isNullToString:item.ios_action];
        self.log_title=[NSString isNullToString:item.log_title];
        self.sortId=item.groupsort;
    }
    return self;
}

- (instancetype)initWithHomeBottomRecommend:(NSMutableArray *)array{
    if (self=[super initWithCellName:@"US_GoodsHomeType2Cell"]) {
        self.weidth=__MainScreen_Width;
        self.minLinSpace=KScreenScale(20);
        NSMutableArray *goodsModelArr=[NSMutableArray array];
        for (NewHomeRecommendData *item in array) {
            if ([item.groupid isEqualToString:@"8"]) {
                [goodsModelArr addObject:item];
            }else if ([item.groupid isEqualToString:@"7"]) {
                self.bottomBannerModel=item;
            }
        }
        self.btnsArray=goodsModelArr;
        CGFloat height=0.0;
        if (self.btnsArray.count>=3) {
            if (self.bottomBannerModel) {
                height=(__MainScreen_Width-KScreenScale(40))*0.4+KScreenScale(400);
                if ([self.bottomBannerModel.wh_rate floatValue]>0) {
                    height=(__MainScreen_Width-KScreenScale(40))/[self.bottomBannerModel.wh_rate floatValue]+KScreenScale(400);
                }
            }
//            else height=KScreenScale(375);
        }else if (self.bottomBannerModel){
            height=(__MainScreen_Width-KScreenScale(40))*0.4;
            if ([self.bottomBannerModel.wh_rate floatValue]>0) {
                height=(__MainScreen_Width-KScreenScale(40))/[self.bottomBannerModel.wh_rate floatValue];
            }
        }
        self.height=height;
    }
    return self;
}

- (BOOL)judgeSharedTodayByListID:(NSString *)listId{
    NSDictionary *dic=[FileController loadNSDictionaryForDocument:kCacheFile_homeShared];
    if (dic) {
        NSDictionary *userDic=[dic objectForKey:kSectionKey_homeShared];
        NSArray *array=[userDic objectForKey:[NSString dateToStringWithFormat:[NSDate date] format:@"yyyyMMdd"]];
        if ([array containsObject:listId]) {
            return YES;
        }
        return NO;
    }
    return NO;
}
- (BOOL)saveSharedTodayByListID:(NSString *)listId{
    NSString *key_date=[NSString dateToStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    NSDictionary *cacheDic=[FileController loadNSDictionaryForDocument:kCacheFile_homeShared];
    if (cacheDic) {
        NSMutableDictionary *dateDic=[cacheDic objectForKey:kSectionKey_homeShared] ;
        NSArray *savedListArray=[dateDic objectForKey:key_date];
        if (savedListArray) {
            NSMutableArray *newListIDArray=[NSMutableArray arrayWithArray:savedListArray];
            if ([newListIDArray containsObject:listId]) {
                return YES;
            }else{
                [newListIDArray addObject:listId];
                [dateDic setObject:newListIDArray forKey:key_date];
            }
        }else{
            [dateDic removeAllObjects];
            NSMutableArray *listIDArray=[NSMutableArray arrayWithObject:listId];
            [dateDic setObject:listIDArray forKey:key_date];
        }
        [FileController saveNSDictionaryForDocument:cacheDic FileUrl:kCacheFile_homeShared];
    }else{
        NSMutableArray *listIDArray=[NSMutableArray arrayWithObject:listId];
        NSDictionary *dateDic=@{key_date:listIDArray};
        NSDictionary *saveDic=@{kSectionKey_homeShared:dateDic};
        [FileController saveNSDictionaryForDocument:saveDic FileUrl:kCacheFile_homeShared];
    }
    return NO;
}

- (CGFloat)calculateWidthWithColumn:(NSInteger)column{
    if (column<=0) {
        return 0.0;
    }
    return (__MainScreen_Width-self.minItemSpace*(column-1)-2*self.minCellOffset)/column;
}

//    
//- (CGFloat)minCellOffset{
////    if (!_minCellOffset) {
////        _minCellOffset=0.0;
////    }
//    return 0.0;
//}
//- (CGFloat)minItemSpace{
////    if (!_minItemSpace) {
////        _minItemSpace=0.5;
////    }
//    return 0.5;
//}
//- (CGFloat)minLinSpace{
////    if (!_minLinSpace) {
////        _minLinSpace=0.5;
////    }
//    return 0.5;
//}
@end
