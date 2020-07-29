//
//  USShareModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USShareModel.h"
#import <YYModel.h>
#import "NSString+Addition.h"
#import "US_NetworkExcuteManager.h"
#import "US_ShareApi.h"
#import "ShareCreateId.h"
#import "MultipicModel.h"
@interface USShareModel ()

@property (nonatomic, strong) UleNetworkExcute * client;
@property (nonatomic, strong) FinishBlock finshBlock;
@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailedBlock failedBlock;
@end

@implementation USShareModel
@synthesize listImage,listImage2;

- (void)dealloc{
    NSLog(@"__%s__",__FUNCTION__);
}

- (NSMutableArray *)listImage
{
    NSString *imageStr = @"";
    for (int i = 0; i < listImage.count; i++) {
        imageStr = [NSString removeDuplicateHTTP:listImage[i]];
        [listImage replaceObjectAtIndex:i withObject:imageStr];
    }
    return listImage;
}

- (NSMutableArray *)listImage2{
    NSString *imageStr = @"";
    for (int i = 0; i < listImage2.count; i++) {
        imageStr = [NSString removeDuplicateHTTP:listImage2[i]];
        [listImage2 replaceObjectAtIndex:i withObject:imageStr];
        if ([NSString isNullToString:imageStr].length==0) {
            [listImage2 removeObjectAtIndex:i];
            i--;
        }
    }
    return listImage2;
}

+ (instancetype) initWithJsonStr:(NSString *)jsonStr{
    //获取字符串中JSON格式的最后一个‘}’位置。
    NSInteger lastBracesIndex= [NSString getLastBracesAtIndexOfJsonStr:jsonStr];
    jsonStr=[jsonStr substringToIndex:lastBracesIndex];
    NSData    *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    if (dic==nil) {
        return nil;
    }
    USShareModel * shareModel= [USShareModel yy_modelWithDictionary:dic];
    for (int i=0; i<shareModel.listImage.count; i++) {
        NSString * imageUrl=shareModel.listImage[i];
        if (imageUrl.length>0) {
            imageUrl=[NSString removeDuplicateHTTP:imageUrl];
            [shareModel.listImage replaceObjectAtIndex:i withObject:imageUrl];
        }
    }
    
    return shareModel;
}

//处理标题和副标题
-(NSString *)getShareWholeString:(NSString *)str
{
    if (str==nil||[str isEqualToString:@"(null)"]) {
        return@"";
    }
    if ([str rangeOfString:@"#salePrice#"].location!=NSNotFound) {
        str=[str stringByReplacingOccurrencesOfString:@"#salePrice#" withString:[NSString stringWithFormat:@"¥%.2f",self.sharePrice.floatValue]];
    }
    if ([str rangeOfString:@"#listName#"].location!=NSNotFound) {
        str=[str stringByReplacingOccurrencesOfString:@"#listName#" withString:[NSString stringWithFormat:@"%@",self.listName]];
    }
    
    return str;
}

