//
//  US_SegmentBarView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/1.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SegmentBarView.h"
#import <UIView+SDAutoLayout.h>
#import <NSString+Utility.h>

static const CGFloat SegentViewHeight =44;
static const CGFloat kBtnWidth=80;
static const CGFloat kMarginMid=10;

@interface US_SegmentBarView ()
@property (nonatomic, strong) NSMutableArray * itemsArray;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) NSMutableArray * buttonArray;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL autoSelectPage;
@end

@implementation US_SegmentBarView

- (instancetype)initWithItmes:(NSArray *)items obserScrollView:(UIScrollView *)scrollView{
    self= [self initWithItmes:items obserScrollView:scrollView currentPage:0];
    if (self) {
    }
    return self;
}

- (instancetype)initWithItmes:(NSArray *)items obserScrollView:(UIScrollView *)scrollView currentPage:(NSInteger) currentPage{
    self =[super initWithFrame:CGRectZero];
    if (self) {
        self.currentPage=currentPage;
        self.itemsArray=[items copy];
        self.obserScrollView=scrollView;
        [_obserScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self setUI];
    }
    return self;
}

- (void)dealloc{
    if (_obserScrollView) {
        [_obserScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)setUI{
    CGFloat buttonWidth=kBtnWidth;
    self.frame=CGRectMake(0, 0, buttonWidth+(buttonWidth+kMarginMid)*(self.itemsArray.count-1), SegentViewHeight);
    _buttonArray=[[NSMutableArray alloc] init];
    for (int i=0; i<self.itemsArray.count; i++) {
        UIButton * btn=[[UIButton alloc] initWithFrame:CGRectMake((buttonWidth+kMarginMid)*i, 3, buttonWidth, 40)];
        btn.tag=i;
        [btn setTitle:self.itemsArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_buttonArray addObject:btn];
        
    }
    [self addSubview:self.line];
    [self segmentSelectAtIndex:self.currentPage];
}

- (void)titleSelect:(UIButton *)btn{
    NSInteger tag=btn.tag;
    [self.obserScrollView setContentOffset:CGPointMake(tag*__MainScreen_Width, 0) animated:YES];
}

- (void)segmentSelectAtIndex:(NSInteger)index{
    if (index<self.buttonArray.count) {
        self.autoSelectPage=YES;
        UIButton * selectBtn=self.buttonArray[index];
        CGPoint point=self.line.center;
        self.line.center=CGPointMake(selectBtn.centerX, point.y);
        [self.obserScrollView setContentOffset:CGPointMake(index*__MainScreen_Width, 0) animated:NO];
        self.autoSelectPage=NO;
    }
    
}


#pragma mark - <UISrollView KVO>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat offsetX = newvalue.UIOffsetValue.horizontal;
        NSInteger leftIndex = offsetX / __MainScreen_Width;
        // 左边按钮
        UIButton *leftbtn = self.buttonArray[leftIndex];
        // 右边角标
        NSInteger rightIndex = leftIndex + 1;
        UIButton* rightbtn=nil;
        if (rightIndex<self.buttonArray.count) {
            rightbtn=self.buttonArray[rightIndex];
        }
        [self setUpUnderLineOffset:offsetX rightLabel:rightbtn leftLabel:leftbtn];
        _lastOffsetX=offsetX;
    }
}

#pragma mark -设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UIButton *)rightbtn leftLabel:(UIButton *)leftbtn{
    if (self.autoSelectPage) {
        //如果是默认选择到某页时，
        return;
    }
    // 获取两个标题中心点距离
    CGFloat centerDelta = (rightbtn.centerX) - (leftbtn.centerX);
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / __MainScreen_Width;
    // 宽度递增偏移量
    dispatch_async(dispatch_get_main_queue(), ^{
        self.line.centerX+=underLineTransformX;
    });
    
    

}

#pragma mark - <setter and getter>
- (UIView *)line{
    if (!_line) {
        _line=[[UIView alloc] initWithFrame:CGRectMake(0, SegentViewHeight-5, 40, 2)];
        _line.clipsToBounds=YES;
        _line.layer.cornerRadius=1;
        _line.backgroundColor=[UIColor whiteColor];
    }
    return _line;
}
@end
