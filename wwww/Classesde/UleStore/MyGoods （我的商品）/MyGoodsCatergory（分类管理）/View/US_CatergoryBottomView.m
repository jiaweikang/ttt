//
//  US_CatergoryBottomView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CatergoryBottomView.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>
#import "US_AddNewCategoryAlert.h"
#import <UIView+ShowAnimation.h>
@interface US_CatergoryBottomView ()
@property (nonatomic, strong) UleControlView * mAddButton;
@end


@implementation US_CatergoryBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.25;
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.mAddButton];
        self.mAddButton.sd_layout.centerXEqualToView(self)
        .topSpaceToView(self, 0)
        .heightIs(49)
        .autoWidthRatio(0);
    }
    return self;
}

- (void)showAddNewCategoryAlert{
    @weakify(self);
    US_AddNewCategoryAlert * alert=[US_AddNewCategoryAlert creatAlertWithConfirmBlock:^(NSString *categoryName) {
        @strongify(self);
        if (categoryName.length>0&&self.delegate&&[self.delegate respondsToSelector:@selector(addNewCatergoryWithName:)]) {
            [self.delegate addNewCatergoryWithName:categoryName];
        }
    }];
    [alert showViewWithAnimation:AniamtionAlert];
}


- (UleControlView *)buildButtonWithTitle:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] init];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mImageView.sd_layout.leftSpaceToView(button, 0)
    .centerYEqualToView(button)
    .widthIs(15)
    .heightIs(18);
    button.mTitleLabel.sd_layout.leftSpaceToView(button.mImageView, 10)
    .topSpaceToView(button, 0)
    .bottomSpaceToView(button, 0)
    .autoWidthRatio(0);
    button.mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
    button.mTitleLabel.font=[UIFont systemFontOfSize:14];
    [button.mTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [button setupAutoWidthWithRightView:button.mTitleLabel rightMargin:0];
    return button;
}
#pragma mark - <setter and getter>
- (UleControlView *)mAddButton{
    if (!_mAddButton) {
        _mAddButton=[self buildButtonWithTitle:@"新建分类" andImage:@"myGoods_btn_catergoryadd"];
        [_mAddButton addTouchTarget:self action:@selector(showAddNewCategoryAlert)];
    }
    return _mAddButton;
}
@end
