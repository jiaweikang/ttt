//
//  MyWalletBannerCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/9/25.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyWalletBannerCell.h"
#import "MyWalletCellModel.h"
#import <UIView+SDAutoLayout.h>
#import "YYAnimatedImageView.h"

@interface MyWalletBannerCell ()
@property (nonatomic, strong) YYAnimatedImageView   * imgView;
@property (nonatomic, strong) MyWalletCellModel * model;
@end
@implementation MyWalletBannerCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .widthIs(__MainScreen_Width)
        .heightIs(__MainScreen_Width*0.213);
        [self setupAutoHeightWithBottomView:self.imgView bottomMargin:0];
         }
         return self;
}
- (void)setModel:(MyWalletCellModel *)model {
    _model = model;
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:_model.iconUrlStr] placeholder:nil];
    if ([_model.img_wh_rate floatValue]>0) {
        self.imgView.sd_layout.heightIs(__MainScreen_Width/[_model.img_wh_rate floatValue]);
    }else {
        self.imgView.sd_layout.heightIs(__MainScreen_Width/4.69);
    }
}

#pragma mark - <setter and getter>
- (YYAnimatedImageView *)imgView{
    if (!_imgView) {
        _imgView=[[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Width*0.213)];
    }
    return _imgView;
}
@end
