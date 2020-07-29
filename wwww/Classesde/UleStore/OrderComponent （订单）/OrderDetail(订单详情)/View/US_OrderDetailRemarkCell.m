//
//  US_OrderDetailRemarkCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailRemarkCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleCellBaseModel.h"

static CGFloat const KDetailRemarkCellMargin = 8.0;
@interface US_OrderDetailRemarkCell ()
@property (nonatomic, strong)UILabel    *mTitleLab;
@property (nonatomic, strong)UILabel    *mContentLab;
@end

@implementation US_OrderDetailRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.mTitleLab,self.mContentLab]];
    self.mTitleLab.sd_layout.topSpaceToView(self.contentView, KDetailRemarkCellMargin)
    .leftSpaceToView(self.contentView, KDetailRemarkCellMargin)
    .widthIs(55)
    .heightIs(16);
    self.mContentLab.sd_layout.topSpaceToView(self.contentView, KDetailRemarkCellMargin)
    .leftSpaceToView(self.mTitleLab, KDetailRemarkCellMargin)
    .rightSpaceToView(self.contentView, KDetailRemarkCellMargin)
    .autoHeightRatio(0);
    [self setupAutoHeightWithBottomViewsArray:@[self.mTitleLab,self.mContentLab] bottomMargin:KDetailRemarkCellMargin];
}

- (void)setModel:(UleCellBaseModel *)model{
    self.mContentLab.text=model.data;
}
#pragma mark - <getters>
-(UILabel *)mTitleLab{
    if (!_mTitleLab) {
        _mTitleLab=[[UILabel alloc]init];
        _mTitleLab.text=@"订单备注";
        _mTitleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _mTitleLab.font=[UIFont systemFontOfSize:13];
    }
    return _mTitleLab;
}
- (UILabel *)mContentLab{
    if (!_mContentLab) {
        _mContentLab=[[UILabel alloc]init];
        _mContentLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _mContentLab.numberOfLines=0;
        _mContentLab.font=[UIFont systemFontOfSize:13];
    }
    return _mContentLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
