//
//  ShopStarView.m
//  AbstactClass
//
//  Created by chenzhuqing on 16/7/14.
//  Copyright © 2016年 ule. All rights reserved.
//

#import "ShopStarView.h"
#import "CommentStarView.h"

#define kStandWith 18.0


@interface Stars : UIView

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGFloat startHeight;
@property (nonatomic, assign) NSInteger stars;

- (instancetype) initWithStarHeight:(CGFloat)height withColor:(UIColor *) color andNumberStar:(NSInteger) num;
@end

@implementation Stars

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype) initWithStarHeight:(CGFloat)height withColor:(UIColor *) color andNumberStar:(NSInteger) num{
    self= [super initWithFrame:CGRectMake(0, 0, height*num, height)];
    if (self) {
        _color=color;
        self.stars=num;
        self.startHeight=height;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

    float x=self.startHeight;
    float scale=self.startHeight/kStandWith;
    for (int i=0; i<self.stars; i++) {
        
        UIBezierPath* star5Path = [UIBezierPath bezierPath];
        [star5Path moveToPoint: CGPointMake(9*scale+x*i, 0.5*scale)];
        [star5Path addLineToPoint: CGPointMake(10.9*scale+x*i, 7.08*scale)];
        [star5Path addLineToPoint: CGPointMake(17.08*scale+x*i, 7.06*scale)];
        [star5Path addLineToPoint: CGPointMake(12.07*scale+x*i, 11.12*scale)];
        [star5Path addLineToPoint: CGPointMake(14*scale+x*i, 17.69*scale)];
        [star5Path addLineToPoint: CGPointMake(9*scale+x*i, 13.61*scale)];
        [star5Path addLineToPoint: CGPointMake(4*scale+x*i, 17.69*scale)];
        [star5Path addLineToPoint: CGPointMake(5.93*scale+x*i, 11.12*scale)];
        [star5Path addLineToPoint: CGPointMake(0.92*scale+x*i, 7.06*scale)];
        [star5Path addLineToPoint: CGPointMake(7.1*scale+x*i, 7.08*scale)];
        [star5Path closePath];
        [_color setFill];
        [star5Path fill];
        
    }
}

@end




@interface ShopStarView ()

@property (nonatomic, strong) UIView * imageMaskView;
@property (nonatomic, assign) NSInteger starsNumber;
@property (nonatomic, assign) CGFloat starHeight;

@end

@implementation ShopStarView
- (instancetype) init{
    self= [super init];
    [self setupView];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
    if (_starsNumber==0) {
        _starsNumber=5;
    }
    _starHeight=frame.size.height;
    self = [super initWithFrame:frame];
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self= [super initWithCoder: aDecoder];
    [self setupView];
    return  self;
}

- (instancetype) initWithStarHeight:(CGFloat) height StarNumber:(NSInteger)num{
    _starsNumber=num;
    _starHeight=height;
    self = [super initWithFrame:CGRectMake(0, 0, _starHeight*num, _starHeight)];
    [self setupView];
    
    self.backgroundColor=[UIColor clearColor];
    return self;
    
}

- (instancetype) initWithStarHeight:(CGFloat) height StarNumber:(NSInteger)num StarColor:(NSString *)starColor StarDefaultColor:(NSString *)detaultColor{
    _starsNumber=num;
    _starHeight=height;
    self = [super initWithFrame:CGRectMake(0, 0, _starHeight*num, _starHeight)];
    [self setupViewWithStarColor:starColor StarDefaultColor:detaultColor];
    self.backgroundColor=[UIColor clearColor];
    return self;
}

- (void) setupViewWithStarColor:(NSString *)starColor StarDefaultColor:(NSString *)starDefaultColor{
        Stars * yellow=[[Stars alloc] initWithStarHeight:_starHeight withColor:[UIColor convertHexToRGB:starColor] andNumberStar:_starsNumber];
        Stars * gray=[[Stars alloc] initWithStarHeight:_starHeight withColor:[UIColor convertHexToRGB:starDefaultColor] andNumberStar:_starsNumber];
    [self addSubview:gray];
    [self.imageMaskView addSubview:yellow];
    [self addSubview:self.imageMaskView];
    
    
}

- (void) setupView{
    /*
    Stars * red=[[Stars alloc] initWithStarHeight:_starHeight withColor:[UIColor redColor] andNumberStar:_starsNumber];
    Stars * gray=[[Stars alloc] initWithStarHeight:_starHeight withColor:[UIColor grayColor] andNumberStar:_starsNumber];
    [self addSubview:gray];
    [self.imageMaskView addSubview:red];;
    [self addSubview:self.imageMaskView];
    */
    //先删除所有子视图
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat starWidth=self.starHeight;
    //先添加5个灰色的星
    for (int i=0; i<_starsNumber; i++) {
        StarButton * starbtn=[[StarButton alloc] initWithFrame:CGRectMake(i*starWidth, 0, starWidth, starWidth)];
        starbtn.starStatus=StarButtonStateNoraml;
        [self addSubview:starbtn];
    }
//    再加上蒙层
[self addSubview:self.imageMaskView];
    //再加上5个红色的星
    for (int i=0; i<_starsNumber; i++) {
        StarButton * starbtn=[[StarButton alloc] initWithFrame:CGRectMake(i*starWidth, 0, starWidth, starWidth)];
        starbtn.starStatus=StarButtonStateHightLight;
        [self.imageMaskView addSubview:starbtn];
    }

    
}

- (void) showStars:(CGFloat) stars{
    CGFloat maskWidth = (_starsNumber*_starHeight)*(stars/_starsNumber);
    self.imageMaskView.frame=CGRectMake(0, 0, maskWidth, self.frame.size.height);
}

- (UIView *)imageMaskView{
    if (_imageMaskView==nil) {
        _imageMaskView=[[UIView alloc] initWithFrame:self.bounds];
        _imageMaskView.backgroundColor=[UIColor clearColor];
        _imageMaskView.clipsToBounds=YES;
    }
    return _imageMaskView;
}

@end
