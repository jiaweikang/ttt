//
//  MyWalletCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyWalletCell.h"
#import "MyWalletCellModel.h"
#import <UIView+SDAutoLayout.h>
#import "YYAnimatedImageView.h"

@interface MyWalletCell ()
@property (nonatomic, strong) YYAnimatedImageView   * imgView;
@property (nonatomic, strong) UILabel       * leftLabel;
@property (nonatomic, strong) UILabel       * rightLabel;
@property (nonatomic, strong) UIImageView   * rightArrowIcon;
@property (nonatomic, strong) UIView        * line;
@property (nonatomic, strong) UILabel       * markLabel;

@property (nonatomic, strong) MyWalletCellModel * model;
@end
@implementation MyWalletCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.imgView,self.leftLabel,self.rightLabel,self.line,self.rightArrowIcon,self.markLabel]];
        
        self.imgView.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 7)
        .widthIs(34)
        .heightIs(34);
        self.rightArrowIcon.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .centerYEqualToView(self.imgView)
        .widthIs(8)
        .heightIs(14);
        self.rightLabel.sd_layout
        .rightSpaceToView(self.rightArrowIcon,10)
        .topSpaceToView(self.contentView, 0)
        .widthIs(140)
        .heightIs(48);
        self.leftLabel.sd_layout
        .leftSpaceToView(self.imgView, 5)
        .rightSpaceToView(self.rightLabel, 0)
        .centerYEqualToView(self.imgView)
        .heightIs(34);
        self.markLabel.sd_layout
        .leftEqualToView(self.imgView)
        .rightEqualToView(self.rightArrowIcon)
        .topSpaceToView(self.imgView, 0)
        .heightIs(0);
        self.line.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.markLabel, 7)
        .heightIs(0.7);
        
        [self setupAutoHeightWithBottomView:_line bottomMargin:0];
    }
    return self;
}

- (void)setModel:(MyWalletCellModel *)model {
    _model = model;
    if (_model.iconUrlStr.length>0) {
        [self.imgView yy_setImageWithURL:[NSURL URLWithString:_model.iconUrlStr] placeholder:nil];
        self.imgView.sd_layout.widthIs(34);
    }
    else{
        self.imgView.sd_layout.widthIs(0);
    }
    self.leftLabel.text=_model.titleStr;
    self.rightLabel.attributedText=model.rightTitle;
    if (model.ios_action.length>0) {
        self.rightArrowIcon.hidden = NO;
        self.userInteractionEnabled = YES;
        self.rightLabel.sd_layout
        .rightSpaceToView(self.rightArrowIcon,10);
    }
    else{
        self.rightArrowIcon.hidden = YES;
        self.userInteractionEnabled = NO;
        self.rightLabel.sd_layout
        .rightSpaceToView(self.contentView, 25);
    }
    if (_model.sub_titleStr.length>0) {
        self.markLabel.sd_layout.heightIs(20);
        self.markLabel.text=_model.sub_titleStr;
    }
    else{
        self.markLabel.sd_layout.heightIs(0);
    }

}

#pragma mark - <setter and getter>
- (YYAnimatedImageView *) imgView{
    if (!_imgView) {
        _imgView=[[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    }
    return _imgView;
}
- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel=[[UILabel alloc] init];
        _leftLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel=[[UILabel alloc] init];
        _rightLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _rightLabel;
}
- (UIImageView *)rightArrowIcon{
    if (!_rightArrowIcon) {
        _rightArrowIcon=[[UIImageView alloc] init];
        _rightArrowIcon.image=[UIImage bundleImageNamed:@"rightArrow"];
    }
    return _rightArrowIcon;
}
- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor convertHexToRGB:@"c8c8c8"];
    }
    return _line;
}

- (UILabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _markLabel.font = [UIFont systemFontOfSize:12];
        _markLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _markLabel;
}
@end
