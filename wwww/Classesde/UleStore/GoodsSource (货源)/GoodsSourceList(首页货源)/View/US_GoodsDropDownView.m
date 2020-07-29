//
//  US_GoodsDropDownView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/5/23.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_GoodsDropDownView.h"
#import <UIView+SDAutoLayout.h>
#import "US_HomeBtnData.h"
#define kAlertHeight 380
#define kTitleButtonH 55
#define kGap 20
@interface US_GoodsDropDownView ()
@property (nonatomic, strong) UIView    *topLineView;
@property (nonatomic, strong) UIScrollView * titleScrollView;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) NSArray * titelArray;
@property (nonatomic, strong) NSMutableArray * titleBtnArray;
@property (nonatomic, assign) CGRect btnRect;
@end

@implementation US_GoodsDropDownView


- (instancetype)initWithTitles:(NSArray *)titles andSelectedTitle:(NSString *)selectedTitle{
    self =[super initWithFrame:CGRectMake(0, 64, __MainScreen_Width, __MainScreen_Height)];
    if (self) {
        self.titelArray=titles;
        self.selectedTitle=selectedTitle;
        [self addSubview:self.bgView];
        [self addSubview:self.titleScrollView];
        [self addSubview:self.topLineView];
        self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        [self layoutTitlesView];
    }
    return self;
}

- (void)layoutTitlesView{
    float x=10;
    float y=20;
    float width=(__MainScreen_Width-16*5)/4.0;
    float height=KScreenScale(kTitleButtonH);
    float maxHeight=30;
    if (self.titleBtnArray) {
        [self.titleBtnArray removeAllObjects];
    }else{
        _titleBtnArray=[NSMutableArray array];
    }
    for (int i=0; i<self.titelArray.count; i++) {
        HomeBtnItem * item=self.titelArray[i];
        x = i%4*width + 15*(i%4+1);
        y = i/4*height + 15*(i/4+1);
        UIButton * titleButton=[self buildTitleButtonWithFrame:CGRectMake(x, y, width, height) andTitle:item.title];
        titleButton.tag=i;
        [self.titleScrollView addSubview:titleButton];
        maxHeight=titleButton.bottom_sd+kGap;
        if ([self.selectedTitle isEqualToString:item.title]) {
            titleButton.selected=YES;
            self.btnRect = titleButton.frame;
//            titleButton.layer.borderColor = [UIColor convertHexToRGB:@"EF3B39"].CGColor;
            titleButton.tintColor=[UIColor convertHexToRGB:@"EF3B39"];
        }
        [_titleBtnArray addObject:titleButton];
    }
    CGFloat scroContentHeight=maxHeight;
    if (maxHeight>kAlertHeight) {
        maxHeight=kAlertHeight;
    }
    self.titleScrollView.height_sd=maxHeight+kGap;
    self.titleScrollView.contentSize=CGSizeMake(__MainScreen_Width, scroContentHeight);
    [self.titleScrollView scrollRectToVisible:CGRectMake(0, self.btnRect.origin.y-50, __MainScreen_Width, 30) animated:YES];
    
}

- (UIButton *) buildTitleButtonWithFrame:(CGRect)frame andTitle:(NSString *)title{
    UIButton * titleButton=[[UIButton alloc] initWithFrame:frame];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor convertHexToRGB:@"999999"] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    titleButton.layer.borderWidth = 0.5;
    titleButton.layer.cornerRadius = KScreenScale(10);
//    titleButton.layer.borderColor = [UIColor convertHexToRGB:@"eeeeee"].CGColor;
    titleButton.tintColor=[UIColor convertHexToRGB:@"eeeeee"];
    [titleButton addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(28)];
    return titleButton;
}

- (void)titleSelect:(UIButton *)sender{
    for (int i=0; i<self.titleBtnArray.count; i++) {
        UIButton * btn=self.titleBtnArray[i];
        btn.selected=NO;
//        btn.layer.borderColor = [UIColor convertHexToRGB:@"eeeeee"].CGColor;
        btn.tintColor=[UIColor convertHexToRGB:@"eeeeee"];
    }
    sender.selected=YES;
//    sender.layer.borderColor = [UIColor convertHexToRGB:@"EF3B39"].CGColor;
    sender.tintColor=[UIColor convertHexToRGB:@"EF3B39"];
    NSInteger tag=sender.tag;
    if (self.selectBlock) {
        self.selectBlock(@(tag));
    }
    [self hiddenView:nil];
}

- (void)setSelectedTitle:(NSString *)selectedTitle{
    _selectedTitle=selectedTitle;
    for (int i=0; i<self.titleBtnArray.count; i++) {
        UIButton * titleBtn=self.titleBtnArray[i];
        if ([_selectedTitle isEqualToString:titleBtn.titleLabel.text]) {
            titleBtn.selected=YES;
//            titleBtn.layer.borderColor = [UIColor convertHexToRGB:@"EF3B39"].CGColor;
            titleBtn.tintColor=[UIColor convertHexToRGB:@"EF3B39"];
        }else{
            titleBtn.selected=NO;
//            titleBtn.layer.borderColor = [UIColor convertHexToRGB:@"eeeeee"].CGColor;
            titleBtn.tintColor=[UIColor convertHexToRGB:@"eeeeee"];
        }
    }
}


- (void)hiddenView:(UIGestureRecognizer * __nullable)recognizer{
    if (self.hiddenClick) {
        self.hiddenClick();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.titleScrollView.top_sd=-self.titleScrollView.height_sd;
        self.bgView.alpha=0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showAtView:(UIView *)rootView belowView:(UIView *)topView{
    [rootView insertSubview:self belowSubview:topView];
    [UIView animateWithDuration:0.3 animations:^{
        self.titleScrollView.top_sd=0;
        self.bgView.alpha=0.3;
    }];
}


#pragma mark - <setter and getter>
- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor=[UIColor blackColor];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
        [_bgView addGestureRecognizer:tap];
        _bgView.alpha=0.0;
        _bgView.userInteractionEnabled=YES;
    }
    return _bgView;
}

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -kAlertHeight, __MainScreen_Width, kAlertHeight)];
        _titleScrollView.backgroundColor=[UIColor whiteColor];
    }
    return _titleScrollView;
}


- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0.4)];
        _topLineView.backgroundColor=[UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
    }
    return _topLineView;
}
@end
