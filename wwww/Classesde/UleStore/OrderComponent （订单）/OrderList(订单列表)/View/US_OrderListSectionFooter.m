//
//  US_OrderListSectionFooter.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListSectionFooter.h"
#import <UIView+SDAutoLayout.h>
#import "OrderCellButton.h"

#define kMaginOffSet   10

@interface US_OrderListSectionFooter ()
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * footLabel;
@property (nonatomic, strong) UIView * splitLine;
@property (nonatomic, strong) OrderCellButton * bottomBtnOne;
@property (nonatomic, strong) OrderCellButton * bottomBtnTwo;
@property (nonatomic, strong) OrderCellButton * bottomBtnThree;
@end

@implementation US_OrderListSectionFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.bgView.sd_layout.bottomSpaceToView(self.contentView, 5);
        [self.bgView sd_addSubviews:@[self.footLabel,self.splitLine,self.bottomBtnOne,self.bottomBtnTwo,self.bottomBtnThree]];
        self.footLabel.sd_layout.topSpaceToView(self.bgView, 0)
        .rightSpaceToView(self.bgView, 8)
        .heightIs(45).leftSpaceToView(self.bgView, 8);
        
        self.splitLine.sd_layout.topSpaceToView(self.footLabel, 0)
        .leftSpaceToView(self.bgView, 0)
        .rightSpaceToView(self.bgView, 0)
        .heightIs(0.6);
        
        self.bottomBtnOne.sd_layout.rightSpaceToView(self.bgView, kMaginOffSet)
        .topSpaceToView(self.splitLine, kMaginOffSet )
        .widthIs(74)
        .heightIs(30);
        
        self.bottomBtnTwo.sd_layout.rightSpaceToView(self.bottomBtnOne,kMaginOffSet)
        .topEqualToView(self.bottomBtnOne)
        .widthIs(74)
        .heightIs(30);
        
        self.bottomBtnThree.sd_layout.rightSpaceToView(self.bottomBtnTwo,kMaginOffSet)
        .topEqualToView(self.bottomBtnOne).widthIs(74).heightIs(30);
    }
    return self;
}


- (void)setModel:(US_OrderListSectionModel*)model{
    _model=model;
    self.footLabel.attributedText=model.footerModel.footValueAttribute;
    self.bottomBtnOne.buttonState=model.footerModel.buttonOneState;
    self.bottomBtnTwo.buttonState=model.footerModel.buttonTwoState;
    self.bottomBtnThree.buttonState=model.footerModel.buttonThreeState;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(footButtonClick:sectionModel:)]) {
        [self.delegate footButtonClick:state sectionModel:self.model];
    }
}


#pragma mark - <setter and getter>

- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[UIView new];
        _bgView.backgroundColor=[UIColor whiteColor];
    }
    return _bgView;
}
- (UILabel *)footLabel{
    if (!_footLabel) {
        _footLabel=[UILabel new];
        _footLabel.font = [UIFont boldSystemFontOfSize:13];
        _footLabel.textAlignment = NSTextAlignmentRight;
        _footLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _footLabel.isAttributedContent=YES;
    }
    return _footLabel;
}

- (UIView *)splitLine{
    if (!_splitLine) {
        _splitLine=[UIView new];
        _splitLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    }
    return _splitLine;
}

- (OrderCellButton *) buildCustemButton{
    OrderCellButton *btn=[[OrderCellButton alloc] init];
    btn.titleLabel.font=[UIFont systemFontOfSize:13];
    btn.sd_cornerRadius=@(2);
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