- (void) startRequestShareInfor:(SuccessBlock)success failed:(FailedBlock)failed{
    self.successBlock = [success copy];
    self.failedBlock = [failed copy];
    UleRequest * request= [US_ShareApi buildGetShareListingUrlRequest:self.shareChannel from:self.shareFrom andListId:self.listId];
    @weakify(self);
    [self.client beginRequest:request success:^(id responseObject) {
        @strongify(self);
        NSDictionary * retObj=(NSDictionary *)responseObject;
        ShareCreateId *shareCreateId = [ShareCreateId yy_modelWithDictionary:retObj];
        [self fetchShareModelValueWithModel:shareCreateId];
        if (self.successBlock) {
            self.successBlock(shareCreateId.data);
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        NSLog(@"请求失败==%@",error.error);
        if (self.failedBlock) {
            self.failedBlock(error.error);
        }
    }];
}

- (void) startRequestInsuranceShareInfor:(SuccessBlock)success failed:(FailedBlock)failed{
    self.successBlock = [success copy];
    self.failedBlock = [failed copy];
    
    NSArray *listInfo = @[@{@"listId":NonEmpty(_listId),
                            @"mobile":[US_UserUtility sharedLogin].m_mobileNumber,
                            @"listName":NonEmpty(_listName),
                            @"imgUrl":NonEmpty(_shareImageUrl),
                            @"sharePrice":NonEmpty(_sharePrice)
                            }];
    
    UleRequest * request= [US_ShareApi buildInsuranceShareLinkRequest:self.shareChannel from:self.shareFrom andListId:listInfo];
    @weakify(self);
    [self.client beginRequest:request success:^(id responseObject) {
        @strongify(self);
        ShareCreateId *shareCreateId = [ShareCreateId yy_modelWithDictionary:responseObject];
        [self fetchShareModelValueWithModel:shareCreateId];
        if (self.successBlock) {
            self.successBlock(shareCreateId.data);
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        NSLog(@"请求失败==%@",error.error);
        if (self.failedBlock) {
            self.failedBlock(error.error);
        }
    }];
}

- (void)startRequestFenxiaoShareInfo:(SuccessBlock)success failed:(FailedBlock)failed{
    self.successBlock = [success copy];
    self.failedBlock = [failed copy];
    NSString *listId=[NSString isNullToString:[NSString stringWithFormat:@"%@", _listId]];
    NSString *zoneId=[NSString isNullToString:[NSString stringWithFormat:@"%@", _zoneId]];
    NSString *shareChannel=[NSString isNullToString:[NSString stringWithFormat:@"%@", _shareChannel]];
    NSString *shareFrom=[NSString isNullToString:[NSString stringWithFormat:@"%@", _shareFrom]];
    @weakify(self) ;
    [self.client beginRequest:[US_ShareApi buildGetFenXiaoShareListingUrlRequest:listId andZoneId:zoneId andShareChannel:shareChannel andShareFrom:shareFrom] success:^(id responseObject) {
        @strongify(self);
        ShareCreateId *shareCreateId = [ShareCreateId yy_modelWithDictionary:responseObject];
        [self fetchShareModelValueWithModel:shareCreateId];
        if (self.successBlock) {
            self.successBlock(shareCreateId.data);
        }

    } failure:^(UleRequestError *error) {
        @strongify(self);
        NSLog(@"请求失败==%@",error.error);
        if (self.failedBlock) {
            self.failedBlock(error.error);
        }
    }];
}

-(void)fetchShareModelValueWithModel:(ShareCreateId *)shareCreateId{
    if (shareCreateId.data.sectionList&&shareCreateId.data.sectionList.count>0) {
        //处理标题和副标题
        int randomNum = arc4random()%(shareCreateId.data.sectionList.count); //获取随机数
        ShareCreateResult *resultItem=[shareCreateId.data.sectionList objectAtIndex:randomNum];
        NSString *shareTitle = [self getShareWholeString:resultItem.attribute1];
        NSString *shareDesc = [self getShareWholeString:resultItem.attribute2];
        if (shareTitle&&shareTitle.length>0) {
            self.shareTitle=shareTitle;
        }
        if (shareDesc&&shareDesc.length>0) {
            self.shareContent=shareDesc;
        }
    }
    if ([NSString isNullToString:shareCreateId.data.shareUrl4].length > 0) {
        self.shareUrl = [NSString stringWithFormat:@"%@", shareCreateId.data.shareUrl4];
    } else {
        self.shareUrl = [NSString stringWithFormat:@"%@", shareCreateId.data.shareUrl3];
        //添加adid
        NSString *adidSuffix=[NSString stringWithFormat:@"adid=%@fx_merchant",[UleStoreGlobal shareInstance].config.appName];
        NSRange tRange = [self.shareUrl rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        self.shareUrl =[[NSString alloc] initWithFormat:@"%@%@",self.shareUrl,(tRange.location != NSNotFound)?[@"&" stringByAppendingString:adidSuffix]:[@"?" stringByAppendingString:adidSuffix]];
        self.shareUrl = [NSString stringWithFormat:@"%@",[self.shareUrl stringByAppendingString:[NSString stringWithFormat:@"&appName=%@",[UleStoreGlobal shareInstance].config.appName]]];
    }
    if (self.srcid.length>0) {
        NSMutableDictionary * urlDic=[[NSMutableDictionary alloc] init];
        [urlDic setObject:NonEmpty(self.srcid) forKey:@"srcid"];
         self.shareUrl =[NSString appandHtmlStr:self.shareUrl WithParams:urlDic];
    }
    //如果动态按钮参数初始化时候shareOptions已配置 说明分享方式写死 不再接收接口返回
    if (self.shareOptions.length <= 0) {
        self.shareOptions=[NSString isNullToString:shareCreateId.data.shareOptions];
    }
    //如果是首页精选商品分享 使用
    if (self.isHome_jinxuan_GoodsShare) {
        self.shareOptions=[NSString isNullToString:shareCreateId.data.shareOptionsIndex];
    }
    //软文分享的跳转链接
    self.articleUrl=[NSString isNullToString:shareCreateId.data.articleUrl];
    if (self.articleUrl.length<=0) {
        for (NSString *item in @[@"##8",@"8##",@"8"]) {
            if ([self.shareOptions containsString:item]) {
                self.shareOptions=[self.shareOptions stringByReplacingOccurrencesOfString:item withString:@""];
            }
        }
    }
    //处理微信小程序参数
    if ([NSString isNullToString:shareCreateId.data.miniWxShareInfo.path].length > 0 && [NSString isNullToString:shareCreateId.data.miniWxShareInfo.originalId].length > 0) {
        self.WXMiniProgram_path = shareCreateId.data.miniWxShareInfo.path;
        self.WXMiniProgram_OriginalId = shareCreateId.data.miniWxShareInfo.originalId;
        self.WXMiniProgram_pageUrl = self.shareUrl;
    } else {
        //4代表小程序
        for (NSString *item in @[@"##4",@"4##",@"4"]) {
            if ([self.shareOptions containsString:item]) {
                self.shareOptions=[self.shareOptions stringByReplacingOccurrencesOfString:item withString:@""];
            }
        }
    }
}


- (void)startRequestMultiPicInfo:(SuccessBlock)success failed:(FailedBlock)failed{
    self.successBlock =[success copy];
    self.failedBlock = [failed copy];
    UleRequest * request= [US_ShareApi buildGetShareJsonInfoRequest:self.listId];
    @weakify(self);
    [self.client beginRequest:request success:^(id responseObject) {
        @strongify(self);
        MultipicModel *multiModel=[MultipicModel yy_modelWithDictionary:(NSDictionary *)responseObject];
        MultipicList *list = [multiModel.data.resultList firstObject];
        self.listImage=list.imageList;
        self.listImage2=list.imageList2;
        if (self.successBlock) {
            self.successBlock(responseObject);
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        if (self.failedBlock) {
            self.failedBlock(error.error);
        }
    }];
}

+ (NSString *)tranforCommitionStr:(NSString *)commintion{
    NSString * result=@"";
    if (commintion.length>0&&[commintion doubleValue]>0) {
        result=[NSString stringWithFormat:@"%.2f",[commintion doubleValue]];
    }
    return result;
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)client{
    if (!_client) {
        _client=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _client;
}

@end
