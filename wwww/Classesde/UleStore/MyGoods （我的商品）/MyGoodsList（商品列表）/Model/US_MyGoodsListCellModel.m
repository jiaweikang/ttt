//
//  US_MyGoodsListCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsListCellModel.h"
#import "US_EnterpriseDataModel.h"
#import "TakeSelfModel.h"
#import <NSAttributedString+YYText.h>
#import "US_EnterpriseWholeSaleModel.h"

@implementation US_MyGoodsListCellModel
- (instancetype)initWithRecommendData:(US_MyGoodsRecommendDetail *)recommend andCellName:(NSString *)cellName{
    self = [super initWithCellName:cellName];
    if (self) {
        self.data=recommend;
        self.listId=[NSString stringWithFormat:@"%@", recommend.listingId];
        self.commission=[NSString stringWithFormat:@"%@",recommend.dgTotalCommission];
        self.marketPrice=[NSString stringWithFormat:@"%@",recommend.maxPrice];
        self.salePrice=[NSString stringWithFormat:@"%@",recommend.minPrice];
        self.listName=[NSString stringWithFormat:@"%@",recommend.listingName];
        self.imgUrl=[NSString stringWithFormat:@"%@",recommend.imgUrl];
        self.sellTotal=[NSString stringWithFormat:@"%@",recommend.sellTotal];
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
    }
    return self;
}
- (instancetype)initWithFavorites:(Favorites *) favorites andCellName:(NSString *)cellName{
    self = [super initWithCellName:cellName];
    if (self) {
        self.data=favorites;
        self.listId=[NSString stringWithFormat:@"%@",favorites.listId];
        NSString * name=favorites.listName.length>0?favorites.listName:favorites.listingName;
        self.listName=[NSString stringWithFormat:@"%@",name];
        self.salePrice=[NSString stringWithFormat:@"%@",favorites.salePrice];
        self.marketPrice=[NSString stringWithFormat:@"%@",favorites.marketPrice];
        self.commission=[NSString stringWithFormat:@"%@",favorites.commistion];
        self.imgUrl=[NSString stringWithFormat:@"%@",favorites.imgUrl];
        self.sellTotal=[NSString isNullToString:[NSString stringWithFormat:@"%@",favorites.totalSold]];
        self.addTime=[self tranformData:favorites.updateTime];
        self.hiddenAddBtn=YES;
        self.listingState=[NSString stringWithFormat:@"%@",favorites.listingState];
        self.instock=[NSString stringWithFormat:@"%@",favorites.instock];
        self.groupbuyFlag=[NSString stringWithFormat:@"%@",favorites.groupFlag];
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
        self.listingType=[NSString stringWithFormat:@"%@",favorites.listingType];
        self.listMarkAttribute=[self buildMarkImageAttributeStr:favorites];
    }
    return self;
}

- (instancetype)initWithFenxiaoFavorites:(Favorites *)favorites andCellName:(NSString *)cellName{
    self=[super initWithCellName:cellName];
    if (self) {
        self.data=favorites;
        self.listId=[NSString stringWithFormat:@"%@",favorites.listId];
        NSString * name=favorites.listName.length>0?favorites.listName:favorites.listingName;
        self.listName=[NSString stringWithFormat:@"%@",name];
        self.salePrice=[NSString isNullToString:[NSString stringWithFormat:@"%@",favorites.salePrice]];
        self.marketPrice=[NSString stringWithFormat:@"%@",favorites.marketPrice];
//        self.commission=[NSString stringWithFormat:@"%@",favorites.commistion];
        self.imgUrl=[NSString stringWithFormat:@"%@",favorites.imgUrl];
        self.sellTotal=[NSString isNullToString:[NSString stringWithFormat:@"%@",favorites.totalSold]];
        self.addTime=[self tranformData:favorites.updateTime];
        self.hiddenAddBtn=YES;
        if ([[NSString isNullToString:[NSString stringWithFormat:@"%@",favorites.listingState]] isEqualToString:@"2"] || [self.salePrice doubleValue]==0)
        {
            self.isFenxiaoOutStock=YES;
        }
        self.hiddenShareBtn=self.isFenxiaoOutStock;
//        self.instock=[NSString stringWithFormat:@"%@",favorites.instock];
//        self.groupbuyFlag=[NSString stringWithFormat:@"%@",favorites.groupFlag];
//        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
//        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
//        self.listingType=[NSString stringWithFormat:@"%@",favorites.listingType];
//        self.listMarkAttribute=[self buildMarkImageAttributeStr:favorites];
        self.isFenXiao=YES;
        self.zoneId=[NSString stringWithFormat:@"%@", favorites.thirdPlatformId];
        self.packageSpec=[self getFenxiaoFavListPackageSpec:favorites];
    }
    return self;
}

