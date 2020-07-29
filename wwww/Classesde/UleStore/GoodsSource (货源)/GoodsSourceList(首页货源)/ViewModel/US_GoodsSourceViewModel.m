//
//  US_GoodsSourceViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceViewModel.h"
#import "UleSectionBaseModel.h"
#import "US_GoodsSourceApi.h"
#import "US_HomeBtnData.h"
#import "UleModulesDataToAction.h"
#import "US_GoodsSectionModel.h"
#import "US_GoodsCellModel.h"
#import "US_GoodsCatergoryListData.h"
#import "FeatureModel_UleHome.h"
#import "FeatureModel_HomeBanner.h"
#import "FeatureModel_HomeRecommend.h"
#import "US_GoodsSourceBannerView.h"
#import "FeatureModel_GIFRefresh.h"
#import "FeatureModel_HomeBanner.h"
#import "FeaturedModel_HomeScrollBar.h"
#import "US_GoodsSourceScrollBarView.h"
#import "NSArray+Extension.h"
#import "US_GoodsSourceNewsFlashView.h"
#import "USImageDownloadManager.h"
@interface US_GoodsSourceViewModel ()
@property (nonatomic, strong) NSMutableArray * recommendArray;//推荐商品
@property (nonatomic, strong) NSMutableArray * selfRecommendArray;//
@property (nonatomic, strong) NSMutableArray * youliaoArray;//有料商品
//@property (nonatomic, strong) NSMutableArray * bottomBannerArray;//底部banner样式推荐商品
@property (nonatomic, strong) NSMutableArray * storeyArray;//可变顺序图片
@property (nonatomic, strong) NSMutableArray * secondStoreyArray;//
@property (nonatomic, strong) NSMutableArray * newsFlashArray;
@property (nonatomic, strong) NSMutableArray * homeBottomRecommendArray;
@property (nonatomic, copy) NSString       * scrollBarBgUrlStr;//滚动条背景图

@end

