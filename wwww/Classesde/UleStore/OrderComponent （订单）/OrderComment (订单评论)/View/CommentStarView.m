//
//  CommentStarView.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "CommentStarView.h"
#import <UIView+SDAutoLayout.h>

@implementation StarButton

- (void)setStarStatus:(StarButtonState )starStatus {
    if (starStatus==StarButtonStateHightLight) {
        [self setImage:[UIImage bundleImageNamed:@"comment_icon_star_h"]  forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage bundleImageNamed:@"comment_icon_star_n"]  forState:UIControlStateNormal];
    }
}

@end

@interface CommentStarView ()

@property (nonatomic, strong) NSMutableArray<StarButton *> *starsArray;
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) UILabel *commentTextLabel;
@property (nonatomic, strong) NSString *type;       //0是商品评价   1是服务态度和物流服务

@end

@implementation CommentStarView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type{
    self = [super initWithFrame:frame];
    if (self) {
        _starsArray = [[NSMutableArray alloc] init];
        _stars = 0;
        _titleStr = title;
        self.type = type;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, kViewMaxHeight)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = self.titleStr;
    [self addSubview:titleLabel];
    CGFloat x = 5+CGRectGetWidth(titleLabel.frame);
    CGFloat starWidth = kViewMaxHeight;
    for (int i=0; i<5; i++) {
        StarButton *starbtn = [[StarButton alloc] initWithFrame:CGRectMake(x+i*starWidth, 0, starWidth, kViewMaxHeight)];
        starbtn.tag = i+1;
        starbtn.starStatus = StarButtonStateHightLight;
        [starbtn addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:starbtn];
        [_starsArray addObject:starbtn];
        self.stars++;
        if ([self.type isEqualToString:@"0"]) {
            if (__MainScreen_Width == 320) {
                if (i==0) {
                    [self sd_addSubviews:@[self.commentTextLabel]];
                    _commentTextLabel.sd_layout
                    .leftEqualToView(starbtn)
                    .topSpaceToView(starbtn, 0)
                    .widthIs(100)
                    .heightIs(kViewMaxHeight);
                }
            }else{
                if (i==4) {
                    [self sd_addSubviews:@[self.commentTextLabel]];
                    _commentTextLabel.sd_layout
                    .leftSpaceToView(starbtn, 10)
                    .centerXEqualToView(titleLabel)
                    .widthIs(100)
                    .heightIs(kViewMaxHeight);
                }
            }
        }else{
            if (i==4) {
                [self sd_addSubviews:@[self.commentTextLabel]];
                _commentTextLabel.sd_layout
                .leftSpaceToView(starbtn, 10)
                .centerXEqualToView(titleLabel)
                .widthIs(100)
                .heightIs(kViewMaxHeight);
            }
        }
    }
}

- (void)starClick:(StarButton *)button {
    NSInteger tag = button.tag;
    [self setUpStar:tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSetCommentStars:)]) {
        [self.delegate didSetCommentStars:[NSString stringWithFormat:@"%@",@(self.stars)]];
    }
}

- (void)setUpStar:(NSInteger)tag {
    if (tag==0 && !self.isCanSetZeroStar) {
        return;
    }
    if (tag==self.stars) {
        return;
    }
    if (tag<self.stars || tag>self.stars) {
        for (int i=0; i<_starsArray.count; i++) {
            StarButton *star = _starsArray[i];
            if (star.tag<=tag) {
                star.starStatus = StarButtonStateHightLight;
            } else {
                star.starStatus = StarButtonStateNoraml;
            }
        }
        self.stars = tag;
    } else {
        StarButton *button = (StarButton *)[self viewWithTag:tag];
        button.starStatus = StarButtonStateNoraml;
        self.stars = self.stars-1;
    }
    switch (tag) {
        case 1:
        {
            self.commentTextLabel.text = @"非常差";
        }
            break;
        case 2:
        {
            self.commentTextLabel.text = @"差";
        }
            break;
        case 3:
        {
            self.commentTextLabel.text = @"一般吧";
        }
            break;
        case 4:
        {
            self.commentTextLabel.text = @"满意";
        }
            break;
        case 5:
        {
            self.commentTextLabel.text = @"非常满意";
        }
            break;
            
        default:
            break;
    }
}

- (UILabel*)commentTextLabel
{
    if (!_commentTextLabel) {
        _commentTextLabel = [[UILabel alloc]init];
        _commentTextLabel.font = [UIFont systemFontOfSize:15];
        _commentTextLabel.textAlignment = NSTextAlignmentLeft;
        _commentTextLabel.backgroundColor = [UIColor clearColor];
        _commentTextLabel.text = @"非常满意";
        
    }
    return _commentTextLabel;
}
@end
