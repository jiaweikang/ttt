//
//  US_LogisticDetailCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticDetailCell.h"
#import <UIView+SDAutoLayout.h>


#define kLeftMagin 20
#define kImageOffSetY 12
#define kImageSize  10
#define kSignImageSize 16

@interface US_LogisticDetailCell ()
@property (nonatomic, strong) UILabel * messagelabel;
@property (nonatomic, strong) UILabel * timeLabel;
@end


@implementation US_LogisticDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView sd_addSubviews:@[self.messagelabel,self.timeLabel]];
    self.messagelabel.sd_layout
    .leftSpaceToView(self.contentView,56)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.messagelabel)
    .topSpaceToView(self.messagelabel,5)
    .rightSpaceToView(self.contentView,15)
    .heightIs(18);
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:10];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(US_LogisticDetailCellModel *)model{
    _model=model;
    
    if ([model.states isEqualToString:@"0"]) {
        self.messagelabel.textColor=[UIColor redColor];
        self.timeLabel.textColor=[UIColor redColor];
    }else{
        self.messagelabel.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        self.timeLabel.textColor=[UIColor convertHexToRGB:kBlackTextColor];;
    }
    self.messagelabel.text=model.packageInfo;
    self.timeLabel.text=model.time;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.6);
    CGFloat lineX;
    if ([_model.states isEqualToString: @"0"]) {
        UIImage * image=[UIImage bundleImageNamed:@"Logistics_icon_sign"];
        [image drawAtPoint:CGPointMake(kLeftMagin+kImageSize/2.0-image.size.width/2.0, kImageOffSetY)];
//        [image drawInRect:CGRectMake(kLeftMagin, kImageOffSetY, kSignImageSize, kSignImageSize)];
        CGContextMoveToPoint(context,  kLeftMagin+kImageSize/2.0,kImageOffSetY+kSignImageSize);
        CGContextAddLineToPoint(context, kLeftMagin+kImageSize/2.0,rect.size.height);
        lineX=56;
    }else if ([_model.states isEqualToString: @"1"]){
        UIImage * dotImage=[UIImage bundleImageNamed:@"Logistics_icon_circle"];
        [dotImage drawInRect:CGRectMake(kLeftMagin, kImageOffSetY, kImageSize, kImageSize)];
        CGContextMoveToPoint(context,   kLeftMagin+kImageSize/2.0,0);
        CGContextAddLineToPoint(context, kLeftMagin+kImageSize/2.0,kImageOffSetY);
        CGContextMoveToPoint(context,   kLeftMagin+kImageSize/2.0,kImageOffSetY+kImageSize);
        CGContextAddLineToPoint(context, kLeftMagin+kImageSize/2.0,rect.size.height);
        lineX=56;
    }else{
        UIImage * dotImage=[UIImage bundleImageNamed:@"Logistics_icon_circle"];
        [dotImage drawInRect:CGRectMake(kLeftMagin, kImageOffSetY, kImageSize, kImageSize)];
        CGContextMoveToPoint(context,   kLeftMagin+kImageSize/2.0,0);
        CGContextAddLineToPoint(context, kLeftMagin+kImageSize/2.0,kImageOffSetY);
        lineX=0;
    }
    CGContextMoveToPoint(context,  lineX,rect.size.height-0.6);
    CGContextAddLineToPoint(context,rect.size.width,rect.size.height-0.6);
    CGContextStrokePath(context);
    
}

- (UILabel *)buildLabelWithTextColor:(NSString *)color andFontSize:(CGFloat)fontSize{
    UILabel * label=[[UILabel alloc] init];
    label.textColor=[UIColor convertHexToRGB:color];
    label.font=[UIFont systemFontOfSize:fontSize];
    return label;
}

- (UILabel *)messagelabel{
    if (!_messagelabel) {
        _messagelabel=[UILabel new];
        _messagelabel.font=[UIFont systemFontOfSize:14];
        _messagelabel.isAttributedContent=YES;
    }
    return _messagelabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[self buildLabelWithTextColor:kBlackTextColor andFontSize:11];
    }
    return  _timeLabel;
}

@end
