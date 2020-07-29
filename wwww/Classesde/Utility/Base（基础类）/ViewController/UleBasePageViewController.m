//
//  UleBasePageViewController.m
//  视图控制器管理
//
//  Created by chenzhuqing on 2017/1/13.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleBasePageViewController.h"
#import "UIView+SDAutoLayout.h"

static NSString * const CELLID = @"CONTENTCELL";

@interface PageTitleLabel : UILabel

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) CGFloat g;
@property (nonatomic, assign) CGFloat b;

@end

@implementation PageTitleLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [_fillColor set];
    rect.size.width = rect.size.width * _progress;
    if (_fillColor) {
          UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end

@interface PageCoverView : UIView

@end

@implementation PageCoverView

- (void)drawRect:(CGRect)rect{
    [[UIColor clearColor]set];
    UIRectFill([self bounds]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGFloat width=5;
    CGFloat x=CGRectGetWidth(self.frame)/2.0;
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,0,rect.size.height-width);
    CGContextAddLineToPoint(context,x-width, rect.size.height-width);
    CGContextAddLineToPoint(context,x,CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, x+width,rect.size.height-width);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), rect.size.height-width);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 0);
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    [super drawRect:rect];
}

@end


// 设备屏幕宽
#define kScreenW [[UIScreen mainScreen] bounds].size.width
// 设备屏幕高
#define kScreenH  [[UIScreen mainScreen] bounds].size.height

#define kMinLabelWidth (64 * kScreenW / 320.0)
#define kTitleHeight  44
#define kCoverWidthMagin 10

@interface UleBasePageViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
//@property (nonatomic, strong) UIView * underline;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, strong) UIColor * normalColor;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIFont * normalTitleFont;
@property (nonatomic, strong) UIFont * selectedTitleFont;
@property (nonatomic, strong) NSString * normalLabelAlpha;
@property (nonatomic, strong) NSString * selectedLabelAlpha;
@property (nonatomic, assign) BOOL isClicekEvent;
@property (nonatomic, assign) BOOL isLoadTitles;
/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;
@property (nonatomic, strong) NSArray * normalColorRGB;
@property (nonatomic, strong) NSArray * selectColorRGB;

@end

@implementation UleBasePageViewController

- (instancetype) init{
    self = [super init];
    if (self) {
//        self.hasTabBar=NO;
        self.hasNaviBar=YES;
        self.titleLayoutType=PageVCTitleFixedWidth;
        self.titleMarin=5.0;
        self.offsetY=kIphoneX?88:64;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ignorePageLog=YES;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor=[UIColor whiteColor];
    self.normalColor=[UIColor blackColor];
    self.selectedColor=[UIColor redColor];
    self.normalTitleFont=[UIFont systemFontOfSize:KScreenScale(30)];
    self.selectedTitleFont=[UIFont systemFontOfSize:KScreenScale(30)];
    [self.view addSubview:self.pageCollectionView];
    [self.view addSubview:self.titleView];
    if (self.hasNaviBar) {
        [self.navigationController setNavigationBarHidden:YES];
        self.offsetY=kIphoneX?88:64;
    }else{
        [self.navigationController setNavigationBarHidden:YES];
        self.offsetY=0.0;
    }
    self.titleView.sd_layout.topSpaceToView(self.view, self.offsetY)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kTitleHeight);
    [self.titleView addSubview:self.mBackgroundImageView];
    self.mBackgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.titleView addSubview:self.titleScrollView];
//    self.titleView.alpha=0.0;
    self.titleScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
