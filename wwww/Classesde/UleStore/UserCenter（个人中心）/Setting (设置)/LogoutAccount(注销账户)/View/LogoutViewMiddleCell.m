//
//  LogoutMiddleCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "LogoutViewMiddleCell.h"
#import <UIView+SDAutoLayout.h>
#import "LogoutModel.h"

@interface LogoutViewMiddleCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;

@end
@implementation LogoutViewMiddleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    [self.contentView sd_addSubviews:@[self.titleLab,self.contentLab,lineView]];
    self.titleLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20);
    lineView.sd_layout
    .topSpaceToView(self.titleLab, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    self.contentLab.sd_layout
    .topSpaceToView(lineView, 15)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);
    
    
    [self setupAutoHeightWithBottomView:self.contentLab bottomMargin:15];
}
- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    LogoutSectionData *info=(LogoutSectionData *)model.data;
    self.titleLab.text = info.title;
    self.contentLab.text = [NSString stringWithFormat:@"· %@",[info.content  stringByReplacingOccurrencesOfString:@"##" withString:@"\n\n· "]];
}
#pragma mark - <setter and getter>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:KScreenScale(34)];
        _titleLab.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _titleLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab=[UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _contentLab.textColor = [UIColor convertHexToRGB:@"333333"];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

@end