@implementation US_GoodsSourceViewModel
//处理首页分类商品数据
- (void)handleCatergoryListData:(US_GoodsCatergoryListData *)catergoryList refreshData:(BOOL)refresh{
    US_GoodsSectionModel * sectionModel =[self getSectionModeWithIdentify:@"categoryList"];
    if (sectionModel==nil) {
        sectionModel=[[US_GoodsSectionModel alloc] init];
        sectionModel.identify=@"categoryList";
        [self.mDataArray addObject:sectionModel];
    }
    if (refresh==YES&&sectionModel.cellArray) {
        [sectionModel.cellArray removeAllObjects];
    }
    sectionModel.columns=2;
    sectionModel.headHeight=KScreenScale(10);
    for (int i=0; i<catergoryList.data.result.count; i++) {
        US_GoodsCatergoryListItem * item=catergoryList.data.result[i];
        US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithHomeCategoryListItem:item];
        cellModel.shareFrom = @"1";
        cellModel.shareChannel = @"1";
        cellModel.logPageName = @"首页商品推荐";
        cellModel.logShareFrom = @"商品列表";
        cellModel.commsisionWidth=[self getCommisionWidth:item.commission];
        [sectionModel.cellArray addObject:cellModel];
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}
//处理分类商品列表头部banner数据
- (void)fetchCatergoryBannerDicInfo:(NSDictionary *)dic bannerKey:(nonnull NSString *)bannerKey{
    FeatureModel_HomeBanner * recommend=[FeatureModel_HomeBanner yy_modelWithDictionary:dic];
    if (recommend && recommend.indexInfo.count>0) {
        NSMutableArray * bannerModel=[[NSMutableArray alloc] init];
        for (HomeBannerIndexInfo * info in recommend.indexInfo) {
            BOOL caninput=[UleModulesDataToAction canInputDataMin:info.min_version withMax:info.max_version withDevice:info.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
            if (caninput) {
                US_GoodsSourceBannerViewModel * banner=[[US_GoodsSourceBannerViewModel alloc] initWithCategoryBannerData:info];
                banner.moduleId=bannerKey;
                [bannerModel addObject:banner];
            }
        }
        US_GoodsSourceBannerSectionModel *mSectionData=[[US_GoodsSourceBannerSectionModel alloc]init];
        mSectionData.currentViewType=USGoodsSourceBannerTypeGoodsList;
        mSectionData.bannerImageModels=bannerModel;
        
        HomeBannerIndexInfo * info=recommend.indexInfo.firstObject;
        CGFloat bannerHeight = [info.wh_rate floatValue]>0 ? __MainScreen_Width/[info.wh_rate floatValue] : __MainScreen_Width/2.14;
        US_GoodsSectionModel * sectionModel =[self getSectionModeWithIdentify:@"TopBanner"];
        if (sectionModel==nil) {
            sectionModel=[[US_GoodsSectionModel alloc] init];
            sectionModel.identify=@"TopBanner";
            [self.mDataArray insertObject:sectionModel atIndex:0];
        }
        sectionModel.headViewName=@"US_GoodsSourceBannerView";
        sectionModel.headHeight=bannerHeight;
        sectionModel.sectionData=mSectionData;
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

//推荐商品
- (void)fetchHomeRecommendDicInfor:(NSDictionary *)dic{
    FeatureModel_HomeRecommend * homeRecommend=[FeatureModel_HomeRecommend yy_modelWithDictionary:dic];
    if (self.recommendArray.count>0) {
        [self.recommendArray removeAllObjects];
    }
    for (int i=0; i<homeRecommend.data.count; i++) {
        NewHomeRecommendData * data=homeRecommend.data[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:data.min_version withMax:data.max_version withDevice:data.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (canInput) {
            [self.recommendArray addObject:data];
        }
    }
}
//处理首页有料商品
- (void)fetchHomeYouliaoDicInfo:(NSDictionary *)dic{
    FeatureModel_UleHome * youliao=[FeatureModel_UleHome yy_modelWithDictionary:dic];
    if (self.youliaoArray.count>0) {
        [self.youliaoArray removeAllObjects];
    }
    if (youliao.indexInfo.count>0) {
        [self.youliaoArray addObjectsFromArray:youliao.indexInfo];
    }
}
//处理首页底部大banner商品
- (void)fetchHomeStoreyDicInfo:(NSDictionary *)dic{
    FeatureModel_HomeBanner * homeBanner=[FeatureModel_HomeBanner yy_modelWithDictionary:dic];
//    if (self.bottomBannerArray.count>0) {
//        [self.bottomBannerArray removeAllObjects];
//    }
    if (self.storeyArray.count>0) {
        [self.storeyArray removeAllObjects];
    }
    if (self.secondStoreyArray.count>0) {
        [self.secondStoreyArray removeAllObjects];
    }
    if (self.newsFlashArray.count>0) {
        [self.newsFlashArray removeAllObjects];
    }
    HomeBannerIndexInfo  * dragViewIndexInfo=nil;
    for (int i=0; i<homeBanner.indexInfo.count; i++) {
        HomeBannerIndexInfo * indexInfo= homeBanner.indexInfo[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:indexInfo.min_version withMax:indexInfo.max_version withDevice:indexInfo.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
//        if ([indexInfo.key isEqualToString:@"poststore_index_bottom_banner"]) {
//            if (canInput&&[indexInfo.groupid isEqualToString:@"7"]) {
//                [self.bottomBannerArray addObject:indexInfo];
//            }
//            if (canInput&&[indexInfo.groupid isEqualToString:@"6"]) {
//                dragViewIndexInfo=indexInfo;
//            }
//        }else
        NSString * sectionKeyStory1= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_index_storey);
        NSString * sectionKeyStory2= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_index_storeySecond);
        if (canInput) {
            if ([indexInfo.key isEqualToString:sectionKeyStory1]) {
                if ([indexInfo.groupid isEqualToString:@"6"]) {
                    dragViewIndexInfo=indexInfo;
                }else if ([indexInfo.groupid isEqualToString:@"12"]){
                    //滚动条背景图
                    self.scrollBarBgUrlStr=[NSString isNullToString:indexInfo.background_url_new];
                }else if ([indexInfo.groupid isEqualToString:@"13"]){
                    //首页顶部背景图
                    self.bannerBgViewUrlStr=[NSString isNullToString:indexInfo.background_url_new];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_HomeTopBGImageDone object:indexInfo];
                }else if ([indexInfo.groupid isEqualToString:@"14"]){
                    //快报数据
                    [self.newsFlashArray addObject:indexInfo];
                }else if ([indexInfo.groupid isEqualToString:@"15"]){
                    //首页导航栏和分类背景图
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_HomeNaviBGImageDone object:indexInfo];
                }
                else{
                    [self.storeyArray addObject:indexInfo];
                }
            }else if ([indexInfo.key isEqualToString:sectionKeyStory2]) {
                [self.secondStoreyArray addObject:indexInfo];
            }
        }
    }
    //排序
//    [self.bottomBannerArray  sortUsingComparator:^NSComparisonResult(HomeBannerIndexInfo *  obj1, HomeBannerIndexInfo *  obj2) {
//        return [@([[obj1 priority] intValue]) compare:@([[obj2 priority] intValue])];
//    }];
    if (dragViewIndexInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_DragViewShow object:dragViewIndexInfo];
    }
}

