//
//  US_MessageListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MessageListCell.h"
#import <UIView+SDAutoLayout.h>
#import <UleDateFormatter.h>
#import <YYText.h>
static const CGFloat kMsgCellMargin = 10;

@interface US_MessageListCell ()

@property (nonatomic, strong) YYLabel * mTitleLabel;
@property (nonatomic, strong) YYLabel * mDateLabel;
@property (nonatomic, strong) YYLabel * mMessageLabel;
@property (nonatomic, strong) UIImageView * mImageView;
@property (nonatomic, strong) UIView * bgView;

@end

@implementation US_MessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSeparatorStyleNone;
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    UIView * backgroudView=[[UIView alloc] init];
    backgroudView.backgroundColor=[UIColor whiteColor];
    backgroudView.clipsToBounds=YES;
    backgroudView.layer.cornerRadius=10;
    self.bgView=backgroudView;
    [self.contentView sd_addSubviews:@[backgroudView]];
    backgroudView.sd_layout.topSpaceToView(self.contentView, kMsgCellMargin)
    .leftSpaceToView(self.contentView, kMsgCellMargin)
    .rightSpaceToView(self.contentView, kMsgCellMargin)
    .autoHeightRatio(0);
    UIView * line=[UIView new];
    line.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    
    [backgroudView sd_addSubviews:@[self.mTitleLabel,self.mDateLabel,self.mMessageLabel,self.mImageView,line]];
    self.mTitleLabel.sd_layout.leftSpaceToView(backgroudView, kMsgCellMargin)
    .topSpaceToView(backgroudView, 5)
    .rightSpaceToView(backgroudView, kMsgCellMargin)
    .heightIs(30);
    
    self.mDateLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .topSpaceToView(self.mTitleLabel, 0)
    .rightEqualToView(self.mTitleLabel)
    .heightIs(24);
    
    line.sd_layout.leftSpaceToView(backgroudView, kMsgCellMargin)
    .rightSpaceToView(backgroudView, kMsgCellMargin)
    .topSpaceToView(self.mDateLabel, 2)
    .heightIs(0.5);
    
    self.mMessageLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .rightEqualToView(self.mTitleLabel)
    .topSpaceToView(self.mDateLabel, kMsgCellMargin)
    .heightIs(64);
    
    self.mImageView.sd_layout.leftEqualToView(self.mTitleLabel)
    .rightEqualToView(self.mTitleLabel)
    .topSpaceToView(self.mMessageLabel, 5)
    .heightIs(80);
    
    [backgroudView setupAutoHeightWithBottomView:self.mImageView bottomMargin:5];
    [self setupAutoHeightWithBottomView:backgroudView bottomMargin:0];
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    US_MessageDetail * detail=(US_MessageDetail *)model.data;
    self.mTitleLabel.text= NonEmpty(detail.title);
    NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:[detail.sendTime longLongValue]/1000];
    self.mDateLabel.text=[UleDateFormatter GetCurrentDate2:createDate];//detail.createTime;
    self.mMessageLabel.text=detail.content;
    if (detail.pic.length>0) {
        self.mImageView.sd_layout.heightIs(80).topSpaceToView(self.mMessageLabel, 5);
        [self.mImageView yy_setImageWithURL:[NSURL URLWithString:detail.pic] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    }else{
        self.mImageView.sd_layout.heightIs(0).topSpaceToView(self.mMessageLabel, 0);
    }
//    @weakify(self);
//    self.bgView.didFinishAutoLayoutBlock = ^(CGRect frame) {
//        @strongify(self);
//        UIBezierPath *maskPath;
//        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds
//                                              cornerRadius:10.0];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = self.bgView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.bgView.layer.mask=maskLayer;
//    };
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <setter and getter>
- (YYLabel *)mTitleLabel{
    if(!_mTitleLabel){
        _mTitleLabel=[YYLabel new];
        _mTitleLabel.font=[UIFont systemFontOfSize:15];
        _mTitleLabel.displaysAsynchronously=YES;
    }
    return _mTitleLabel;
}

- (YYLabel *)mDateLabel{
    if (!_mDateLabel) {
        _mDateLabel=[YYLabel new];
        _mDateLabel.font=[UIFont systemFontOfSize:12];
        _mDateLabel.textColor=[UIColor convertHexToRGB:@"BFBFBF"];
        _mDateLabel.displaysAsynchronously=YES;
    }
    return _mDateLabel;
}

- (YYLabel *)mMessageLabel{
    if (!_mMessageLabel) {
        _mMessageLabel=[YYLabel new];
        _mMessageLabel.font=[UIFont systemFontOfSize:14];
        _mMessageLabel.numberOfLines=0;
        _mMessageLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        _mMessageLabel.displaysAsynchronously=YES;
    }
    return _mMessageLabel;
}

- (UIImageView *)mImageView{
    if (!_mImageView) {
        _mImageView=[UIImageView new];
    }
    return _mImageView;
}

@end

#pragma mark - 订单消息列表
@interface US_OrderMessageListCell ()

@property (nonatomic, strong) YYLabel * mTitleLabel;
@property (nonatomic, strong) YYLabel * mDateLabel;
@property (nonatomic, strong) YYLabel * mMessageLabel;
@property (nonatomic, strong) UIImageView * mImageView;
@property (nonatomic, strong) UIView * bgView;

@end

@implementation US_OrderMessageListCell

@end
