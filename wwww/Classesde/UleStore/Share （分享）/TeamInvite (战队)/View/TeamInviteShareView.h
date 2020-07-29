//
//  TeamInviteShareView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInviteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamInviteShareView : UIView
@property (nonatomic, strong) TeamInviteModel *model;
- (UIImage *)buildPostViewToImage;
- (void)saveKoulingStr;
@end

NS_ASSUME_NONNULL_END