//滚动条
- (void)fetchHomeScrollBarDicInfo:(NSDictionary *)dic{
    FeaturedModel_HomeScrollBar *homeScroll=[FeaturedModel_HomeScrollBar yy_modelWithDictionary:dic];
    self.scrollBarArray=homeScroll.data;
}

- (void)fetchHomeBottomRecommendDicInfo:(NSDictionary *)dic{
    FeatureModel_HomeRecommend * homeBottomRecommend=[FeatureModel_HomeRecommend yy_modelWithDictionary:dic];
    if (self.homeBottomRecommendArray.count>0) {
        [self.homeBottomRecommendArray removeAllObjects];
    }
    for (int i=0; i<homeBottomRecommend.data.count; i++) {
        NewHomeRecommendData * data=homeBottomRecommend.data[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:data.min_version withMax:data.max_version withDevice:data.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (canInput) {
            [self.homeBottomRecommendArray addObject:data];
        }
    }
}

- (void)fetchSelfRecommendGoodsDicInfo:(NSDictionary *)dic{
    FeatureModel_HomeRecommend * homeRecommend=[FeatureModel_HomeRecommend yy_modelWithDictionary:dic];
    if (self.selfRecommendArray.count>0) {
        [self.selfRecommendArray removeAllObjects];
    }
    for (int i=0; i<homeRecommend.data.count; i++) {
        NewHomeRecommendData * data=homeRecommend.data[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:data.min_version withMax:data.max_version withDevice:data.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (canInput) {
            [self.selfRecommendArray addObject:data];
        }
    }
}

#pragma mark - <private function>
- (US_GoodsSectionModel *)getSectionModeWithIdentify:(NSString *)identify{
    US_GoodsSectionModel * sectionModel=nil;
    for (US_GoodsSectionModel * model in self.mDataArray) {
        if ([model.identify isEqualToString:identify]) {
            sectionModel=model;
            break;
        }
    }
    return sectionModel;
}

- (void )addBannerRecomendAndInsuranceViewIsSelfRecommend:(BOOL)isSelf{
    //解析推荐位数，筛选头部banner，推荐商品，维保等数据
    NSMutableArray *bannerArray=[NSMutableArray array];
    NSMutableArray *goodsNoOrder = [[NSMutableArray alloc] init];
    NSMutableArray *goodsOrder = [[NSMutableArray alloc] init];
    NSMutableArray *jifenGoods = [[NSMutableArray alloc] init];
    for (int i=0; i<self.recommendArray.count; i++) {
        NewHomeRecommendData * itemData=self.recommendArray[i];
        if ([itemData.moduleKey containsString:@"yxdstore_index_banner_163"]) {
            [bannerArray addObject:itemData];
        } else if ([itemData.moduleKey isEqualToString:@"ylxd_store_index168"]) {
            if (![itemData.groupsort isEqualToString:@""] && ![itemData.groupsort isEqual:[NSNull null]] && itemData.groupsort!=nil) {
                [goodsOrder addObject:itemData];
            } else {
                [goodsNoOrder addObject:itemData];
            }
        } else if ([itemData.moduleKey isEqualToString:@"ylxd_store_index_jifen_168"]) {
            [jifenGoods addObject:itemData];
        } else if ([itemData.moduleKey isEqualToString:@"poststore_index_insurance"]) {
            [self addSecureDataModel:itemData];
        }
    }
    [goodsOrder sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [@([[obj1 groupsort] intValue]) compare:@([[obj2 groupsort] intValue])];
    }];
    NSMutableArray *goodsAll = [[NSMutableArray alloc] init];
    [goodsAll addObjectsFromArray:jifenGoods];
    [goodsAll addObjectsFromArray:goodsOrder];
    [goodsAll addObjectsFromArray:goodsNoOrder];
    [self addTopBannerModel:bannerArray];
    //添加推荐商品
    if (isSelf) {
        [self addSelfRecommendGoodsView];
    }else {
        [self addRecommendGoodsModel:goodsAll];
    }
}

- (void)addSelfRecommendGoodsView{
    [self addRecommendGoodsModel:self.selfRecommendArray];
}

- (void)structureCellModelsIsHomeRecommend:(BOOL)isSelf{
    if (self.mDataArray.count>0) {
        [self.mDataArray removeAllObjects];
    }
    //解析推荐位数数据，构建、筛选头部banner，推荐商品，维保等Cell
    [self addBannerRecomendAndInsuranceViewIsSelfRecommend:isSelf];
    //g添加滚动条
    [self addScrollBarCell];
    //cs后台可配单元
    [self addStoreySection];
    //在推荐商品中插入有料（前面有两个商品）
    [self insertYouliaoCell];
    //添加更多商品提示条
    [self addMoreGoodsSectionHeaderView];
    //添加快报
    [self addNewsFlash];
    //底部推荐商品
    [self addHomeBottomRecommendCell];
    //在底部添加底部商品banner
//    [self addBottomBannersCell];
    //添加footer
    [self addBottomFooterView];
    //对所有Section进行排序
    [self.mDataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         return [@([[obj1 groupsort] intValue]) compare:@([[obj2 groupsort] intValue])];
    }];
    //回调刷新列表
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)addTopBannerModel:(NSMutableArray *)bannerArray{
    if (bannerArray.count>0) {
        US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"0" andSortId:@"0"];
        NewHomeRecommendData *recommend=[bannerArray firstObject];
        CGFloat height = [recommend.wh_rate floatValue]>0 ? (__MainScreen_Width-KScreenScale(40))/[recommend.wh_rate floatValue] : (__MainScreen_Width-KScreenScale(40))/2.14;
        height+=KScreenScale(10);
        sectionModel.headHeight=height;
        sectionModel.headViewName = @"US_GoodsSourceBannerView";
        sectionModel.footHeight=0;
        NSMutableArray * banners=(NSMutableArray *)sectionModel.sectionData;
        if (banners==nil) {
            banners=[[NSMutableArray alloc] init];
        }
        US_GoodsSourceBannerSectionModel *mSectionData=[[US_GoodsSourceBannerSectionModel alloc]init];
        mSectionData.currentViewType=USGoodsSourceBannerTypeHomeBanner;
        mSectionData.backgroundImageUrlStr=self.bannerBgViewUrlStr;
        for (NewHomeRecommendData *item in bannerArray) {
            US_GoodsSourceBannerViewModel * bannerModel=[[US_GoodsSourceBannerViewModel alloc] initWithHomeItemData:item];
            bannerModel.moduleId=@"首页banner点击";
            [mSectionData.bannerImageModels addObject:bannerModel];
        }
        sectionModel.sectionData=mSectionData;
    }
}
    
