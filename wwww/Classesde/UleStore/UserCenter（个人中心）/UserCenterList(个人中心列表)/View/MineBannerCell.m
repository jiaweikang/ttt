//
//  MineBannerCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/11/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MineBannerCell.h"
#import "MineCellModel.h"
#import <UIView+SDAutoLayout.h>
#import "YYAnimatedImageView.h"

@interface MineBannerCell ()
@property (nonatomic, strong) YYAnimatedImageView   * imgView;
@property (nonatomic, strong) MineCellModel * model;
@end
@implementation MineBannerCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.imgView];
        self.imgView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .widthIs(__MainScreen_Width-20)
        .heightIs(__MainScreen_Width*0.213);
        [self setupAutoHeightWithBottomView:self.imgView bottomMargin:0];
         }
         return self;
}
- (void)setModel:(MineCellModel *)model {
    _model = model;
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:_model.iconUrlStr] placeholder:nil];
    if ([_model.wh_rate floatValue]>0) {
        self.imgView.sd_layout.heightIs(__MainScreen_Width/[_model.wh_rate floatValue]);
    }else {
        self.imgView.sd_layout.heightIs(__MainScreen_Width*0.213);
    }

}

#pragma mark - <setter and getter>
- (YYAnimatedImageView *)imgView{
    if (!_imgView) {
        _imgView=[[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width-20, __MainScreen_Width*0.213)];
    }
    return _imgView;
}

@end
