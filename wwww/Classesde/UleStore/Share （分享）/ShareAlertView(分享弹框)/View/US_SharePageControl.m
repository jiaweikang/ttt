//
//  US_SharePageControl.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SharePageControl.h"
#import <UIView+SDAutoLayout.h>

#define kPageControlWidth  200
#define kPageControlHeight 30

@interface US_SharePageControl ()
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UILabel * middelLabel;
@end

@implementation US_SharePageControl

- (instancetype)initWithTotalPages:(NSInteger )totoal{
    self =[super initWithFrame:CGRectMake(0, 0, kPageControlWidth, kPageControlHeight)];
    if (self) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_totoalPage||!_currentPage||_totoalPage<=1||_currentPage<=0||_currentPage>_totoalPage) {
        self.hidden=YES;
        return;
    }
    self.middelLabel.text=[NSString stringWithFormat:@"%@/%@",@(_currentPage),@(_totoalPage)];
}

- (void)setUI{
    
    [self sd_addSubviews:@[self.leftButton,self.rightButton,self.middelLabel]];
    self.leftButton.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthEqualToHeight();
    self.rightButton.sd_layout.rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .widthEqualToHeight();
    self.middelLabel.sd_layout.leftSpaceToView(self.leftButton, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self.rightButton, 0);
    
    self.layer.cornerRadius=self.height_sd/2.0;
    self.clipsToBounds=YES;
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
}

- (void)leftBtnAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(picSharePageLeftBtnClick:)]) {
        if (_currentPage>1) {
            self.currentPage=self.currentPage-1;
            [self.delegate picSharePageLeftBtnClick:self.currentPage];
        }
    }
}

- (void)rightBtnAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(picSharePageRightBtnClick:)]) {
        if (_currentPage<_totoalPage) {
            self.currentPage=self.currentPage+1;
            [self.delegate picSharePageRightBtnClick:self.currentPage];
        }
    }
}



#pragma mark - <setter and getter>

- (void)setTotoalPage:(NSInteger)totoalPage{
    _totoalPage=totoalPage;
    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage=currentPage;
    [self setNeedsLayout];
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton=[[UIButton alloc] init];
        [_leftButton setImage:[UIImage bundleImageNamed:@"share_pic_left"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UIButton alloc] init];
        [_rightButton setImage:[UIImage bundleImageNamed:@"share_pic_right"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)middelLabel{
    if (!_middelLabel) {
        _middelLabel=[UILabel new];
        _middelLabel.textAlignment=NSTextAlignmentCenter;
        _middelLabel.textColor=[UIColor whiteColor];
        _middelLabel.font=[UIFont systemFontOfSize:13];
        [_middelLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _middelLabel;
}
@end
