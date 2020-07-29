//
//  CommentHeadCell.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "CommentHeadCell.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+Utilty.h"
//#import "CellProtocol.h"
#import "CommentStarView.h"
#import "CommentHeadCellModel.h"

#define kMaginOffsetX 10

@interface CommentHeadCell () <CommentStarViewDelegate>
@property (nonatomic, strong) CommentStarView *serverStarView; //服务评分
@property (nonatomic, strong) CommentStarView *logisticStarView; //物流评分
@property (nonatomic, strong) CommentHeadCellModel *model;
@end

@implementation CommentHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *title = [UILabel initWithTextColor:@"333333" andFontSize:15];
    title.text = @"服务与物流评价";
    [self.contentView sd_addSubviews:@[title,self.serverStarView,self.logisticStarView]];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, kMaginOffsetX)
    .topSpaceToView(self.contentView, kMaginOffsetX)
    .rightSpaceToView(self.contentView, kMaginOffsetX)
    .heightIs(16);
    
    self.serverStarView.sd_layout
    .leftSpaceToView(self.contentView,kMaginOffsetX)
    .topSpaceToView(title,2*kMaginOffsetX)
    .rightSpaceToView(self.contentView,kMaginOffsetX)
    .heightIs(30);
    
    self.logisticStarView.sd_layout
    .leftSpaceToView(self.contentView,kMaginOffsetX)
    .topSpaceToView(self.serverStarView,0)
    .rightSpaceToView(self.contentView,kMaginOffsetX)
    .heightIs(30);
    
    [self setupAutoHeightWithBottomView:self.logisticStarView bottomMargin:kMaginOffsetX];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1].CGColor);
    CGContextSetLineWidth(context, 0.4);
    CGContextMoveToPoint(context,  0,self.serverStarView.top_sd-kMaginOffsetX);
    CGContextAddLineToPoint(context,rect.size.width,self.serverStarView.top_sd-kMaginOffsetX);
    CGContextStrokePath(context);
}

- (void)setModel:(CommentHeadCellModel *)model {
    _model = model;
}

- (void)didSetCommentStars:(NSString *)stars {
    _model.serverStars = [NSString stringWithFormat:@"%@", @(_serverStarView.stars)];
    _model.logisticStars = [NSString stringWithFormat:@"%@", @(_logisticStarView.stars)];
}

#pragma mark - setter and getter
- (CommentStarView *)serverStarView {
    if (!_serverStarView) {
        _serverStarView = [[CommentStarView alloc] initWithFrame:CGRectZero andTitle:@"服务态度" andType:@"1"];
        _serverStarView.delegate = self;
    }
    return _serverStarView;
}

- (CommentStarView *)logisticStarView {
    if (!_logisticStarView) {
        _logisticStarView = [[CommentStarView alloc] initWithFrame:CGRectZero andTitle:@"物流服务" andType:@"1"];
        _logisticStarView.delegate = self;
    }
    return _logisticStarView;
}

@end
