//
//  US_StoreManagerCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_StoreManagerCell.h"
#import <UIView+SDAutoLayout.h>
@interface US_StoreManagerCell ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * leftTitleLabel;
@property (nonatomic, strong) UILabel * rightTitleLabel;
@property (nonatomic, assign) US_StoreManagerCellType cellType;

@end

@implementation US_StoreManagerCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView sd_addSubviews:@[self.iconImageView,self.leftTitleLabel,self.rightTitleLabel]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setModel:(US_StoreManagerCellModel *)model{
    _model=model;
    [self.contentView sd_clearAutoLayoutSettings];
    self.cellType=model.cellType;
    if ([model.imagePath rangeOfString:@"http"].location==NSNotFound&&model.imagePath.length>0) {
        [self.iconImageView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:model.imagePath]];
    }else{
        [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:NonEmpty(model.imagePath)] placeholder:[UIImage bundleImageNamed:@"mystore_icon_head_default"]];
    }
    self.leftTitleLabel.text=model.leftTitle;
    self.rightTitleLabel.text=model.rightTitle;
    [self.leftTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    if (model.cellType!=US_StoreManagerCellType2) {
         [self.rightTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
}

- (void)setCellType:(US_StoreManagerCellType)cellType{
    switch (cellType) {
        case US_StoreManagerCellType0:
            [self layoutCellType0];
            break;
        case US_StoreManagerCellType1:
            [self layoutCellType1];
            break;
        case US_StoreManagerCellType2:
            [self layoutCellType2];
            break;
        default:
            break;
    }
}

- (void) layoutCellType0{
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 20)
    .widthIs(60)
    .heightIs(60);
    
    self.leftTitleLabel.sd_layout.leftSpaceToView(self.iconImageView, 10)
    .centerYEqualToView(self.iconImageView)
    .heightIs(30)
    .autoWidthRatio(1);
    
    self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0)
    .centerYEqualToView(self.iconImageView)
    .heightIs(30)
    .autoWidthRatio(1);
    
    [self setupAutoHeightWithBottomView:self.iconImageView bottomMargin:20];
    self.iconImageView.layer.cornerRadius=30;
  
}

- (void)layoutCellType1{
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .widthIs(30)
    .heightIs(30);
    
    self.leftTitleLabel.sd_layout.leftSpaceToView(self.iconImageView, 10)
    .centerYEqualToView(self.iconImageView)
    .heightIs(30)
    .autoWidthRatio(1);
    
    self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0)
    .centerYEqualToView(self.iconImageView)
    .heightIs(30)
    .autoWidthRatio(1);
    
    [self setupAutoHeightWithBottomView:self.iconImageView bottomMargin:15];
    self.iconImageView.layer.cornerRadius=0;
}

- (void)layoutCellType2{
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 15)
    .widthIs(30)
    .heightIs(30);
    
    self.leftTitleLabel.sd_layout.topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.iconImageView, 10)
    .heightIs(30)
    .autoWidthRatio(1);
    self.rightTitleLabel.sd_layout.leftEqualToView(self.leftTitleLabel)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.leftTitleLabel, 10)
    .autoHeightRatio(0);
    self.rightTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
    [self setupAutoHeightWithBottomView:self.rightTitleLabel bottomMargin:15];
    self.iconImageView.layer.cornerRadius=0;    
}


#pragma mark - <setter and getter>
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[UIImageView new];
        _iconImageView.clipsToBounds=YES;
    }
    return _iconImageView;
}
- (UILabel *)leftTitleLabel{
    if (!_leftTitleLabel) {
        _leftTitleLabel=[UILabel new];
        _leftTitleLabel.font=[UIFont systemFontOfSize:15];
    }
    return _leftTitleLabel;
}
- (UILabel *)rightTitleLabel{
    if (!_rightTitleLabel) {
        _rightTitleLabel=[UILabel new];
        _rightTitleLabel.font=[UIFont systemFontOfSize:15];
        _rightTitleLabel.numberOfLines=0;
    }
    return _rightTitleLabel;
}

@end