- (instancetype)initWithEnterprise:(US_EnterpriseRecommendList *)enterRecommend andCellName:(NSString *)cellName
{
    if (self = [super initWithCellName:cellName]) {
        self.data = enterRecommend;
        self.listId = [NSString stringWithFormat:@"%@", enterRecommend.listId];
        self.listName = [NSString stringWithFormat:@"%@", enterRecommend.listName];
        self.salePrice = [NSString stringWithFormat:@"%@", enterRecommend.minPrice];
        self.marketPrice = [NSString stringWithFormat:@"%@", enterRecommend.maxPrice];
        self.commission = [NSString stringWithFormat:@"%@", enterRecommend.commission];
        self.imgUrl = [NSString stringWithFormat:@"%@", enterRecommend.defImgUrl];
        self.sellTotal = [NSString stringWithFormat:@"%@", enterRecommend.totalSold];
        self.hiddenAddBtn = NO;
        //创建Favorites模型
        Favorites *favorModel = [[Favorites alloc]init];
        favorModel.promotionIds=@"";
        for (PromotionList *proItem in enterRecommend.promotionList) {
            NSString *proItemID = [NSString isNullToString:[NSString stringWithFormat:@"%@", proItem._id]];
            if (proItemID.length>0){
                if ([NSString isNullToString:favorModel.promotionIds].length>0) {
                    favorModel.promotionIds = [favorModel.promotionIds stringByAppendingString:[NSString stringWithFormat:@" %@", proItemID]];
                }else {
                    favorModel.promotionIds = [favorModel.promotionIds stringByAppendingString:proItemID];
                }
            }
        }
        favorModel.merchantFreightPay = [enterRecommend.services containsObject:@"7"]?@"-1":@"1";
        favorModel.limitWay = [NSNumber numberWithInt:[enterRecommend.limitWay intValue]];
        favorModel.listingTag=enterRecommend.listingTag;
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
        self.listMarkAttribute=[self buildMarkImageAttributeStr:favorModel];
    }
    return self;
}

