//
//  UlePhotoBrowserCustemNavigationBar.m
//  UleApp
//
//  Created by zemengli on 2018/10/18.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UlePhotoBrowserBottomBar.h"
#import <UIView+SDAutoLayout.h>
#import "ShopStarView.h"
#import "ProductCommentCellModel.h"
#import <NSObject+YYModel.h>

#define kMaginOffset 10
//#define kStatusBarHeight   CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define kViewHeight ((kStatusBarHeight) > (20) ? (124) : (90))

@interface UlePhotoBrowserBottomBar()

@property (nonatomic,strong) UIScrollView * backScrollView;
@property (nonatomic, strong) UIImageView * headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * dateAndAttributeLabel;
@property (nonatomic, strong) ShopStarView * starView;
@end

@implementation UlePhotoBrowserBottomBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.sd_layout.heightIs(kViewHeight);
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.backScrollView];
    [self.backScrollView sd_addSubviews:@[self.headImageView,self.nameLabel, self.contentLabel,self.starView,self.dateAndAttributeLabel]];
    self.headImageView.sd_layout
    .topSpaceToView(self.backScrollView,kMaginOffset)
    .leftSpaceToView(self.backScrollView,kMaginOffset)
    .widthIs(27)
    .heightIs(27);
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.headImageView)
    .leftSpaceToView(self.headImageView,5)
    .widthIs(120)
    .heightIs(20);
    
    self.starView.sd_layout
    .rightSpaceToView(self.backScrollView,15)
    .centerYEqualToView(self.headImageView)
    .widthIs(14*5)
    .heightIs(14);
    
    self.dateAndAttributeLabel.sd_layout
    .topSpaceToView(self.headImageView,5)
    .leftEqualToView(self.headImageView)
    .heightIs(20)
    .rightSpaceToView(self.backScrollView, 15);
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.dateAndAttributeLabel,2)
    .leftEqualToView(self.headImageView)
    .rightSpaceToView(self.backScrollView,kMaginOffset)
    .minHeightIs(35)
    .autoHeightRatio(0);
    
    self.contentLabel.sd_layout.maxHeightIs(90);
    self.headImageView.sd_cornerRadiusFromHeightRatio = @(0.5);
}

//set 方法
-(void)setCommentDic:(NSDictionary *)commentDic{
    if (commentDic==nil) {
        return;
    }
    ProductCommentCellModel * model=[ProductCommentCellModel yy_modelWithJSON:commentDic];
    _commentDic=commentDic;
    self.nameLabel.text=[self mosaicString:model.userName];
    self.contentLabel.text=model.content;
    self.dateAndAttributeLabel.text=[NSString stringWithFormat:@"%@  %@",model.submitDate,model.productAttribute];
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholder:[UIImage bundleImageNamed:@"commentHead"]];
    [self.starView showStars:[model.productQuality floatValue]];

    [self layoutIfNeeded];
    
    [self.backScrollView setContentSize:CGSizeMake(__MainScreen_Width, kMaginOffset+self.headImageView.height+5+self.dateAndAttributeLabel.height+2+self.contentLabel.height+5)];

}

- (NSString *) mosaicString:(NSString *) string{
    if (string.length>3) {
        
        NSString * firstStr=[string substringToIndex:1];
        NSString * secdStr=@"**";
        NSString * lastStr=[string substringFromIndex:string.length-1];
        NSString * moasicString=[NSString stringWithFormat:@"%@%@%@",firstStr,secdStr,lastStr];
        return moasicString;
    }else{
        return string;
    }
}

#pragma mark - setter and getter

- (UIImageView *)headImageView{
    if (_headImageView==nil) {
        _headImageView=[[UIImageView alloc] init];
        _headImageView.backgroundColor=[UIColor whiteColor];
        
    }
    return _headImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel==nil) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.font=[UIFont systemFontOfSize:12.0f];
        _nameLabel.textColor=[UIColor whiteColor];
        _nameLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel{
    if (_contentLabel==nil) {
        _contentLabel=[[UILabel alloc] init];
        _contentLabel.font=[UIFont systemFontOfSize:12.0f];
        _contentLabel.textColor=[UIColor whiteColor];
    }
    return _contentLabel;
}

- (UILabel *)dateAndAttributeLabel{
    if(_dateAndAttributeLabel==nil){
        _dateAndAttributeLabel=[[UILabel alloc] init];
        _dateAndAttributeLabel.font=[UIFont systemFontOfSize:12.0f];
        _dateAndAttributeLabel.textColor=[UIColor whiteColor];
        _dateAndAttributeLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _dateAndAttributeLabel;
}

- (ShopStarView *)starView{
    if (_starView==nil) {
        _starView=[[ShopStarView alloc] initWithStarHeight:14 StarNumber:5];
    }
    return _starView;
}

- (UIScrollView *)backScrollView{
    if (_backScrollView==nil) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, self.frame.size.height)];
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
    }
    return _backScrollView;
}

@end
