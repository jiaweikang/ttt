//
//  US_OrderDetailCarQRCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailCarQRCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleCellBaseModel.h"
#import "UIImage+USAddition.h"

@interface US_OrderDetailCarQRCell ()
@property (nonatomic, copy)UILabel  *titleLab;
@property (nonatomic, strong)UIImageView    *qrImgView;
@end

@implementation US_OrderDetailCarQRCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab,self.qrImgView]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, KScreenScale(30))
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(20);
    self.qrImgView.sd_layout.topSpaceToView(self.titleLab, KScreenScale(20))
    .centerXEqualToView(self.titleLab)
    .widthIs(KScreenScale(250))
    .heightIs(KScreenScale(250));
    
    [self setupAutoHeightWithBottomView:self.qrImgView bottomMargin:KScreenScale(30)];
}

- (void)setModel:(UleCellBaseModel *)model{
    [self.qrImgView setImage:[UIImage uleQRCodeForString:model.data size:200 fillColor:[UIColor blackColor] iconImage:nil]];
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.text=@"验证码（到店后请向销售人员出示）";
        _titleLab.font=[UIFont systemFontOfSize:14];
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLab;
}
-(UIImageView *)qrImgView{
    if (!_qrImgView) {
        _qrImgView=[[UIImageView alloc]init];
    }
    return _qrImgView;
}

@end
