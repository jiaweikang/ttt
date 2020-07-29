//
//  MyFavoritesLists.m
//  u_store
//
//  Created by shengyang_yu on 15/11/3.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "MyFavoritesLists.h"

@implementation PromotionListModel

@end

@implementation Favorites
@synthesize salePrice;
@synthesize standardPrice;
@synthesize marketPrice;
@synthesize imgUrl;
@synthesize listId;
@synthesize listName;
@synthesize listingName;
@synthesize categoryName;
@synthesize categoryId;
@synthesize listDesc;
@synthesize commission;
@synthesize commistion;
@synthesize updateTime;
@synthesize listingState;
@synthesize instock;
@synthesize saleRange;
@synthesize limitWay;
@synthesize limitNum;
@synthesize promotionList;
@synthesize promotionIds;
@synthesize listPromotionDesc;
@synthesize listPromotionName;
@synthesize totalSold;
@synthesize createTime;
@synthesize services;
@synthesize merchantFreightPay;
@synthesize isSelected;
@synthesize sharePrice;
@synthesize frameId;
@synthesize salPrice;
@synthesize content;
@synthesize isImgLoaded;
@synthesize categoryIds;
@synthesize idForCate;
@synthesize noCancelSelect;
@synthesize groupFlag;
@synthesize listingType;
-(instancetype)init
{
    if (self=[super init]) {
        isSelected=NO;
        isImgLoaded=NO;
    }
    return self;
}


@end

@implementation MyFavoritesListData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"result" : [Favorites class]};
}


@end

@implementation MyFavoritesLists

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [MyFavoritesListData class]};
}
@end
