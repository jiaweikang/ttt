//
//  PosterShareStyleView.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/11/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ShareStoreType,   //店铺分享
    TeamInviteType,   //战队邀请
} PosterViewType;

@interface PosterShareStyleView : UIView
- (instancetype)initWithShareType:(PosterViewType)posterViewType;
- (void)loadModel:(id)model;
- (void)show;
@end

NS_ASSUME_NONNULL_END
