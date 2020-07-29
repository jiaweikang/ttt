//
//  CommentStarView.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kViewMaxHeight 30

typedef enum : NSUInteger {
    StarButtonStateHightLight,
    StarButtonStateNoraml,
} StarButtonState;

@interface StarButton : UIButton

@property (nonatomic, assign) StarButtonState starStatus;

@end

@protocol CommentStarViewDelegate <NSObject>

@optional
- (void)didSetCommentStars:(NSString *)stars;

@end

@interface CommentStarView : UIView
@property (nonatomic, assign) BOOL isCanSetZeroStar; //是否可以打0个评分
@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, weak) id<CommentStarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString*)type;
- (void)setUpStar:(NSInteger)tag;

@end
