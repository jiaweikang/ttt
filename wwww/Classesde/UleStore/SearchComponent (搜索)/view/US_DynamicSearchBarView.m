//
//  US_DynamicSearchBarView.m
//  u_store
//
//  Created by xstones on 2017/11/16.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "US_DynamicSearchBarView.h"

@interface US_DynamicSearchBarView ()
@property (nonatomic, copy) TapActionBlock  tapBlock;

@end

@implementation US_DynamicSearchBarView

-(instancetype)initWithFrame:(CGRect)frame tapActionBlock:(TapActionBlock)tapGesBlock
{
    if (self=[super initWithFrame:frame]) {
        _tapBlock=tapGesBlock;
        self.backgroundColor=[UIColor colorWithWhite:1 alpha:1.0];
        self.sd_cornerRadiusFromHeightRatio=@(0.5);
        
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
        [self addGestureRecognizer:tapGes];
        
        UIView *contentView=[[UIView alloc]init];
        contentView.backgroundColor=[UIColor clearColor];
        [self addSubview:contentView];
        contentView.sd_layout.centerXEqualToView(self)
        .centerYEqualToView(self)
        .heightRatioToView(self, 1.0)
        .widthIs(60);
        UIImageView *imgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"goods_navi_search_new"]];
        [contentView addSubview:imgView];
        imgView.sd_layout.centerYEqualToView(contentView)
        .leftSpaceToView(contentView, 0)
        .widthIs(15)
        .heightIs(15);
        UILabel *lab=[[UILabel alloc]init];
        lab.text=@"搜索";
        lab.textColor=[UIColor convertHexToRGB:@"cccccc"];
        lab.font=[UIFont systemFontOfSize:12];
        [contentView addSubview:lab];
        lab.sd_layout.topSpaceToView(contentView, 0)
        .leftSpaceToView(imgView, 5)
        .bottomSpaceToView(contentView, 0)
        .rightSpaceToView(contentView, 0);
    }
    return self;
}



-(void)tapGesAction {
    if (_tapBlock) {
        _tapBlock();
    }
}



@end
