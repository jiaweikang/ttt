//
//  ShareStorePosterModel.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/11/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "PosterShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareStorePosterModel : PosterShareModel
//可配置背景，当前版本不用
@property (nonatomic, copy) NSString *posterBgViewUrl;
@property (nonatomic, copy) NSString *tipBgUrl;
@end

NS_ASSUME_NONNULL_END