//    self.titleScrollView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
//    .leftSpaceToView(self.view, 0)
//    .rightSpaceToView(self.view, 0)
//    .heightIs(kTitleHeight);
    self.pageCollectionView.sd_layout.topSpaceToView(self.titleView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    self.separateLine=[[UIView alloc] initWithFrame:CGRectMake(0, kTitleHeight-0.4, kScreenW, 0.4)];
    self.separateLine.backgroundColor=[UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
    [self.titleView addSubview:self.separateLine];
    self.currentPageIndex=0;
    self.normalColorRGB=[self getRGBByColor:self.normalColor];
    self.selectColorRGB=[self getRGBByColor:self.selectedColor];
    [self.view layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat height=self.view.height_sd-self.titleView.height_sd-self.offsetY;
    _layout.itemSize=CGSizeMake(kScreenW, height);
    [self.pageCollectionView reloadData];
//    NSLog(@"viewWillAppear--  height==%@, ==%@",@(height),@(self.view.height_sd));
}

- (void)setUnLineColor:(UIColor *)color{
    self.underline.backgroundColor=color;
}

- (void)resetTabListVCAtCurrentPageIndex:(NSInteger)index{
    _isClicekEvent=YES;
    self.pageCollectionView.contentOffset=CGPointMake(0, 0);
    self.titleView.alpha=1.0;
    self.currentPageIndex=index;
    if (self.childViewControllers.count == 0) return;
    for (UIView * subView in self.titleScrollView.subviews) {
        [subView removeFromSuperview];
    }
    if (self.lablesArray) {
        [self.lablesArray removeAllObjects];
    }
    [self addTitles];
    self.pageCollectionView.contentSize= CGSizeMake(self.childViewControllers.count * kScreenW, 0);
    self.pageCollectionView.sd_layout.topSpaceToView(self.titleView, 0);
    [self.pageCollectionView updateLayout];
    [self.pageCollectionView reloadData];
    PageTitleLabel * label=self.lablesArray[self.currentPageIndex];
    [self titleSelected:[label.gestureRecognizers firstObject]];
    _isClicekEvent=NO;
}

- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor andFont:(UIFont *)font{
    self.normalColor=normalColor;
    self.selectedColor=selectedColor;
    self.normalTitleFont=font;
    self.selectedTitleFont=font;
    self.normalColorRGB=[self getRGBByColor:self.normalColor];
    self.selectColorRGB=[self getRGBByColor:self.selectedColor];
}

- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont{
    [self setTitleNormalColor:normalColor selectedColor:selectedColor andFont:normalFont];
    self.selectedTitleFont=selectedFont;
}

- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor andFont:(UIFont *)font andNormalALpha:(NSString *)normalAlpha andSelectedAlpha:(NSString *)selectedAlpha{
    [self setTitleNormalColor:normalColor selectedColor:selectedColor andFont:font];
    self.normalLabelAlpha=normalAlpha;
    self.selectedLabelAlpha=selectedAlpha;
}

- (void)addTitles{
    CGFloat fixedWidth=(kScreenW-self.titleMarin*(self.childViewControllers.count+1))/self.childViewControllers.count;
    if (fixedWidth<kMinLabelWidth) {
        fixedWidth=kMinLabelWidth;
    }
    __block CGFloat x=self.titleMarin;
    [self.titleScrollView addSubview:self.coverView];
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController * viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect=[self caclulateRectOfString:viewController.title withFont:self.normalTitleFont];
        CGFloat labelw=self.titleLayoutType == PageVCTitleFixedWidth?fixedWidth:rect.size.width;
        PageTitleLabel * label=[[PageTitleLabel alloc] initWithFrame:CGRectMake(x, 0, labelw, self.titleScrollView.frame.size.height)];
        label.font=self.normalTitleFont;
        label.textAlignment=NSTextAlignmentCenter;
        label.text=viewController.title;
        x=label.right_sd+self.titleMarin;
        CGFloat cenetx=label.centerX;
        label.width=rect.size.width;
        label.centerX=cenetx;
        label.tag=idx;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleSelected:)];
        label.userInteractionEnabled=YES;
        [label addGestureRecognizer:tap];
        [self.titleScrollView addSubview:label];
        [self.lablesArray addObject:label];
        
    }];
    CGFloat contentWith= x<kScreenW?kScreenW:x;
    self.titleScrollView.contentSize=CGSizeMake(contentWith, self.titleScrollView.frame.size.height);
    PageTitleLabel * label=self.lablesArray[self.currentPageIndex];
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.normalTitleFont} context:nil];

    
    if (self.titleType==PageVCTitleTypeCover) {
            self.coverView.frame=CGRectMake(0, 0, label.size.width+kCoverWidthMagin, titleBounds.size.height+kCoverWidthMagin);
            self.coverView.centerX=label.centerX;
            self.coverView.centerY=label.centerY+2;
    }else{
        if (self.customUnderLine) {
            self.customUnderLine.centerX=label.centerX;
            self.customUnderLine.top=self.titleScrollView.height-CGRectGetHeight(self.customUnderLine.frame);
            [self.titleScrollView addSubview:self.customUnderLine];
        }
            self.underline.frame=CGRectMake(0, 0, label.size.width, 2);
            self.underline.centerX=label.centerX;
            self.underline.top=self.titleScrollView.height-2;
            self.underline.hidden=self.hiddenUnderLine;
            [self.titleScrollView addSubview:self.underline];
//        }
    }
}

