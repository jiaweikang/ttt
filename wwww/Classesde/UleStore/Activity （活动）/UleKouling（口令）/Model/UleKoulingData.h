//
//  UleKoulingData.h
//  UleApp
//
//  Created by ZERO on 2019/2/20.
//  Copyright © 2019年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UleKoulingButtonInfo : NSObject
@property (nonatomic,strong) NSString *buttonImgUrl;
@property (nonatomic,strong) NSString *buttonText; //没有值的话显示默认
@property (nonatomic,strong) NSString *iosAction;

@end

@interface UleKoulingListInfo : NSObject
@property (nonatomic,strong) NSString *listId;
@property (nonatomic,strong) NSString *listName;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *productUrl;   //商品图片
@end

@interface UleKoulingShareInfo : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *desc;
@end

@interface UleKoulingData : NSObject

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *type;   // 0 活动页或其他  1 商品
@property (nonatomic,strong) UleKoulingShareInfo *shareInfo;
@property (nonatomic,strong) UleKoulingListInfo *listInfo;
@property (nonatomic,strong) UleKoulingButtonInfo *buttonInfo;
@property (nonatomic,strong) NSString *imgUrl;   //活动图片
@property (nonatomic,strong) NSString *text;     //如果是活动的话就直接用text，如果是商品，如果有<P_LISTNAME>就用商品名替换，没有的话就直接用text
@property (nonatomic,strong) NSString *minversion;
@property (nonatomic,strong) NSString *sceneCode;
@end

NS_ASSUME_NONNULL_END
