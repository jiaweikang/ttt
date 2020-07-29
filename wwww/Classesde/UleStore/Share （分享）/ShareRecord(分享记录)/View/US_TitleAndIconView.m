//
//  US_TitleAndIconView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_TitleAndIconView.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"

@interface US_TitleAndIconView ()
@property (nonatomic, strong)UleControlView * titleView;
@property (nonatomic, strong) UILabel * contentLabel;
@end

@implementation US_TitleAndIconView

+ (instancetype)titleAndIconViewWithFrame:(CGRect)frame
                                     icon:(NSString *)imageName
                                    title:(NSString *)title
                                  content:(NSString *)content{
    return [[US_TitleAndIconView alloc] initWithFrame:frame icon:imageName title:title content:content];
}


- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)imageName title:(NSString *)title content:(NSString *)content{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_addSubviews:@[self.titleView,self.contentLabel]];
        self.titleView.mImageView.image=[UIImage bundleImageNamed:imageName];
        self.titleView.mTitleLabel.text=title;
        [self.titleView.mTitleLabel setSingleLineAutoResizeWithMaxWidth:300];
        
        self.titleView.sd_layout.centerXEqualToView(self)
        .topSpaceToView(self, 0).autoWidthRatio(0)
        .heightIs(frame.size.height/2.0);
        
        self.contentLabel.sd_layout.leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self.titleView, 0)
        .bottomSpaceToView(self, 0);
    }

    return self;
}

- (void)setContent:(NSString *)contentStr{
    self.contentLabel.text=NonEmpty(contentStr);
}
#pragma mark - <setter and getter>
- (UleControlView *)titleView{
    if (!_titleView) {
        _titleView=[[UleControlView alloc] init];
        _titleView.mImageView.sd_layout.leftSpaceToView(_titleView, 0)
        .centerYEqualToView(_titleView)
        .widthIs(13).heightEqualToWidth();
        
        _titleView.mTitleLabel.sd_layout.leftSpaceToView(_titleView.mImageView, 5)
        .topSpaceToView(_titleView, 0)
        .bottomSpaceToView(_titleView, 0)
        .autoWidthRatio(0);
        _titleView.mTitleLabel.font=[UIFont systemFontOfSize:14];
        _titleView.mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        [_titleView setupAutoWidthWithRightView:_titleView.mTitleLabel rightMargin:0];
    }
    return _titleView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _contentLabel;
}

@end
