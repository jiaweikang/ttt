//
//  US_OrderDetailBottomView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailBottomView.h"
#import <UIView+SDAutoLayout.h>
#import "OrderCellButton.h"
#define kMaginOffSet   10
@interface US_OrderDetailBottomView ()
@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) OrderCellButton * bottomBtnOne;
@property (nonatomic, strong) OrderCellButton * bottomBtnTwo;
@property (nonatomic, strong) OrderCellButton * bottomBtnThree;
@end


@implementation US_OrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    [self sd_addSubviews:@[self.bottomBtnOne,self.bottomBtnTwo,self.bottomBtnThree,self.topLine]];
    self.topLine.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.5);
    
    self.bottomBtnOne.sd_layout.rightSpaceToView(self, kMaginOffSet)
    .topSpaceToView(self, kMaginOffSet )
    .widthIs(74)
    .heightIs(30);
    
    self.bottomBtnTwo.sd_layout.rightSpaceToView(self.bottomBtnOne,kMaginOffSet)
    .topEqualToView(self.bottomBtnOne)
    .widthIs(74)
    .heightIs(30);
    
    self.bottomBtnThree.sd_layout.rightSpaceToView(self.bottomBtnTwo,kMaginOffSet)
    .topEqualToView(self.bottomBtnOne).widthIs(74).heightIs(30);
}

- (void)setModel:(US_OrderListFooterModel *)model{
    _model=model;
    self.bottomBtnOne.buttonState=model.buttonOneState;
    self.bottomBtnTwo.buttonState=model.buttonTwoState;
    self.bottomBtnThree.buttonState=model.buttonThreeState;
    if (self.bottomBtnOne.buttonState == OrderButtonStateHidden) {
        self.bottomBtnOne.sd_layout.widthIs(0);
        self.bottomBtnTwo.sd_layout.rightSpaceToView(self.bottomBtnOne, 0);
    }else{
        self.bottomBtnOne.sd_layout.widthIs(74);
        self.bottomBtnTwo.sd_layout.rightSpaceToView(self.bottomBtnOne, kMaginOffSet);
    }
    
    if (self.bottomBtnTwo.buttonState == OrderButtonStateHidden) {
        self.bottomBtnTwo.sd_layout.widthIs(0);
        self.bottomBtnThree.sd_layout.rightSpaceToView(self.bottomBtnTwo, 0);
    }else{
        self.bottomBtnTwo.sd_layout.widthIs(74);
        self.bottomBtnThree.sd_layout.rightSpaceToView(self.bottomBtnTwo, kMaginOffSet);
    }
}

#pragma mark - <button event>
- (void)orderCellButtonClick:(OrderCellButton *)btn event:(id)event{
    OrderButtonState state= btn.buttonState;
    if (self.delegate && [self.delegate respondsToSelector:@selector(footButtonClick:)]) {
        [self.delegate footButtonClick:state];
    }
}


#pragma mark - <setter and getter>
- (UIView *)topLine{
    if (!_topLine) {
        _topLine=[UIView new];
        _topLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    }
    return _topLine;
}

- (OrderCellButton *) buildCustemButton{
    OrderCellButton *btn=[[OrderCellButton alloc] init];
    btn.titleLabel.font=[UIFont systemFontOfSize:13];
    btn.sd_cornerRadius = @(2);
    [btn addTarget:self action:@selector(orderCellButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (OrderCellButton *)bottomBtnOne{
    if (!_bottomBtnOne) {
        _bottomBtnOne=[self buildCustemButton];
    }
    return _bottomBtnOne;
}

- (OrderCellButton *)bottomBtnTwo{
    if (!_bottomBtnTwo) {
        _bottomBtnTwo= [self buildCustemButton];
    }
    return _bottomBtnTwo;
}

- (OrderCellButton *)bottomBtnThree{
    if (!_bottomBtnThree) {
        _bottomBtnThree=[self buildCustemButton];
    }
    return _bottomBtnThree;
}
@end
