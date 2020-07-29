//
//  MyWalletTitleCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/9/26.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyWalletTitleCell.h"
#import "MyWalletCellModel.h"
#import <UIView+SDAutoLayout.h>

@interface MyWalletTitleCell ()

@property (nonatomic, strong) UILabel       * leftLabel;
@property (nonatomic, strong) UIView        * line;
@property (nonatomic, strong) UILabel       * markLabel;

@property (nonatomic, strong) MyWalletCellModel * model;
@end
@implementation MyWalletTitleCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.leftLabel,self.line,self.markLabel]];

        self.leftLabel.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 5)
        .heightIs(30);
        self.markLabel.sd_layout
        .leftEqualToView(self.leftLabel)
        .rightEqualToView(self.leftLabel)
        .topSpaceToView(self.leftLabel, 0)
        .heightIs(0);
        self.line.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.markLabel, 5)
        .heightIs(0.7);
        
        [self setupAutoHeightWithBottomView:_line bottomMargin:0];
    }
    return self;
}
- (void)setModel:(MyWalletCellModel *)model {
    _model = model;
    self.leftLabel.text=_model.titleStr;
    
    if (_model.sub_titleStr.length>0) {
        self.markLabel.sd_layout.heightIs(20);
        self.markLabel.text=_model.sub_titleStr;
    }
    else{
        self.markLabel.sd_layout.heightIs(0);
    }
}
#pragma mark - <setter and getter>

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel=[[UILabel alloc] init];
        _leftLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        _leftLabel.font = [UIFont systemFontOfSize:17];
    }
    return _leftLabel;
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