- (void)addScrollBarCell{
    if (self.scrollBarArray.count>0) {
        US_GoodsSectionModel *sectionModel=[self findSectionModelWithId:@"1" andSortId:@"1"];
        [sectionModel.cellArray removeAllObjects];
        sectionModel.columns=1;
        sectionModel.footHeight=0;
        sectionModel.headHeight=40;
        sectionModel.headViewName=@"US_GoodsSourceScrollBarView";
        US_GoodsSourceScrollBarViewModel *headerModel=[[US_GoodsSourceScrollBarViewModel alloc]initWithHomeScrollBar:self.scrollBarArray];
        headerModel.backgroundUrlStr=self.scrollBarBgUrlStr;
        sectionModel.sectionData=headerModel;
    }
}
//添加楼层
- (void)addStoreySection{
    [self addStoreySectionWithData:self.storeyArray andModelId:@"2" andSortId:@"2"];
    [self addStoreySectionWithData:self.secondStoreyArray andModelId:@"8" andSortId:@"8"];
}

- (void)addStoreySectionWithData:(NSMutableArray *)dataArray andModelId:(NSString *)modelId andSortId:(NSString *)sortId{
    if (dataArray.count>0) {
        US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:modelId andSortId:sortId];
        sectionModel.layoutType=US_CustemLinearLayout;
        sectionModel.footHeight=5;
        NSMutableArray *sortNumArray=[NSMutableArray array];
        NSMutableDictionary *cellTypeDic=[NSMutableDictionary dictionary];
        for (HomeBannerIndexInfo *item in dataArray) {
            if ([cellTypeDic.allKeys containsObject:item.groupsort]) {
                NSMutableArray *array=[cellTypeDic objectForKey:item.groupsort];
                [array addObject:item];
            }else if ([NSString isNullToString:item.groupsort].length>0){
                NSMutableArray *array=[NSMutableArray arrayWithObject:item];
                [cellTypeDic setObject:array forKey:item.groupsort];
                [sortNumArray addObject:item.groupsort];
            }
        }
        /*排序*/
        [sortNumArray sortUsingComparator:^NSComparisonResult(NSString  * obj1, NSString  * obj2) {
            return [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        /*排序*/
        for (NSString *groupSort in sortNumArray) {
            NSMutableArray *sortTypeArray=[cellTypeDic objectForKey:groupSort];
            [sortTypeArray sortUsingComparator:^NSComparisonResult(HomeBannerIndexInfo  * obj1, HomeBannerIndexInfo  * obj2) {
                return [@([[obj1 priority] intValue]) compare:@([[obj2 priority] intValue])];
            }];
            HomeBannerIndexInfo *firstItem=[sortTypeArray firstObject];
            if ([firstItem.groupid intValue]==8) {
                US_GoodsCellModel *btnsCellModel=[[US_GoodsCellModel alloc]initWithStoreyBtns:sortTypeArray];
                [sectionModel.cellArray addObject:btnsCellModel];
            }else {
                /*过滤数据 小于规定数量不显示，大于规定数量只显示规定数量*/
                if ([firstItem.groupid intValue]==9&&sortTypeArray.count>1) {
                    [sortTypeArray removeObjectsInRange:NSMakeRange(1, sortTypeArray.count-1)];
                }else if ([firstItem.groupid intValue]==10) {
                    if (sortTypeArray.count<2) {
                        [sortTypeArray removeAllObjects];
                    }else if (sortTypeArray.count>2){
                        [sortTypeArray removeObjectsInRange:NSMakeRange(2, sortTypeArray.count-2)];
                    }
                }else if ([firstItem.groupid intValue]==11) {
                    if (sortTypeArray.count<3) {
                        [sortTypeArray removeAllObjects];
                    }else if (sortTypeArray.count>3){
                        [sortTypeArray removeObjectsInRange:NSMakeRange(3, sortTypeArray.count-3)];
                    }
                }
                /*过滤数据 小于规定数量不显示，大于规定数量只显示规定数量*/
                for (HomeBannerIndexInfo *itemInfo in sortTypeArray) {
                    switch ([itemInfo.groupid intValue]) {
                        case 9:
                        {
                            US_GoodsCellModel *cellModel=[[US_GoodsCellModel alloc]initWithStoreyListItem:itemInfo widthRatio:1.0];
                            [sectionModel.cellArray addObject:cellModel];
                        }
                            break;
                        case 10:
                        {
                            US_GoodsCellModel *cellModel=[[US_GoodsCellModel alloc]initWithStoreyListItem:itemInfo widthRatio:0.5];
                            [sectionModel.cellArray addObject:cellModel];
                        }
                            break;
                        case 11:
                        {
                            US_GoodsCellModel *cellModel=[[US_GoodsCellModel alloc]initWithStoreyListItem:itemInfo widthRatio:1/3.0];
                            [sectionModel.cellArray addObject:cellModel];
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
}

- (void)addSecureDataModel:(NewHomeRecommendData *)recommend{
    US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"3" andSortId:@"3"];
    sectionModel.columns=1;
    sectionModel.footHeight=5;
    US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithSecureDataItem:recommend];
    cellModel.shareChannel=@"1";
    cellModel.shareFrom=@"1";
    cellModel.logPageName=@"首页推荐";
    cellModel.logShareFrom=@"保险";
    [sectionModel.cellArray addObject:cellModel];
}
    
- (void)addRecommendGoodsModel:(NSMutableArray *)itemArray{
    if (itemArray.count>0) {
        US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"4" andSortId:@"4"];
        sectionModel.headViewName=@"US_GoodsSourceRecommendHeader";
        sectionModel.headHeight=40;
        sectionModel.columns=2;
        sectionModel.footHeight=KScreenScale(4);
        for (int i=0; i<2&&itemArray.count>i; i++) {
            NewHomeRecommendData * recommend=(NewHomeRecommendData *)[itemArray objectAt:i];
            US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithRecommendItem:recommend];
            cellModel.shareChannel=@"1";
            cellModel.shareFrom=@"1";
            cellModel.logPageName = @"首页商品推荐";
            cellModel.logShareFrom = @"商品列表";
            [sectionModel.cellArray addObject:cellModel];
        }
        US_GoodsSectionModel * sectionModel2=[self findSectionModelWithId:@"6" andSortId:@"6"];
        sectionModel2.columns=2;
        sectionModel2.footHeight=KScreenScale(4);
        for (int i=2; i<itemArray.count; i++) {
            NewHomeRecommendData * recommend=(NewHomeRecommendData *) itemArray[i];
            US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithRecommendItem:recommend];
            cellModel.shareChannel=@"1";
            cellModel.shareFrom=@"1";
            cellModel.logPageName = @"首页商品推荐";
            cellModel.logShareFrom = @"商品列表";
            [sectionModel2.cellArray addObject:cellModel];
        }
    }
}

- (void)insertYouliaoCell{
    US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"5" andSortId:@"5"];
    sectionModel.columns=1;
    sectionModel.footHeight=KScreenScale(4);
    if (self.youliaoArray.count>0) {
        UleIndexInfo * indexInfo=(UleIndexInfo *) self.youliaoArray.firstObject;
        US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithYouLiaoItem:indexInfo];
        [sectionModel.cellArray addObject:cellModel];
    }
}

- (void)addMoreGoodsSectionHeaderView{
    for (NewHomeRecommendData * itemData in self.recommendArray) {
        if ([NSString isNullToString:itemData.more_title].length>0) {
            US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"7" andSortId:@"7"];
            sectionModel.headHeight=40;
            sectionModel.headViewName=@"US_GoodsSourceSectionHeader";
            sectionModel.sectionData=itemData;
//            sectionModel.footHeight=5;
            break;
        }
    }
}

