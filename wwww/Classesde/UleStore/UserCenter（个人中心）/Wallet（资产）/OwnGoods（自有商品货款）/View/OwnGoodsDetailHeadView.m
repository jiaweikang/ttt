//
//  OwnGoodsDetailHeadView.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "OwnGoodsDetailHeadView.h"
#import "US_RewardChooseBtn.h"
#import "UIView+Shade.h"
#import <UIView+SDAutoLayout.h>
#import "WBPopOverView.h"

#define ImgTag 1000

@interface OwnGoodsDetailHeadView () <ChooseBtnViewDelegate>

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *totalCountLbl;
@property (nonatomic, strong) UIButton *withdrawBtn;
@property (nonatomic, strong) US_RewardChooseBtn *chooseBtn;

@end

@implementation OwnGoodsDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [self sd_addSubviews:@[self.showView, self.chooseBtn]];
    [self.showView sd_addSubviews:@[self.titleLbl, self.explainBtn, self.totalCountLbl, self.withdrawBtn]];
    
    self.titleLbl.sd_layout
    .leftSpaceToView(self.showView, KScreenScale(26))
    .topSpaceToView(self.showView, KScreenScale(24))
    .widthIs(KScreenScale(245))
    .heightIs(KScreenScale(30));
    
    self.explainBtn.sd_layout
    .leftSpaceToView(self.titleLbl, KScreenScale(4))
    .topEqualToView(self.titleLbl)
    .widthIs(KScreenScale(32))
    .heightIs(KScreenScale(32));
    
    self.totalCountLbl.sd_layout
    .leftSpaceToView(self.showView, KScreenScale(26))
    .topSpaceToView(self.showView, KScreenScale(88))
    .widthIs(__MainScreen_Width)
    .heightIs(KScreenScale(50));
    
    self.withdrawBtn.sd_layout
    .rightSpaceToView(self.showView, KScreenScale(22))
    .topSpaceToView(self.showView, KScreenScale(58))
    .widthIs(KScreenScale(150))
    .heightIs(KScreenScale(60));
}

- (void)layoutHeadView:(NSString *)totalCount
{
    self.totalCountLbl.text = totalCount;
}

- (void)topViewDidSelectAtIndex:(NSInteger)index
{
    NSString *transFlag;
    switch (index) {
        case 0:
            transFlag = @"";
            break;
        case 1:
            transFlag = @"D";
            break;
        case 2:
            transFlag = @"E";
            break;
        default:
            break;
    }
    if (self.chooseBtnBlock) {
        self.chooseBtnBlock(transFlag);
    }
}

- (void)explainBtnAction:(UIButton *)sender
{
    CGPoint point=CGPointMake(sender.frame.origin.x+sender.frame.size.width, sender.frame.origin.y+sender.frame.size.height/2);//箭头点的位置
    CGPoint a = [self convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
    CGFloat adjustW=KScreenScale(260)+10;
    CGFloat maxHeight = [self.tipsStr heightForFont:[UIFont systemFontOfSize:KScreenScale(22)] width:adjustW - KScreenScale(24)] + 10;
    WBPopOverView *view=[[WBPopOverView alloc]initWithOrigin:a Width:adjustW Height:maxHeight + KScreenScale(24) Direction:WBArrowDirectionLeft2];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    view.backView.layer.cornerRadius=5.0;
    view.backView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.4];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(KScreenScale(12), KScreenScale(12), adjustW-KScreenScale(12), maxHeight)];
    lable.numberOfLines=0;
    lable.text=self.tipsStr;
    lable.textColor=[UIColor whiteColor];
    lable.textAlignment=NSTextAlignmentLeft;
    lable.font=[UIFont systemFontOfSize:KScreenScale(22)];
    [view.backView addSubview:lable];
    [view popViewAtSuperView:nil];
}

//提现
- (void)withdrawBtnAction:(UIButton *)button
{
    if (self.withdrawBtnBlock) {
        self.withdrawBtnBlock();
    }
}

#pragma mark - <setter and getter>
- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(170))];
        [_showView.layer addSublayer:[UIView setGradualChangingColor:_showView fromColor:[UIColor convertHexToRGB:@"EC3D3F"] toColor:[UIColor convertHexToRGB:@"FF663E"] gradualType:GradualTypeVertical]];
    }
    return _showView;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"货款账户余额(元)";
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
    }
    return _titleLbl;
}

- (UIButton *)explainBtn
{
    if (!_explainBtn) {
        _explainBtn = [[UIButton alloc] init];
        [_explainBtn setBackgroundImage:[UIImage bundleImageNamed:@"icon_explain"] forState:UIControlStateNormal];
        [_explainBtn addTarget:self action:@selector(explainBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _explainBtn.hidden = YES;
    }
    return _explainBtn;
}

- (UILabel *)totalCountLbl
{
    if (!_totalCountLbl) {
        _totalCountLbl = [[UILabel alloc] init];
        _totalCountLbl.textColor = [UIColor whiteColor];
        _totalCountLbl.font = [UIFont boldSystemFontOfSize:KScreenScale(46)];
        _totalCountLbl.text = @"0.00";
    }
    return _totalCountLbl;
}

- (UIButton *)withdrawBtn
{
    if (!_withdrawBtn) {
        _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawBtn.layer.masksToBounds = YES;
        _withdrawBtn.layer.cornerRadius = KScreenScale(30);
        _withdrawBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _withdrawBtn.layer.borderWidth = 1;
        [_withdrawBtn addTarget:self action:@selector(withdrawBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawBtn;
}

- (US_RewardChooseBtn *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [US_RewardChooseBtn topViewWithDelegate:self frame:CGRectMake(0, self.showView.frame.size.height + self.showView.frame.origin.y, __MainScreen_Width, KScreenScale(88)+1.5+1)];
        [_chooseBtn selectBtnAtIndex:0];
    }
    return _chooseBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