- (void)titleSelected:(UIGestureRecognizer *)reconizer{
    _isClicekEvent=YES;
    // 获取对应标题label
    PageTitleLabel *label = (PageTitleLabel *)reconizer.view;
    // 获取当前角标
    NSInteger i = label.tag;
    self.currentPageIndex=i;
    // 选中label
    [self titleClickEventAtIndex:self.currentPageIndex];
    [self didSelectTitleLabel:label];
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * kScreenW;
  
    NSIndexPath * indexPath=[NSIndexPath indexPathForItem:i inSection:0];

    [self.pageCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
     UIViewController *vc = self.childViewControllers[i];
    if (vc.view) {
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:PageViewClickOrScrollDidFinshNote  object:vc];
        
        // 发出重复点击标题通知
        if (_selIndex == i) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PageViewRepeatClickTitleNote object:vc];
        }
    }
    _selIndex=i;
    _lastOffsetX=offsetX;

   
}
- (void)titleClickEventAtIndex:(NSInteger)index{
    
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_isClicekEvent) {
        return;
    }
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 获取左边角标
    NSInteger leftIndex = offsetX / kScreenW;
//    NSLog(@"第%ld个",leftIndex);
    // 左边按钮
    PageTitleLabel *leftLabel = self.lablesArray[leftIndex];
    
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    PageTitleLabel* rightLabel=nil;
    if (rightIndex<self.lablesArray.count) {
       rightLabel=self.lablesArray[rightIndex];
    }

    if (self.titleType==PageVCTitleTypeCover) {
        [self setCoverViewOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
        [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }else{
        
        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    _lastOffsetX=offsetX;

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollVie{
      _isClicekEvent=NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    // 获取角标
    NSInteger i = offsetX / kScreenW;
    self.currentPageIndex=i;
    PageTitleLabel *lable=self.lablesArray[i];
    [self didSelectTitleLabel:lable];
   _isClicekEvent=NO;
    
    // 取出对应控制器发出通知
    UIViewController *vc = self.childViewControllers[i];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:PageViewClickOrScrollDidFinshNote object:vc];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
      CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX<-70) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(PageTitleLabel *)rightLabel leftLabel:(PageTitleLabel *)leftLabel{
    if (_isClicekEvent) {
        return;
    }
    CGRect titleBoundsR=rightLabel!=nil?[self caclulateRectOfString:rightLabel.text withFont:rightLabel.font]:CGRectZero;
    CGRect titleBoundsL=[self caclulateRectOfString:leftLabel.text withFont:leftLabel.font];
    // 标题宽度差值
    CGFloat widthDelta = titleBoundsR.size.width-titleBoundsL.size.width;
    // 获取两个标题中心点距离
    CGFloat centerDelta = (rightLabel.centerX-titleBoundsR.size.width/2.0) - (leftLabel.centerX-titleBoundsL.size.width/2.0);
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
 
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / kScreenW;
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / kScreenW;
    CGFloat scale=offsetDelta *(0.1)/kScreenW;
    
    CGFloat selectRed=[self.selectColorRGB[0] floatValue];
    CGFloat selectGreen=[self.selectColorRGB[1] floatValue];
    CGFloat selectBlue=[self.selectColorRGB[2] floatValue];
    CGFloat normalRed=[self.normalColorRGB[0] floatValue];
    CGFloat normalGreen=[self.normalColorRGB[1] floatValue];
    CGFloat normalBlue=[self.normalColorRGB[2] floatValue];
   
    CGFloat redScale=offsetDelta*(selectRed-normalRed)/kScreenW;
    CGFloat greenScale=offsetDelta*(selectGreen-normalGreen)/kScreenW;
    CGFloat blueScale=offsetDelta*(selectBlue-normalBlue)/kScreenW;
    self.underline.width += underLineWidth;
    self.underline.centerX+=underLineTransformX;
    if (self.customUnderLine) {
        // 获取两个标题中心点距离
        CGFloat customCenterDelta = rightLabel.centerX - leftLabel.centerX;
        // 宽度递增偏移量
        // 计算当前下划线偏移量
        CGFloat customUnderLineTransformX = offsetDelta * customCenterDelta / kScreenW;
        self.customUnderLine.centerX+=customUnderLineTransformX;
    }
    leftLabel.scale-=scale;
    rightLabel.scale+=scale;

    leftLabel.r-=redScale;
    leftLabel.g-=greenScale;
    leftLabel.b-=blueScale;
    
    rightLabel.r+=redScale;
    rightLabel.g+=greenScale;
    rightLabel.b+=blueScale;
    
    //放大缩小
    leftLabel.transform= CGAffineTransformScale(CGAffineTransformIdentity, leftLabel.scale, leftLabel.scale);
    rightLabel.transform= CGAffineTransformScale(CGAffineTransformIdentity, rightLabel.scale, rightLabel.scale);
    //渐变颜色
    leftLabel.textColor=[UIColor colorWithRed:leftLabel.r green:leftLabel.g blue:leftLabel.b alpha:1];
    rightLabel.textColor=[UIColor colorWithRed:rightLabel.r green:rightLabel.g blue:rightLabel.b alpha:1];
}
#pragma mark -设置遮罩偏移
- (void)setCoverViewOffset:(CGFloat)offsetX rightLabel:(PageTitleLabel *)rightLabel leftLabel:(PageTitleLabel *)leftLabel{
    if (_isClicekEvent) {
        return;
    }
    CGRect titleBoundsR=rightLabel!=nil?[self caclulateRectOfString:rightLabel.text withFont:rightLabel.font]:CGRectZero;
    CGRect titleBoundsL=[self caclulateRectOfString:leftLabel.text withFont:leftLabel.font];
    // 标题宽度差值
    CGFloat widthDelta = titleBoundsR.size.width-titleBoundsL.size.width;
    // 获取两个标题中心点距离
    CGFloat centerDelta = (rightLabel.centerX-titleBoundsR.size.width/2.0) - (leftLabel.centerX-titleBoundsL.size.width/2.0);
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / kScreenW;
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / kScreenW;
   
    self.coverView.width+=underLineWidth;
    self.coverView.centerX+=underLineTransformX;
    [self.coverView setNeedsDisplay];
}

#pragma mark -设置标题颜色渐变
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(PageTitleLabel *)rightLabel leftLabel:(PageTitleLabel *)leftLabel{
    if (_isClicekEvent) {
        return;
    }
    CGFloat x= self.coverView.left+self.coverView.width;
    CGFloat scareR=x-rightLabel.left>0?(x-rightLabel.left)/rightLabel.width:0;
    CGFloat scarL=(self.coverView.left-leftLabel.left)/leftLabel.width;
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    if (offsetDelta > 0) { // 往右边
//        NSLog(@"往右边");
        rightLabel.textColor=self.normalColor;
        rightLabel.fillColor = self.selectedColor;
        rightLabel.progress = scareR;
        
        leftLabel.textColor=self.selectedColor;
        leftLabel.fillColor = self.normalColor;
        leftLabel.progress = scarL;
    } else if(offsetDelta < 0){ // 往左边
//        NSLog(@"往左边");
        rightLabel.textColor=self.normalColor;
        rightLabel.fillColor = self.selectedColor;
        rightLabel.progress = scareR;
        
        leftLabel.textColor=self.selectedColor;
        leftLabel.fillColor =  self.normalColor;
        leftLabel.progress = scarL;
    }
}

#pragma mark- 选择标题
- (void)didSelectTitleLabel:(PageTitleLabel *)label{
    
    [self.lablesArray enumerateObjectsUsingBlock:^(PageTitleLabel * label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.textColor=self.normalColor;
        if (self.titleType==PageVCTitleTypeCover) {
            label.fillColor = self.normalColor;
            label.progress = 1;
        }
        if (self.normalLabelAlpha.length>0) {
            label.alpha=self.normalLabelAlpha.floatValue;
        }
        label.scale=1.0;
        label.r=[self.normalColorRGB[0] floatValue];
        label.g=[self.normalColorRGB[1] floatValue];
        label.b=[self.normalColorRGB[2] floatValue];
        label.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
    if (self.selectedLabelAlpha.length>0) {
        label.alpha=self.selectedLabelAlpha.floatValue;
    }
    label.scale=1.1;
    label.r=[self.selectColorRGB[0] floatValue];
    label.g=[self.selectColorRGB[1] floatValue];
    label.b=[self.selectColorRGB[2] floatValue];
    label.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [self setLabelTitleCenter:label];
    [self setUpUnderLine:label];
    [self setUpCoverView:label];
}

- (void)pageSelect:(NSInteger)pageIndex{
    if (pageIndex>=0&&pageIndex < self.lablesArray.count) {
        PageTitleLabel * label=self.lablesArray[pageIndex];
        [self titleSelected:[label.gestureRecognizers firstObject]];
    }
}

#pragma mark - 标题居住
- (void)setLabelTitleCenter:(PageTitleLabel *)label
{
    
    CGFloat minOffset=label.center.x-self.titleScrollView.width_sd/2.0;
    if (minOffset<0) {
        minOffset=0;
    }
    CGFloat maxOffset=self.titleScrollView.contentSize.width-self.titleScrollView.width_sd;
    if (minOffset>maxOffset) {
        minOffset=maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(minOffset, 0) animated:YES];
    
}

#pragma mark -设置下标的位置
- (void)setUpUnderLine:(PageTitleLabel *)label
{
    [UIView animateWithDuration:0.25 animations:^{
        if (self.customUnderLine) {
            self.customUnderLine.centerX=label.centerX;
        }
//        self.underline.width = label.width;
        self.underline.width = KScreenScale(48);
        self.underline.height = KScreenScale(6);
        self.underline.top=self.titleScrollView.height-KScreenScale(6);
        self.underline.centerX = label.centerX;
        label.textColor=self.selectedColor;
        if (self.titleType==PageVCTitleTypeCover) {
            label.fillColor = self.selectedColor;
        }
    }];
}
#pragma mark -设置遮罩的位置
- (void)setUpCoverView:(PageTitleLabel *)label{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = label.width+kCoverWidthMagin;
        self.coverView.centerX = label.centerX;
        label.textColor=self.selectedColor;
        label.fillColor = self.selectedColor;
        [self.coverView setNeedsDisplay];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    [cell.contentView addSubview:vc.view];
    vc.view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    vc.view.frame = CGRectMake(0, 0, self.layout.itemSize.width, cell.contentView.frame.size.height);
    return cell;
}

- (CGRect)caclulateRectOfString:(NSString *)string withFont:(UIFont *)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

- (void)scrollViewToHiddenNavigationBar:(BOOL)isHidden{
//    CGFloat height=kScreenH-kTitleHeight;
//    if (self.hasTabBar&&self.navigationController.viewControllers.count<=1) {
//        height=height-kTabBarHeight;
//    }
//    if (self.hasNaviBar) {
//        height=height-self.uleCustemNavigationBar.height;
//    }
//    height=isHidden?(kScreenH-kTitleHeight-20):height;
    CGFloat height=self.view.height_sd-self.titleView.height_sd-self.offsetY;
    height=isHidden?(self.view.height_sd-self.titleView.height_sd-20):height;
    self.layout.itemSize=CGSizeMake(kScreenW, height);
    self.pageCollectionView.height_sd=height;
}

- (void)setHiddenUnderLine:(BOOL)hiddenUnderLine{
    _hiddenUnderLine=hiddenUnderLine;
    self.underline.hidden=hiddenUnderLine;
}

- (NSArray *)getRGBByColor:(UIColor *)originColor{
    CGFloat r=0,g=0,b=0,a=0;
    [originColor getRed:&r green:&g blue:&b alpha:&a];
    return @[@(r),@(g),@(b)];
}
#pragma mark - setter and getter
- (UICollectionView *)pageCollectionView{
    if (!_pageCollectionView) {
        _pageCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.delegate = self;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.scrollsToTop = NO;
        if (@available(iOS 10.0, *)) {
            _pageCollectionView.prefetchingEnabled=NO;
        }
        [_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELLID];
        _pageCollectionView.backgroundColor=[UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _pageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _pageCollectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout=[[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        CGFloat height=self.view.height_sd-self.titleView.height_sd-self.offsetY;
//        CGFloat height=kScreenH-kTitleHeight;
//        if (self.hasTabBar&&self.navigationController.viewControllers.count<=1) {
//            height=height-kTabBarHeight;
//        }
//        if (self.hasNaviBar) {
//            height=height-self.uleCustemNavigationBar.height;
//        }
        _layout.itemSize=CGSizeMake(kScreenW, height);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTitleHeight)];
        _titleView.backgroundColor=[UIColor whiteColor];
    }
    return _titleView;
}
- (YYAnimatedImageView *)mBackgroundImageView{
    if (!_mBackgroundImageView) {
        _mBackgroundImageView=[[YYAnimatedImageView alloc]init];
    }
    return _mBackgroundImageView;
}
- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTitleHeight)];
        _titleScrollView.backgroundColor=[UIColor clearColor];
        _titleScrollView.showsHorizontalScrollIndicator=NO;
    }
    return _titleScrollView;
}

- (NSMutableArray *)lablesArray{
    if (!_lablesArray) {
        _lablesArray=[[NSMutableArray alloc] init];
    }
    return _lablesArray;
}

- (UIView *)underline{
    if (!_underline) {
        _underline=[[UIView alloc] init];
        _underline.backgroundColor=[UIColor redColor];
        _underline.layer.cornerRadius = KScreenScale(3);
    }
    return _underline;
}

- (UIView *)coverView{
    if (!_coverView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(titleCustemCoverView)]) {
            _coverView=[self.delegate titleCustemCoverView];
        }else{
            _coverView=[[PageCoverView alloc] initWithFrame:CGRectZero];
            _coverView.backgroundColor=[UIColor clearColor];
        }
    }
    return _coverView;
}
@end