- (void)addNewsFlash{
    if (self.newsFlashArray.count>0) {
        US_GoodsSectionModel *sectionModel=[self findSectionModelWithId:@"9" andSortId:@"9"];
        sectionModel.headViewName=@"US_GoodsSourceNewsFlashView";
        sectionModel.headHeight=30+KScreenScale(10);
        US_GoodsSourceNewsFlashModel *model=[[US_GoodsSourceNewsFlashModel alloc]init];
        model.newsDataArr=self.newsFlashArray;
        sectionModel.sectionData=model;
    }
}

- (void)addHomeBottomRecommendCell{
    if (self.homeBottomRecommendArray.count>0) {
        US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"10" andSortId:@"10"];
        sectionModel.layoutType=US_CustemLinearLayout;
        sectionModel.footHeight=5;
        NSMutableArray *sortNumArray=[NSMutableArray array];
        NSMutableDictionary *cellTypeDic=[NSMutableDictionary dictionary];
        for (NewHomeRecommendData *item in self.homeBottomRecommendArray) {
            if ([cellTypeDic.allKeys containsObject:item.groupsort]) {
                NSMutableArray *array=[cellTypeDic objectForKey:item.groupsort];
                [array addObject:item];
            }else if ([NSString isNullToString:item.groupsort].length>0) {
                NSMutableArray *array=[NSMutableArray arrayWithObject:item];
                [cellTypeDic setObject:array forKey:item.groupsort];
                [sortNumArray addObject:item.groupsort];
            }
        }
        /*排序*/
        [sortNumArray sortUsingComparator:^NSComparisonResult(NSString  * obj1, NSString  * obj2) {
            return [@([obj1 intValue]) compare:@([obj2 intValue])];
        }];
        /*排序*/
        for (NSString *groupSort in sortNumArray) {
            NSMutableArray *sortTypeArray=[cellTypeDic objectForKey:groupSort];
            [sortTypeArray sortUsingComparator:^NSComparisonResult(HomeBannerIndexInfo  * obj1, HomeBannerIndexInfo  * obj2) {
                return [@([[obj1 priority] intValue]) compare:@([[obj2 priority] intValue])];
            }];
            US_GoodsCellModel *btnsCellModel=[[US_GoodsCellModel alloc]initWithHomeBottomRecommend:sortTypeArray];
            if (btnsCellModel.bottomBannerModel || (btnsCellModel.bottomBannerModel&&btnsCellModel.btnsArray.count>=3)) {
                btnsCellModel.shareChannel=@"1";
                btnsCellModel.shareFrom=@"1";
                btnsCellModel.logPageName = @"首页商品推荐";
                btnsCellModel.logShareFrom = @"商品列表";
                [sectionModel.cellArray addObject:btnsCellModel];
            }
        }
    }
}