- (instancetype)initWithSearchGoods:(RecommendModel *)recommend{
    self = [super initWithCellName:@"US_MyGoodsListCell"];
    if (self) {
        self.data=recommend;
        self.listId=[NSString stringWithFormat:@"%@",recommend.listId];
        self.listName=[NSString stringWithFormat:@"%@",recommend.listName];
        self.salePrice = [NSString stringWithFormat:@"%@", recommend.minPrice];
        self.marketPrice = [NSString stringWithFormat:@"%@", recommend.maxPrice];
        self.commission = [NSString stringWithFormat:@"%@", recommend.commission];
        self.imgUrl = [NSString stringWithFormat:@"%@", recommend.defImgUrl];
        self.sellTotal = [NSString stringWithFormat:@"%@", recommend.totalSold];
        self.hiddenAddBtn=NO;
        self.groupbuyFlag=[NSString stringWithFormat:@"%@",recommend.groupFlag];
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
        self.listMarkAttribute=[self buildMarkImageWithRecommend:recommend];
    }
    return self;
}
- (instancetype)initWithTakeSelfData:(TakeSelfIndexInfo *)takself{
    self = [super initWithCellName:@"US_MyGoodsListCell"];
    if (self) {
        self.data=takself;
        self.listId = [NSString stringWithFormat:@"%@", takself.listingId];
        self.listName = [NSString stringWithFormat:@"%@", takself.customTitle];
        self.salePrice = [NSString stringWithFormat:@"%@", takself.salePrice];
        self.commission = [NSString stringWithFormat:@"%@", takself.commission];
        self.groupbuyFlag=[NSString stringWithFormat:@"%@",takself.groupFlag];
        //自提列表 团购商品隐藏分享按钮
        self.hiddenShareBtn=[self.groupbuyFlag isEqualToString:@"1"];
        NSString *imgUrlStr = [NSString isNullToString:(takself.imageList.count>0?takself.imageList[0]:@"")];
        self.imgUrl = [NSString stringWithFormat:@"%@", imgUrlStr];
        self.sellTotal = [NSString stringWithFormat:@"%@", takself.totalSold];
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
        Favorites *favorModel = [[Favorites alloc]init];
        favorModel.listingTag=[NSString isNullToString:takself.listingTag];
        self.listMarkAttribute=[self buildMarkImageAttributeStr:favorModel];
    }
    return self;
}
- (instancetype)initWithUleSyncWebFavorite:(WebFavoriteList *)webFavorite{
    self = [super initWithCellName:@"US_MyGoodsListCell"];
    if (self) {
        self.data=webFavorite;
        self.listId=[NSString stringWithFormat:@"%@",webFavorite.listingId];
        self.listName=[NSString stringWithFormat:@"%@",webFavorite.listingName];
        self.salePrice = [NSString stringWithFormat:@"%@", webFavorite.listingPrice];
        self.marketPrice = @"";
        self.commission = [NSString stringWithFormat:@"%@", webFavorite.commission];
        self.imgUrl = [NSString stringWithFormat:@"%@", webFavorite.listingImage];
        self.sellTotal = @"";
        self.addTime=[self tranformData:webFavorite.createTime];
        self.groupbuyFlag=[NSString stringWithFormat:@"%@",webFavorite.groupFlag];
        self.isEditStatus=YES;
        self.hiddenAddBtn=YES;
        self.synced=[NSString stringWithFormat:@"%@", webFavorite.ylxdIsSave];
        self.listingState=self.synced;
        self.commissionStr=[self buildCommissionStrWithValue:self.commission];
        self.commissionWidth=[self calculateCommissionWidth:self.commissionStr];
    }
    return self;
}

- (instancetype)initWithEnterpriseWholeSale:(EnterpriseWholeSaleList *)wholeSaleList{
    self = [super initWithCellName:@"US_MyGoodsListCell"];
    if (self) {
        self.data=wholeSaleList;
        self.isFenXiao=YES;
        self.listId=[NSString stringWithFormat:@"%@",wholeSaleList.listId];
        self.zoneId=[NSString stringWithFormat:@"%@",wholeSaleList.zoneId];
        self.listName=[NSString stringWithFormat:@"%@",wholeSaleList.listName];
        self.salePrice = [NSString stringWithFormat:@"%.2lf", [wholeSaleList.sharePrice doubleValue]];
        self.marketPrice = @"";
        self.imgUrl=[NSString stringWithFormat:@"%@", wholeSaleList.defImgs];
        self.packageSpec=[self getEnterpriseFenxiaoListPackageSpec:wholeSaleList];
    }
    return self;
}

//企业分销商品列表规格
- (NSString *)getEnterpriseFenxiaoListPackageSpec:(EnterpriseWholeSaleList *)wholeSaleList{
    NSString *specStr=@"";
    NSString *startSpec=@"";
    NSString *packageSpec=[NSString isNullToString:[NSString stringWithFormat:@"%@", wholeSaleList.packageSpec]];//商品规格
    NSString *beginNum=[NSString isNullToString:[NSString stringWithFormat:@"%@", wholeSaleList.tagInfo.beginNum]];
    beginNum=beginNum.length==0?@"1":beginNum;
    NSString *packageUnit=[NSString isNullToString:[NSString stringWithFormat:@"%@", wholeSaleList.packageUnit]];
    if (beginNum.length>0&&packageUnit.length>0) {
        startSpec=[NSString stringWithFormat:@"%@%@", beginNum, packageUnit];//起售规格
    }
    if (startSpec.length>0) {
        startSpec=[startSpec stringByAppendingString:@"起售"];
    }
    if (packageSpec.length>0&&startSpec.length>0) {
        specStr=[NSString stringWithFormat:@"%@ | %@", packageSpec, startSpec];
    }else {
        specStr=[NSString stringWithFormat:@"%@%@", packageSpec, startSpec];
    }
    return specStr;
}

