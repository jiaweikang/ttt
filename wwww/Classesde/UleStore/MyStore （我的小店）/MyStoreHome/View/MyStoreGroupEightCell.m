//
//  MyStoreGroupEightCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupEightCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_MystoreCellModel.h"
#import "UleModulesDataToAction.h"

@interface MyStoreGroupEightCell ()
@property (nonatomic, strong)YYAnimatedImageView    *mImageView;
@property (nonatomic, strong)US_MystoreCellModel    *mModel;
@end

@implementation MyStoreGroupEightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mImageView];
    self.mImageView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(0);
    [self setupAutoHeightWithBottomView:self.mImageView bottomMargin:KScreenScale(20)];
}

- (void)setModel:(US_MystoreCellModel*)model{
    if ([self.mModel isEqual:model]) return;
    self.mModel=model;
    HomeBtnItem *item=model.extentInfo;
    [self.mImageView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:item.imgUrl]] placeholder:nil];
    CGFloat viewHeight=KScreenScale(200);
    if ([item.wh_rate floatValue]>0) {
        viewHeight=KScreenScale(710)/item.wh_rate.floatValue;
    }
    self.mImageView.sd_layout.heightIs(viewHeight);
}

- (void)clickAction:(UIGestureRecognizer *)ges{
    HomeBtnItem *item=self.mModel.extentInfo;
    UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
    //日志
    if ([NSString isNullToString:item.log_title].length>0) {
        [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
    }
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

#pragma mark - <getters>
- (YYAnimatedImageView *)mImageView{
    if (!_mImageView) {
        _mImageView=[[YYAnimatedImageView alloc]init];
        _mImageView.sd_cornerRadius=@(5);
        _mImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [_mImageView addGestureRecognizer:tapGes];
    }
    return _mImageView;
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