//- (void)addBottomBannersCell{
//    US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"9" andSortId:@"9"];
//    sectionModel.columns=1;
//    sectionModel.footHeight=5;
//    for (int i=0; i<self.bottomBannerArray.count; i++) {
//        HomeBannerIndexInfo * indexInfo =self.bottomBannerArray[i];
//        US_GoodsCellModel * cellModel=[[US_GoodsCellModel alloc] initWithHomeBannerIndexInfo:indexInfo];
//        [sectionModel.cellArray addObject:cellModel];
//    }
//}

- (void)addBottomFooterView{
    US_GoodsSectionModel * sectionModel=[self findSectionModelWithId:@"100" andSortId:@"100"];
    sectionModel.footHeight=50;
    sectionModel.footViewName=@"US_GoodsSourceFooter";
}

- (US_GoodsSectionModel *)findSectionModelWithId:(NSString *)groupid andSortId:(NSString *)groupsort{
    US_GoodsSectionModel * sectionModel=nil;
    for (int i=0; i<self.mDataArray.count; i++) {
        US_GoodsSectionModel * tempModel=(US_GoodsSectionModel * )self.mDataArray[i];
        if ([tempModel.groupid isEqualToString:groupid]) {
            sectionModel=tempModel;
        }
    }
    if (sectionModel==nil) {
        sectionModel=[[US_GoodsSectionModel alloc] init];
        sectionModel.groupid=groupid;
        sectionModel.groupsort=groupsort;
        [self.mDataArray addObject:sectionModel];
    }
    return sectionModel;
}

