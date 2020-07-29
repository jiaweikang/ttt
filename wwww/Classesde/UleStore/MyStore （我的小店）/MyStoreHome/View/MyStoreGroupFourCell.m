//
//  MyStoreGroupFourCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupFourCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_NewsClass.h"
#import "UleModulesDataToAction.h"

@interface USNewsView:UIImageView
@property (nonatomic, strong) UILabel * contentTopLabel;
@property (nonatomic, strong) UILabel * contentBottomLabel;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSArray * contentArray;
@property (nonatomic, strong) NSMutableArray * lableArray;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation USNewsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.layer.masksToBounds=YES;
    [self setupView];
   
    return self;
}

- (void)dealloc{
    NSLog(@"__%s",__FUNCTION__);
    [self closeLEDtimer];
}

- (void)closeLEDtimer{
    if (self.timer) {
        dispatch_source_cancel(_timer);
        _timer=NULL;
    }
}

- (void)setupView{
    CGFloat labelHeight=self.frame.size.height;
    _contentTopLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, labelHeight)];
    _contentTopLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    _contentTopLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
    _contentTopLabel.textAlignment=NSTextAlignmentLeft;
    _contentTopLabel.adjustsFontSizeToFitWidth=YES;
    _contentBottomLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight, self.frame.size.width, labelHeight)];
    _contentBottomLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    _contentBottomLabel.textAlignment=NSTextAlignmentLeft;
    _contentBottomLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
    _contentBottomLabel.adjustsFontSizeToFitWidth=YES;
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-labelHeight)/2.0, self.frame.size.width, labelHeight)];
    _contentView.layer.masksToBounds=YES;
    [_contentView addSubview:_contentTopLabel];
    [_contentView addSubview:_contentBottomLabel];
    [self addSubview:_contentView];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray=[contentArray copy];
    self.contentTopLabel.text=_contentArray.firstObject;
    self.contentBottomLabel.text=_contentArray.count>1?_contentArray[1]:@"";
    [self closeLEDtimer];
    [self startScrollLabelTimer];
}



- (void) startScrollLabelTimer{
    _countNum=2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,  (int64_t)(4.0 * NSEC_PER_SEC)),4.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swapLabels];
        });
    });
    dispatch_resume(_timer);
}

- (void)swapLabels{
    if (self.contentArray==nil||self.contentArray.count<=1) {
        return;
    }
    _countNum=_countNum%self.contentArray.count;
    [UIView animateWithDuration:0.8 animations:^{
        for (UILabel * subLabel in self.contentView.subviews) {
            NSString * newTop=[NSString stringWithFormat:@"%.3f",(subLabel.frame.origin.y-subLabel.frame.size.height)];
            subLabel.frame=CGRectMake(0, [newTop floatValue], subLabel.frame.size.width, subLabel.frame.size.height);
        }

    } completion:^(BOOL finished) {
        for (UILabel * subLabel in self.contentView.subviews) {
            CGFloat top=subLabel.frame.origin.y;
            NSString * topStr=[NSString stringWithFormat:@"%.3f",top];
            if ([topStr floatValue]<0) {
                subLabel.frame=CGRectMake(0,subLabel.frame.size.height, subLabel.frame.size.width, subLabel.frame.size.height);
                subLabel.text=self.contentArray[self.countNum];
            }
        }
        self.countNum++;
    }];
}

@end



@interface MyStoreGroupFourCell ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) USNewsView * newsLabel;
@property (nonatomic, strong) NSArray<US_NewsBase *> * newsList;
@property (nonatomic, assign) NSInteger showNum;
@end

@implementation MyStoreGroupFourCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void) setupView{
    UIView * line=[UIView new];
    line.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
    [self.contentView sd_addSubviews:@[self.iconImageView,self.newsLabel,line]];
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, KScreenScale(30))
    .topSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(KScreenScale(50))
    .widthIs(KScreenScale(50)*1.2);
    
    line.sd_layout.leftSpaceToView(self.iconImageView, KScreenScale(15))
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(0.5);
    
    self.newsLabel.sd_layout.leftSpaceToView(line, KScreenScale(15))
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, KScreenScale(30));
    
    [self setupAutoHeightWithBottomView:self.iconImageView bottomMargin:KScreenScale(20)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(US_MystoreCellModel *)model{
    _model=model;
    if (_model.indexInfo.count>0) {
        HomeBtnItem * item=_model.indexInfo[0];
        [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholder:nil];
    }
    self.newsList=(NSArray *)model.extentInfo;
    if (self.newsLabel.contentArray==nil||self.newsLabel.contentArray.count<=0) {
        NSMutableArray * contents=[[NSMutableArray alloc] init];
        for (int i=0; i<self.newsList.count; i++) {
            US_NewsBase * news=self.newsList[i];
            [contents addObject:news.title];
        }
        self.newsLabel.contentArray=contents;
    }

}



#pragma mark - <action>
- (void)tapGesAction:(UIGestureRecognizer *)recognizer{
    if (self.model.indexInfo&&self.model.indexInfo.count>0) {
        HomeBtnItem * item=self.model.indexInfo[0];
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
        if ([NSString isNullToString:item.log_title].length>0) {
            [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
        }
        [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];

    }
}

#pragma mark - <setter and getter>
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (USNewsView *)newsLabel{
    if (!_newsLabel) {
        _newsLabel=[[USNewsView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width-KScreenScale(110), KScreenScale(90))];
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction:)];
        [_newsLabel addGestureRecognizer:tapGes];
    }
    return _newsLabel;
}

@end
