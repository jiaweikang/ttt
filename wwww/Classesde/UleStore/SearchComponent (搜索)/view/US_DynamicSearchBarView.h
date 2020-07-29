//
//  US_DynamicSearchBarView.h
//  u_store
//
//  Created by xstones on 2017/11/16.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapActionBlock)(void);

@interface US_DynamicSearchBarView : UIView

-(instancetype)initWithFrame:(CGRect)frame tapActionBlock:(TapActionBlock)tapGesBlock;

@end