- (void)fetchHomeGIFRefreshDicInfo:(NSDictionary *)dic{
    FeatureModel_GIFRefresh * gifInfor=[FeatureModel_GIFRefresh yy_modelWithDictionary:dic];
    BOOL hasGIFRefres=NO;
    for (int i=0; i<gifInfor.indexInfo.count; i++) {
        GIFRefreshIndexInfo * indexItem=gifInfor.indexInfo[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:indexItem.min_version withMax:indexItem.max_version withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (canInput && [indexItem.refreshModel isEqualToString:@"1"]){
            [self refreshHomeGif:indexItem.imageUrl img:indexItem.imgUrl];
            hasGIFRefres=YES;
            break;
        }
    }
    if (!hasGIFRefres) {
        if (self.gifRefreshUpdate) {
            self.gifRefreshUpdate(nil, nil);
        }
    }
}
//919红包雨首页gif缓存本地处理
- (void)refreshHomeGif:(NSString *)gif img:(NSString *)img {
    NSString *imgBackStr = img;
    NSString *gifStr = gif;
    __block NSData *imgBackData=nil;
    __block NSData *gifData=nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t disp = dispatch_semaphore_create(0);
        [[USImageDownloadManager sharedManager]asyncDownloadWithLink:imgBackStr success:^(NSData * _Nullable data) {
            imgBackData=data;
            dispatch_semaphore_signal(disp);
        } fail:^(NSError * _Nullable error) {
        }];
        dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        [[USImageDownloadManager sharedManager]asyncDownloadWithLink:gifStr success:^(NSData * _Nullable data) {
            gifData=data;
            dispatch_semaphore_signal(disp);
        } fail:^(NSError * _Nullable error) {
        }];
        dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UserDefaultManager setLocalDataObject:imgBackData key:kUserDefault_HomeRefreshView];
            [UserDefaultManager setLocalDataObject:gifData key:kUserDefault_HomeGifView];
            if (self.gifRefreshUpdate) {
                self.gifRefreshUpdate(imgBackData, gifData);
            }
        });
    });
}
#pragma mark - ScrollerView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offSetY = scrollView.contentOffset.y;
//    CGFloat alpha;
//    if (offSetY<=0) {
//        alpha=0.0;
//    }else{
//        alpha=offSetY/200;
//    }
//    [self.uleCustemNavigationBar ule_setBackgroundAlpha:alpha];
//    [UIView animateWithDuration:0.2 animations:^{
//        if (offSetY<0) {
//            self.uleCustemNavigationBar.alpha=0.0;
//        }else{
//            self.uleCustemNavigationBar.alpha=1.0;
//        }
//    }];
//    if (self.collectionViewScrollBlock) {
//        self.collectionViewScrollBlock(offSetY);
//    }
//}
#pragma mark - <setter and getter>
- (CGFloat)getCommisionWidth:(NSNumber * )commissionValue{
    CGFloat width=0.0;
    NSString *commission = (commissionValue) ? ([NSString stringWithFormat:@"%@", commissionValue]) : (commissionValue ? [NSString stringWithFormat:@"%@", commissionValue] : @"0.00");
    if ([[NSString stringWithFormat:@"%.2f", [commission floatValue]] isEqualToString:@"0.00"]) {
        width=0.0;
    }else{
        NSString * showStr = [NSString stringWithFormat:@"赚:¥%.2f", [commission floatValue]];
        if ([US_UserUtility commisionTitle].length>0) {
            showStr = [[US_UserUtility commisionTitle] stringByReplacingOccurrencesOfString:@"XXX" withString:[NSString stringWithFormat:@"%.2f", [commission floatValue]]];
        }
        CGSize size=[NSString getSizeOfString:showStr withFont:[UIFont systemFontOfSize:KScreenScale(24)] andMaxWidth:300];
        width=size.width+KScreenScale(30);
    }
    return width;
}
- (NSMutableArray<US_GoodsSectionModel *> *)modulesArray{
    if (!_modulesArray) {
        _modulesArray=[[NSMutableArray alloc] init];
    }
    return _modulesArray;
}
- (NSMutableArray *)recommendArray{
    if (!_recommendArray) {
        _recommendArray=[NSMutableArray new];
    }
    return _recommendArray;
}
- (NSMutableArray *)selfRecommendArray{
    if (!_selfRecommendArray) {
        _selfRecommendArray=[NSMutableArray array];
    }
    return _selfRecommendArray;
}
- (NSMutableArray *)scrollBarArray{
    if (!_scrollBarArray) {
        _scrollBarArray=[NSMutableArray new];
    }
    return _scrollBarArray;
}
- (NSMutableArray *)youliaoArray{
    if (!_youliaoArray) {
        _youliaoArray=[NSMutableArray new];
    }
    return  _youliaoArray;
}
//- (NSMutableArray *)bottomBannerArray{
//    if (!_bottomBannerArray) {
//        _bottomBannerArray=[NSMutableArray new];
//    }
//    return _bottomBannerArray;
//}
- (NSMutableArray *)storeyArray{
    if (!_storeyArray) {
        _storeyArray=[NSMutableArray array];
    }
    return _storeyArray;
}
- (NSMutableArray *)secondStoreyArray{
    if (!_secondStoreyArray) {
        _secondStoreyArray=[NSMutableArray array];
    }
    return _secondStoreyArray;
}
- (NSMutableArray *)newsFlashArray{
    if (!_newsFlashArray) {
        _newsFlashArray=[NSMutableArray array];
    }
    return _newsFlashArray;
}
- (NSMutableArray *)homeBottomRecommendArray{
    if (!_homeBottomRecommendArray) {
        _homeBottomRecommendArray=[NSMutableArray array];
    }
    return _homeBottomRecommendArray;
}
@end
