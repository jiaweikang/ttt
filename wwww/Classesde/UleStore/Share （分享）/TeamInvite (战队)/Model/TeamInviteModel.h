//
//  TeamInviteModel.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/11/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "PosterShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeamInviteModel : PosterShareModel
@property (nonatomic , copy) NSString              * slogan;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * bgAvatarUrl;
@property (nonatomic , copy) NSString              * logoUrl;
@property (nonatomic , copy) NSString              * avatarUrl;
@property (nonatomic , copy) NSString              * headerText;
@property (nonatomic , copy) NSString              * footerText;
@property (nonatomic , copy) NSString              * kouling;

@property (nonatomic, strong) UIImage              * bgAvatarImage;
@property (nonatomic, strong) UIImage              * avatarImage;
@property (nonatomic, strong) UIImage              * logoImage;
@end

NS_ASSUME_NONNULL_END
