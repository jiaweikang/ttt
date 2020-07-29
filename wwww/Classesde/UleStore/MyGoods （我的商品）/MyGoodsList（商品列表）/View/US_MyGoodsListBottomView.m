//
//  US_MyGoodsListBottomView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsListBottomView.h"
#import <UIView+SDAutoLayout.h>
#import "WBPopOverView.h"
@interface US_MyGoodsListBottomView ()
@property (nonatomic, strong)WBPopOverView * popView;
@end


@implementation US_MyGoodsListBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    UIView * topLine=[UIView new];
    topLine.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
    [self addSubview:topLine];
    topLine.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0).heightIs(1);
    
    self.backgroundColor=[UIColor whiteColor];
    UIView * middleLine=[UIView new];
    middleLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    
    [self sd_addSubviews:@[self.leftButton,self.rightButton,middleLine]];
    middleLine.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self, 10)
    .heightIs(29)
    .widthIs(0.5);
    self.leftButton.sd_layout
    .topSpaceToView(self, KScreenScale(15))
    .heightIs(32)
    .leftSpaceToView(self, KScreenScale(40))
    .rightSpaceToView(middleLine, KScreenScale(40));
    
    self.rightButton.sd_layout
    .topSpaceToView(self, KScreenScale(15))
    .heightIs(32)
    .leftSpaceToView(middleLine, KScreenScale(40))
    .rightSpaceToView(self, KScreenScale(40));
}

- (void)setAddNewGoods:(BOOL)addNewGoods{
    _addNewGoods=addNewGoods;
    if (_addNewGoods) {
        self.leftButton.mImageView.image=[UIImage bundleImageNamed:@"myGoods_btn_addGoods"];
        self.leftButton.mTitleLabel.text=@"添加商品";
        [self.leftButton updateLayout];
    }
}
#pragma mark - <click event>
- (void)findGoodsClick:(id)sender{
    //如果是添加商品的VC，则跳转到添加商品页面，否则跳转的查找商品页面
    if (self.addNewGoods) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(addNewProductClick)]) {
            [self.delegate addNewProductClick];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(searchProductClick)]) {
            [self.delegate searchProductClick];
        }
    }
}
- (void)rightBtnClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(batchManagerClick)]) {
        [self.delegate batchManagerClick];
    }
}

- (UleControlView *)buildButtonWithFrame:(CGRect)frame Title:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] initWithFrame:frame];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mTitleLabel.sd_layout
    .topSpaceToView(button, 0)
    .bottomSpaceToView(button, 0)
    .autoWidthRatio(0)
    .centerXIs(frame.size.width/2+KScreenScale(18));
    button.mImageView.sd_layout.rightSpaceToView(button.mTitleLabel, KScreenScale(6))
    .centerYEqualToView(button)
    .widthIs(KScreenScale(36))
    .heightIs(KScreenScale(36));
    button.mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
    button.mTitleLabel.font=[UIFont systemFontOfSize:14];
    [button.mTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    return button;
}
//失效商品提示
-(void)showPopView{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        NSString *str=@"失效商品在这里";
        CGPoint a = CGPointMake(__MainScreen_Width / 4 * 3, 20 );
        CGFloat popViewW=130;
        self.popView=[[WBPopOverView alloc]initWithOrigin:a Width:popViewW Height:30 Direction:WBArrowDirectionDown1];
        self.popView.needCenter = NO;
        self.popView.backView.layer.cornerRadius=10.0;
        self.popView.backView.backgroundColor=[UIColor redColor];
        self.popView.backView.alpha=0.9;
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, popViewW-20, 20)];
        lab.text=str;
        lab.textAlignment = 1;
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:14];
        [self.popView.backView addSubview:lab];
        [self.popView popViewAtSuperView:self];
    });
}

-(void)setRightButtonCanClick:(BOOL)rightBtnCanClick{
    if (rightBtnCanClick) {
        [self.rightButton setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.rightButton setBackgroundColor:[UIColor convertHexToRGB:@"c9c8c8"]];
    }
}

- (void)setRightButtonTitle:(NSString *)title{
    self.rightButton.mTitleLabel.text=title;
}
#pragma mark - <setter and getter>
- (UleControlView *)leftButton{
    if (!_leftButton) {
        _leftButton=[self buildButtonWithFrame:CGRectMake(0, 0, __MainScreen_Width/2-KScreenScale(80), 32) Title:@"添加商品" andImage:@"myGoods_btn_findprd"];
        _leftButton.layer.cornerRadius=16;
        _leftButton.mTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        [_leftButton addTouchTarget:self action:@selector(findGoodsClick:)];
    }
    return _leftButton;
}
- (UleControlView *)rightButton{
    if (!_rightButton) {
        _rightButton=[self buildButtonWithFrame:CGRectMake(0, 0, __MainScreen_Width/2-KScreenScale(80), 32) Title:@"批量管理" andImage:@"myGoods_btn_manager"];
        [_rightButton addTouchTarget:self action:@selector(rightBtnClick:)];
        [_rightButton addSubview:self.redDotView];
        _rightButton.layer.cornerRadius=16;
        _rightButton.mTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        self.redDotView.sd_layout.leftSpaceToView(_rightButton.mTitleLabel, 3)
        .topSpaceToView(_rightButton, 6)
        .widthIs(8)
        .heightIs(8);
    }
    return _rightButton;
}
- (UIView * )redDotView{
    if (!_redDotView) {
        _redDotView=[UIView new];
        _redDotView.backgroundColor=[UIColor redColor];
        _redDotView.clipsToBounds=YES;
        _redDotView.layer.cornerRadius=5;
        _redDotView.hidden=YES;
    }
    return _redDotView;
}

@end
