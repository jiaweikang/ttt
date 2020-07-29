//
//  US_EditStoreAlertView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_EditStoreAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>
@interface US_EditStoreAlertView ()
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) US_EditStoreAlertViewType type;
@property (nonatomic, strong) EditStoreAlertBlock clickBlock;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * titleLable;
@end

@implementation US_EditStoreAlertView

- (instancetype) initWithTitle:(NSString *)title type:(US_EditStoreAlertViewType)type confirmBlock:(nonnull EditStoreAlertBlock)block{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 200)];
    if (self) {
        self.title=title;
        self.type=type;
        self.clickBlock=[block copy];
        [self setUI];
    }
    
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    [self sd_addSubviews:@[self.contentView,self.confirmButton]];
    self.confirmButton.sd_layout.leftSpaceToView(self, 20)
    .bottomSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .heightIs(44);
    self.contentView.sd_layout.topSpaceToView(self, 50)
    .centerXEqualToView(self)
    .heightIs(40)
    .widthIs(100);
    
    UIImageView * iconImage=[[UIImageView alloc] init];
    [self.contentView addSubview:iconImage];
    
    iconImage.sd_layout.leftSpaceToView(self.contentView, 0)
    .centerYEqualToView(self.contentView)
    .widthIs(20)
    .heightIs(20);
    [self.contentView addSubview:self.titleLable];
    
    self.titleLable.sd_layout.leftSpaceToView(iconImage, 5)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .autoWidthRatio(0);
    
    self.titleLable.text=self.title;
    [self.titleLable setSingleLineAutoResizeWithMaxWidth:__MainScreen_Width-100];
    [self.contentView setupAutoWidthWithRightView:self.titleLable rightMargin:0];
    if (self.type == US_EditStoreAlertViewSucess) {
        iconImage.image=[UIImage bundleImageNamed:@"mystore_icon_success"];
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        iconImage.image=[UIImage bundleImageNamed:@"mystore_icon_failed"];
        [self.confirmButton setTitle:@"重新命名" forState:UIControlStateNormal];
    }
}

- (void)buttonClick:(id)sender{
    [self hiddenView];
    if (self.clickBlock) {
        self.clickBlock(nil);
    }
}

#pragma mark - <setter and getter>
- (UIView *)contentView{
    if (!_contentView) {
        _contentView=[UIView new];
    }
    return _contentView;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton=[[UIButton alloc] init];
        _confirmButton.backgroundColor=kNavBarBackColor;
        _confirmButton.layer.cornerRadius=5;
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable=[UILabel new];
        _titleLable.font=[UIFont systemFontOfSize:17];
        _titleLable.textColor= [UIColor convertHexToRGB:@"333333"];
    }
    return _titleLable;
}
@end