//分销收藏列表 规格
- (NSString *)getFenxiaoFavListPackageSpec:(Favorites *)fav{
    NSString *realPackageCount=[NSString isNullToString:[NSString stringWithFormat:@"%@", fav.realPackageCount]];
    NSString *sellUnitSingle=[NSString isNullToString:[NSString stringWithFormat:@"%@", fav.sellUnitSingle]];
    NSString *sellUnit=[NSString isNullToString:[NSString stringWithFormat:@"%@", fav.sellUnit]];
    NSString *limitNum=[NSString isNullToString:[NSString stringWithFormat:@"%@", fav.limitNum]];
    limitNum=limitNum.length==0?@"1":limitNum;
    
    NSString *spec=@"";//规格
    NSString *startSpec=@"";//起售规格
    NSString *boxSell=[NSString isNullToString:[NSString stringWithFormat:@"%@", fav.boxSell]];
    if ([boxSell isEqualToString:@"1"]) {
        //装箱
        if (realPackageCount.length>0&&sellUnitSingle.length>0&&sellUnit.length>0) {
            spec=[NSString stringWithFormat:@"%@%@/%@", realPackageCount, sellUnitSingle, sellUnit];
        }
        if (limitNum.length>0&&sellUnit.length>0) {
            startSpec=[NSString stringWithFormat:@"%@%@起售", limitNum, sellUnit];
        }
    }else {
        //不装箱
        if (limitNum.length>0&&sellUnitSingle.length>0) {
            startSpec=[NSString stringWithFormat:@"%@%@起售", limitNum, sellUnitSingle];
        }
    }
    NSString *packageSpec=@"";
    if (spec.length>0&&startSpec.length>0) {
        packageSpec=[NSString stringWithFormat:@"%@ | %@", spec, startSpec];
    }else packageSpec=[NSString stringWithFormat:@"%@%@", spec, startSpec];
    return packageSpec;
}

- (NSString *)tranformData:(NSString *)createTime{
    NSString * result=@"";
    if (createTime.length >= 10) {
        result = [NSString stringWithFormat:@"%@",[createTime substringToIndex:10]];
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    } else {
        result = [NSString stringWithFormat:@"%@",createTime];
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    }
    return result;
}


- (NSString *)buildCommissionStrWithValue:(NSString *)commission{
    if ([commission doubleValue]==0) return @"";
    else {
        NSString * str= [NSString stringWithFormat:@"赚：￥%.2lf",[commission doubleValue]];
        if ([US_UserUtility commisionTitle].length>0) {
            str = [[US_UserUtility commisionTitle] stringByReplacingOccurrencesOfString:@"XXX" withString:[NSString stringWithFormat:@"%.2f", [commission doubleValue]]];
        }
        return str;
    }
}

- (CGFloat)calculateCommissionWidth:(NSString *)commission{
    CGSize size=[NSString getSizeOfString:commission withFont:[UIFont systemFontOfSize:KScreenScale(24)] andMaxWidth:300];
    CGFloat width=size.width+KScreenScale(30);
    if (commission.length<=0||(self.groupbuyFlag.length>0&&[self.groupbuyFlag isEqualToString:@"1"])) {
        width=0;
    }
    return width;
}

