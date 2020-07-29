//
//  LogoutViewBottomCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "LogoutViewBottomCell.h"
#import <UIView+SDAutoLayout.h>
#import <YYText.h>

@interface LogoutViewBottomCell ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, copy) NSString *phoneNumStr;
@end

@implementation LogoutViewBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = kViewCtrBackColor;
    [self.contentView sd_addSubviews:@[self.titleLab]];
    self.titleLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:15];
}
- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    NSString *tipsStr=(NSString *)model.data;
    
    NSArray * array = [tipsStr componentsSeparatedByString:@"##"];
    _phoneNumStr = array.lastObject;
    tipsStr = [NSString stringWithFormat:@"Tip：%@",[tipsStr  stringByReplacingOccurrencesOfString:@"##" withString:@""]];
    
    NSMutableAttributedString *mutablestr = [[NSMutableAttributedString alloc]initWithString:tipsStr];
    if (_phoneNumStr.length>0) {
        //电话号码加下划线
        NSRange range = [tipsStr rangeOfString:_phoneNumStr options:NSCaseInsensitiveSearch];
        [mutablestr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [mutablestr addAttribute:NSUnderlineColorAttributeName value:[UIColor convertHexToRGB:@"666666"] range:range];
    }

    self.titleLab.attributedText = mutablestr;
}

- (void)tapMessage:(UITapGestureRecognizer *)tap {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", _phoneNumStr.length > 0?_phoneNumStr:@"28943666"]]];
}

#pragma mark - <setter and getter>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _titleLab.textColor = [UIColor convertHexToRGB:@"666666"];
        _titleLab.numberOfLines = 0;
        _titleLab.userInteractionEnabled = YES;
        [_titleLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessage:)]];
    }
    return _titleLab;
}


@end
