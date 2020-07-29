//
//  UleWebBarButton.m
//  UleApp
//
//  Created by uleczq on 2017/7/18.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleWebBarButton.h"
#import <NSString+Utility.h>
#import <UIView+SDAutoLayout.h>
#import <YYWebImage.h>
@interface UleWebBarButton ()
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) NSString * iconStr;
@end


@implementation UleWebBarButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andIcon:(NSString *)iconUrl{
    self= [super initWithFrame:frame];
    if (self) {
        self.titleStr=title;
        self.iconStr=iconUrl;
        self.width_sd=40;//默认大小
        self.height_sd=40;//默认大小
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    if (self.titleStr.length>0&&self.iconStr.length>0) {
        CGFloat width=[NSString getSizeOfString:self.titleStr withFont:[UIFont systemFontOfSize:12] andMaxWidth:100].width;
        if (width>self.width_sd) {
            self.width_sd=width;
        }
        self.mTitleLabel.font=[UIFont systemFontOfSize:12];
        self.mTitleLabel.sd_layout.bottomSpaceToView(self, 0)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(15);
        self.mImageView.frame=CGRectMake(0, 0, 20, 20);
        self.mImageView.sd_layout.centerXEqualToView(self)
        .bottomSpaceToView(self.mTitleLabel, 0)
        .widthIs(20)
        .heightIs(20);
        [self.mImageView yy_setImageWithURL:[NSURL URLWithString:self.iconStr] placeholder:[UIImage bundleImageNamed:self.iconStr]];
        self.mTitleLabel.text=self.titleStr;
    }else if(self.titleStr.length>0){
        CGFloat width=[NSString getSizeOfString:self.titleStr withFont:[UIFont systemFontOfSize:15] andMaxWidth:100].width;
        if (width>self.width_sd) {
            self.width_sd=width;
        }
        self.mTitleLabel.text=self.titleStr;
        self.mTitleLabel.font=[UIFont systemFontOfSize:15];
        self.mTitleLabel.sd_layout.centerYEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs(20);
    }else if(self.iconStr.length>0){
        [self.mImageView yy_setImageWithURL:[NSURL URLWithString:self.iconStr] placeholder:[UIImage bundleImageNamed:self.iconStr]];
        self.mImageView.sd_layout.centerXEqualToView(self)
        .centerYEqualToView(self)
        .widthIs(22)
        .heightEqualToWidth();
    }
}

@end