- (NSMutableAttributedString *)buildMarkImageAttributeStr:(Favorites *)favorites{
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc] initWithString:@""];
    NSString *promotionIDs=[NSString stringWithFormat:@"%@",favorites.promotionIds];
    NSArray *proArr=[promotionIDs componentsSeparatedByString:@" "];
    NSMutableArray * images=[[NSMutableArray alloc] init];
    //限数量
    if (favorites.limitWay&&[favorites.limitWay intValue]!=0) {
        UIImage * buyNumlimitImage=[NSString transforImageWithTargetText:@"限数量" withColor:[UIColor convertHexToRGB:@"fda331"] andBorderColor:[UIColor convertHexToRGB:@"fda331"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:buyNumlimitImage];
    }
    //限地区
    for (NSString *item in proArr) {
        if ([item intValue]==13) {
            UIImage * arealimitImage=[NSString transforImageWithTargetText:@"限地区" withColor:[UIColor convertHexToRGB:@"fd8446"] andBorderColor:[UIColor convertHexToRGB:@"fd8446"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
            [images addObject:arealimitImage];
            break;
        }
    }
    //免运费
    NSString *freeShip=[NSString stringWithFormat:@"%@",favorites.merchantFreightPay];
    if ([freeShip isEqualToString:@""]||[freeShip isEqualToString:@"(null)"]||[freeShip isEqualToString:@"-1"]||[freeShip rangeOfString:@"-1"].location!=NSNotFound) {
        UIImage * freeshipImage=[NSString transforImageWithTargetText:@"免运费" withColor:[UIColor convertHexToRGB:@"f04a48"] andBorderColor:[UIColor convertHexToRGB:@"f04a48"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:freeshipImage];
    }
    //先赔
    if ([[NSString stringWithFormat:@"%@",favorites.listingTag] containsString:@"1666"]) {
        UIImage * prePayImage=[NSString transforImageWithTargetText:@"先赔" withColor:[UIColor convertHexToRGB:@"1DBF78"] andBorderColor:[UIColor convertHexToRGB:@"1DBF78"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:prePayImage];
    }
    for (int i = 0; i < [images count]; i ++) {
        UIImage * labelImage=images[i];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = labelImage;                                  //设置图片源
        textAttachment.bounds = CGRectMake(0, -3, labelImage.size.width, labelImage.size.height);//设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
        NSMutableAttributedString *spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
        CGFloat insertposition=0;
        [result insertAttributedString:spaceString atIndex: insertposition];
        [result insertAttributedString: attrStr atIndex: insertposition];
    }
    return result;
}

- (NSMutableAttributedString *)buildMarkImageWithRecommend:(RecommendModel *)recommend{
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc] initWithString:@""];
    
    NSMutableArray * images=[[NSMutableArray alloc] init];
    //限数量
    if (recommend.limitWay&&[recommend.limitWay intValue]!=0) {
        UIImage * buyNumlimitImage=[NSString transforImageWithTargetText:@"限数量" withColor:[UIColor convertHexToRGB:@"fda331"] andBorderColor:[UIColor convertHexToRGB:@"fda331"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:buyNumlimitImage];
    }
    //限地区 促销是否限区域(id包含13)
    if (recommend.promotionList&&recommend.promotionList.count>0) {
        for (PromotionListData *proD in recommend.promotionList) {
            if ([proD._id integerValue]==13) {
                UIImage * arealimitImage=[NSString transforImageWithTargetText:@"限地区" withColor:[UIColor convertHexToRGB:@"fd8446"] andBorderColor:[UIColor convertHexToRGB:@"fd8446"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
                [images addObject:arealimitImage];
                break;
            }
        }
    }
    //免运费
    if (recommend.services&&[recommend.services containsObject:@"7"]) {
        UIImage * freeshipImage=[NSString transforImageWithTargetText:@"免运费" withColor:[UIColor convertHexToRGB:@"f04a48"] andBorderColor:[UIColor convertHexToRGB:@"f04a48"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:freeshipImage];
    }
    //先赔
    if ([[NSString stringWithFormat:@"%@",recommend.listingTag] containsString:@"1666"]) {
        UIImage * prePayImage=[NSString transforImageWithTargetText:@"先赔" withColor:[UIColor convertHexToRGB:@"1DBF78"] andBorderColor:[UIColor convertHexToRGB:@"1DBF78"] andBorderWidth:0.6 andFont:[UIFont boldSystemFontOfSize:KScreenScale(22)]];
        [images addObject:prePayImage];
    }
    for (int i = 0; i < [images count]; i ++) {
        UIImage * labelImage=images[i];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = labelImage;                                  //设置图片源
        textAttachment.bounds = CGRectMake(0, -3, labelImage.size.width, labelImage.size.height);//设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
        NSMutableAttributedString *spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
        CGFloat insertposition=0;
        [result insertAttributedString:spaceString atIndex: insertposition];
        [result insertAttributedString: attrStr atIndex: insertposition];
    }
    return result;
}

@end
