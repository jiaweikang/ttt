//
//  MyStoreGroupTwoCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupTwoCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"
#import "UleModulesDataToAction.h"

@interface MyStoreGroupTwoCell ()
@property (nonatomic, strong) UleControlView * leftButton;
@property (nonatomic, strong) UleControlView * rightButton;
@end

@implementation MyStoreGroupTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=kViewCtrBackColor;
        [self.contentView sd_addSubviews:@[self.leftButton,self.rightButton]];
        self.leftButton.sd_layout.leftSpaceToView(self.contentView, KScreenScale(10))
        .topSpaceToView(self.contentView, KScreenScale(10))
        .heightIs(KScreenScale(110))
        .widthIs((__MainScreen_Width-3*KScreenScale(10))/2.0);

        self.rightButton.sd_layout.topSpaceToView(self.contentView, KScreenScale(10))
        .rightSpaceToView(self.contentView, KScreenScale(10))
        .heightIs(KScreenScale(110))
        .widthRatioToView(self.leftButton, 1);
        
        [self layoutImageAndTitle:self.leftButton];
        [self layoutImageAndTitle:self.rightButton];
        
        [self setupAutoHeightWithBottomView:self.leftButton bottomMargin:KScreenScale(10)];
        
    }
    return self;
}

- (void)layoutImageAndTitle:(UleControlView *)controlView{
    controlView.mImageView.sd_layout.centerYEqualToView(controlView)
    .leftSpaceToView(controlView, KScreenScale(60))
    .widthIs(KScreenScale(60)).heightEqualToWidth();
    
    controlView.mTitleLabel.sd_layout.leftSpaceToView(controlView.mImageView, KScreenScale(40))
    .topSpaceToView(controlView, 0)
    .bottomSpaceToView(controlView, 0)
    .rightSpaceToView(controlView, KScreenScale(60));
    controlView.mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(US_MystoreCellModel *)model{
    _model=model;
    if (model.indexInfo.count==2) {
        HomeBtnItem * item=model.indexInfo[0];
        [self.leftButton.mImageView yy_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholder:nil];
        self.leftButton.mTitleLabel.text=item.title;
        self.leftButton.mTitleLabel.textColor=[UIColor convertHexToRGB:@"ff9453"];
        HomeBtnItem * item2=model.indexInfo[1];
        [self.rightButton.mImageView yy_setImageWithURL:[NSURL URLWithString:item2.imgUrl] placeholder:nil];
        self.rightButton.mTitleLabel.text=item2.title;
        self.rightButton.mTitleLabel.textColor=[UIColor whiteColor];
    }
}
#pragma mark - <click event>
- (void)buttonClick:(UleControlView *)sender{
    NSInteger tag=sender.tag;
    if (self.model.indexInfo&&self.model.indexInfo.count>tag) {
        HomeBtnItem * item=self.model.indexInfo[tag];
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
        [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        
    }
}

#pragma mark - <setter and getter>

- (UleControlView *)leftButton{
    if (!_leftButton) {
        _leftButton=[[UleControlView alloc] initWithFrame:CGRectZero];
        _leftButton.backgroundColor=[UIColor whiteColor];
        _leftButton.layer.borderColor=[UIColor convertHexToRGB:@"ff9453"].CGColor;
        _leftButton.layer.borderWidth=1;
        _leftButton.layer.cornerRadius=KScreenScale(15);
        _leftButton.clipsToBounds=YES;
        _leftButton.tag=0;
        [_leftButton addTouchTarget:self action:@selector(buttonClick:)];
    }
    return _leftButton;
}

- (UleControlView *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UleControlView alloc] initWithFrame:CGRectZero];
        _rightButton.backgroundColor=[UIColor convertHexToRGB:@"ff9453"];
        _rightButton.layer.cornerRadius=KScreenScale(15);
        _rightButton.clipsToBounds=YES;
        _rightButton.tag=1;
        [_rightButton addTouchTarget:self action:@selector(buttonClick:)];
    }
    return _rightButton;
}

@end
