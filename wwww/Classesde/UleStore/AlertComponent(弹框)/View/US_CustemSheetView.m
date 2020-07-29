//
//  US_CustemSheetView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/6/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_CustemSheetView.h"
#import <UIView+SDAutoLayout.h>

@interface US_CustemSheetView ()
@property (nonatomic, strong) NSMutableArray * buttons;
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation US_CustemSheetView

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray *)buttons{
    self= [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0)];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.titleStr=title;
        self.buttons=[buttons mutableCopy];
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    CGFloat titleHeight=0;
    if (self.titleStr.length>0) {
        titleHeight=49;
    }
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(titleHeight);
    UIView * temp=self.titleLabel;
    for (int i=0;i<self.buttons.count;i++) {
        UIButton * btn=[[UIButton alloc] init];
        btn.tag=i;
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        [btn setTitle:[self.buttons objectAt:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.sd_layout.leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(temp, 0)
        .heightIs(50);
        temp=btn;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        [btn addSubview:line];
        line.sd_layout.leftSpaceToView(btn, 0)
        .bottomSpaceToView(btn, 0)
        .rightSpaceToView(btn, 0)
        .heightIs(0.6);
    }
    UIView * splitView=[UIView new];
    splitView.backgroundColor=kViewCtrBackColor;
    [self addSubview:splitView];
    splitView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(temp, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    UIButton * cancel=[[UIButton alloc] initWithFrame:CGRectZero];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
    cancel.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(splitView, 0)
    .heightIs(49);
    [self setupAutoHeightWithBottomView:cancel bottomMargin:((kStatusBarHeight>20)?34:0)];
    [self layoutIfNeeded];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.height_sd=rect.size.height;
}
#pragma mark- <Click>

- (void)buttonClick:(UIButton *)btn{
    [self hiddenView];
    if (self.sureBlock) {
        self.sureBlock(btn.tag);
    }
}

- (void)cancelClick:(id)sender{
    [self hiddenView];
}
#pragma mark - <getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
    }
    return _titleLabel;
}
@end
