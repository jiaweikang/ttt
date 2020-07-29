//
//  UleWebBarButton.h
//  UleApp
//
//  Created by uleczq on 2017/7/18.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleControlView.h"

@interface UleWebBarButton : UleControlView

//@property (nonatomic, strong) NSString * action;
//@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, assign) BOOL needlogin;
@property (nonatomic, strong) NSDictionary * bindData;


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andIcon:(NSString *)iconUrl;
@end
