//
//  UleTabBarViewController.m
//  UleApp
//
//  Created by chenzhuqing on 16/4/19.
//  Copyright © 2016年 ule. All rights reserved.
//

#import "UleTabBarViewController.h"
#import <JSBadgeView/JSBadgeView.h>
#import <YYWebImage/YYWebImage.h>
#define WindowWith  [UIScreen mainScreen].bounds.size.width

static CGFloat const kTabIconWidthAndHeight = 25.0;
static CGFloat const kTabTitleFontSize = 10.0;
static CGFloat const kRedDotWidthAndHeight = 8.0;

@implementation UleCustemTabBarItem

- (instancetype) initWithTitle:(NSString *) title normalImage:(NSString *)imageUrl selectImage:(NSString *)selectImageUrl normalColor:(UIColor *)nomalColor selectColor:(UIColor *)selectColor{
    self = [super init];
    if (self) {
        self.title=title;
        self.normalImageUrl=imageUrl;
        self.selectImageUrl=selectImageUrl;
        self.normalTextColor=nomalColor;
        self.selectTextColor=selectColor;
    }
    return self;
}

- (instancetype) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage normalColor:(UIColor *)nomalColor selectColor:(UIColor *)selectColor{
    self = [super init];
    if (self) {
        self.title=title;
        self.normalImage=image;
        self.selectImage=selectedImage;
        self.normalTextColor=nomalColor;
        self.selectTextColor=selectColor;
    }
    return self;
}

@end

@interface SubItemView : UIView

@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * textlabel;
@property (nonatomic, strong) JSBadgeView * jsBadegeView;
@property (nonatomic, strong) UIImageView * redDot;

- (void) reloadViewWithItem:(UleCustemTabBarItem *)item andSelected:(BOOL) isSelected;
@end

@implementation SubItemView

- (instancetype) initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        [self loadSubViews];
    }
    return self;
}

- (void) loadSubViews{
    [self addSubview:self.iconView];
    [self addSubview:self.textlabel];
}

- (void) reloadViewWithItem:(UleCustemTabBarItem *)item andSelected:(BOOL) isSelected{
    if (!isSelected) {
        if (item.normalImageUrl.length>0) {
            [self.iconView yy_setImageWithURL:[NSURL URLWithString:item.normalImageUrl] placeholder:item.normalImage];
        }else{
            self.iconView.image=item.normalImage;
        }
        self.textlabel.text=item.title;
        self.textlabel.textColor=item.normalTextColor;
    }else{
        if (item.selectImageUrl.length>0) {
            [self.iconView yy_setImageWithURL:[NSURL URLWithString:item.selectImageUrl] placeholder:item.selectImage];
        }else{
            self.iconView.image=item.selectImage;
        }
        self.textlabel.text=item.title;
        self.textlabel.textColor=item.selectTextColor;
    }
}

- (UIImageView *) iconView{
    if (_iconView==nil) {
        CGFloat imageW = kTabIconWidthAndHeight;
        CGFloat imageH = kTabIconWidthAndHeight;
        CGFloat imageX = (self.bounds.size.width - imageW) * 0.5;
        CGFloat imageY = 5;//(self.bounds.size.height - imageH) * 1/3;
        _iconView=[[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        _iconView.contentMode=UIViewContentModeScaleAspectFit;
        _iconView.tintColor=[UIColor clearColor];
        _jsBadegeView= [[JSBadgeView alloc] initWithParentView:_iconView alignment:JSBadgeViewAlignmentTopRight];
        _jsBadegeView.badgeTextFont=[UIFont systemFontOfSize:12.0f];
        [_iconView addSubview:self.redDot];
    }
    return _iconView;
}

- (UILabel *) textlabel{
    if (_textlabel==nil) {
        CGFloat textX=0;
        CGFloat textY=CGRectGetMaxY(self.iconView.frame)+4;
        CGFloat textW=self.bounds.size.width;
        CGFloat textH=self.bounds.size.height-textY-5;
        _textlabel=[[UILabel alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
        _textlabel.textColor=[UIColor grayColor];
        _textlabel.font=[UIFont systemFontOfSize:kTabTitleFontSize];
        _textlabel.textAlignment=NSTextAlignmentCenter;

    }
    return _textlabel;
}

- (UIImageView *) redDot{
    if (_redDot==nil) {
        _redDot=[[UIImageView alloc] initWithFrame:CGRectMake(kTabIconWidthAndHeight-5, -4, kRedDotWidthAndHeight, kRedDotWidthAndHeight)];
        _redDot.layer.cornerRadius=kRedDotWidthAndHeight/2.0f;
        _redDot.backgroundColor=[UIColor clearColor];
        _redDot.clipsToBounds=YES;
        [_redDot setImage:[UIImage bundleImageNamed:@"redPoint.png"]];
        _redDot.hidden=YES;
    }
    return _redDot;
}

@end


@interface UleTabBarViewController ()

@property (nonatomic, strong) NSMutableArray * tabContainers;
@property (nonatomic, strong) NSMutableArray * normalImages;
@property (nonatomic, strong) NSMutableArray * selectImages;
@property (nonatomic, assign) BOOL hadLoadItems;
@end

@implementation UleTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutTabBarItems];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews{
    for (UIView *tabBar in self.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
}

- (void) layoutTabBarItems{
    if (self.hadLoadItems==NO) {
        if (self.tabContainers.count>0) {
            for (SubItemView * itemView in self.tabContainers) {
                [itemView removeFromSuperview];
            }
            [self.tabContainers removeAllObjects];
        }
        if (_tabBarImageView==nil) {
            _tabBarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tabBar.frame), 49+(kIphoneX?34:0))];
        }else{
            [self.tabBarImageView removeFromSuperview];
        }
        [self.tabBar addSubview:self.tabBarImageView];
        if (self.tabItems.count>0) {
            for (int i=0; i<self.tabItems.count; i++) {
                [self creatItemView:i];
            }
            self.hadLoadItems=YES;
        }

    }
}

- (void) resetTabChildControllers:(NSArray *)childControllers andTabItems:(NSArray<UleCustemTabBarItem *> *)items{
    for (UIViewController * vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (UIViewController * vc in childControllers) {
        [self addChildViewController:vc];
    }
    for (UIView *tabBar in self.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
    _tabItems=items;
    [self setValue:@NO forKeyPath:@"hadLoadItems"];
    [self layoutTabBarItems];
}


- (void) creatItemView:(NSInteger) index{
    UleCustemTabBarItem * obj=self.tabItems[index];
    CGFloat itemViewW=WindowWith/self.tabItems.count;
    CGFloat itemViewH=49;//CGRectGetHeight(self.tabBar.frame);
    CGFloat itemViewX=itemViewW* index;
    SubItemView * subItem=[[SubItemView alloc] initWithFrame:CGRectMake(itemViewX, 0, itemViewW, itemViewH)];
    subItem.tag=index;
    subItem.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick:)];
    [subItem addGestureRecognizer:tap];
    [self.tabBar addSubview:subItem];
    [subItem reloadViewWithItem:obj andSelected:NO];
    [self.tabContainers addObject:subItem];
    if (index==0) {
        [self selectTabBarItemAtIndex:0 animated:NO];
    }
}



- (void)selectClick:(UIGestureRecognizer *)recognizer{
    SubItemView * subItem =(SubItemView*)recognizer.view;
    [self selectTabBarItemAtIndex:subItem.tag animated:YES];
}

- (void) selectTabBarItemAtIndex:(NSInteger) index animated:(BOOL)animated {
    [LogStatisticsManager shareInstance].srcid=@"";
    UleCustemTabBarItem * normalitem=[self.tabItems objectAt:self.selectedIndex];
    SubItemView * subItem=[self.tabContainers objectAt:self.selectedIndex];
    [subItem reloadViewWithItem:normalitem andSelected:NO];
    self.selectedIndex = index;
    UleCustemTabBarItem * selectitem=[self.tabItems objectAt:self.selectedIndex];
    SubItemView * subItem1=[self.tabContainers objectAt:index];
    [subItem1 reloadViewWithItem:selectitem andSelected:YES];
    if (animated) {
        [self playAnimationOnView:subItem1.iconView];
    }
    //日志记录
    if ([self respondsToSelector:@selector(saveTabViewClickLogAtIndex:)]) {
        [self saveTabViewClickLogAtIndex:index];
    }
}


- (void) updateBadgeViewWithText:(NSString *) textString AtIndex:(NSInteger) index{
    
    if (index>=self.tabContainers.count) {
        return;
    }
    SubItemView * model=[self.tabContainers objectAt:index];
    model.jsBadegeView.badgeText=[textString isEqualToString:@"0"]?@"":textString;

}

- (void) redDotAtIndex:(NSInteger) index isShow:(BOOL) isShow{
    if (index>=self.tabContainers.count) {
        return;
    }
    SubItemView * model=[self.tabContainers objectAt:index];
    model.redDot.hidden=!isShow;
}

- (void) gotoRootView{

    [self selectTabBarItemAtIndex:0 animated:NO];
}

#pragma mark - Notification
- (void) jumpToVc:(NSNotification *)notify{
    
    [self gotoRootView];
}

- (void) updateCartNumber:(NSNotification *)notify{
    NSDictionary * inforDic=notify.userInfo;
    NSString * number=[inforDic objectForKey:@"value"];
    if (number.integerValue > 99) {
        number=@"99+";
    }
    [self updateBadgeViewWithText:number AtIndex:3];
}

#pragma mark - animation
- (void) playAnimationOnView:(UIImageView *)imageView{

    CAKeyframeAnimation * keyanimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyanimation.values=@[@1.0,@1.4,@0.9,@1.2,@.95,@1.0];
    keyanimation.duration=0.5f;
    [imageView.layer addAnimation:keyanimation forKey:@"boucne"];
}

- (void) setCustemTabItems:(NSArray *)array{
    _tabItems=array;
}

#pragma mark - setter and getter
- (NSArray *) tabItems{
    if (_tabItems==nil) {
        NSMutableArray * mutArray=[[NSMutableArray alloc] init];
        for (UITabBarItem * item in self.tabBar.items) {
            UleCustemTabBarItem * uleItem =[[UleCustemTabBarItem alloc] initWithTitle:item.title image:item.image selectedImage:item.selectedImage normalColor:self.defaultColor?self.defaultColor:[UIColor grayColor] selectColor:self.selectedColor?self.selectedColor:[UIColor redColor]];
            [mutArray addObject:uleItem];
        }
        _tabItems=[mutArray copy];
    }
  
    return _tabItems;
}

- (NSMutableArray *) tabContainers{
    if (_tabContainers==nil) {
        _tabContainers=[NSMutableArray array];
    }
    return _tabContainers;
}

- (NSMutableArray *) normalImages{
    if (_normalImages==nil) {
        _normalImages=[NSMutableArray array];
    }
    return _normalImages;
}

-(NSMutableArray *) selectImages{
    if (_selectImages==nil) {
        _selectImages=[NSMutableArray array];
    }
    return _selectImages;
}

#pragma mark --<屏幕方向>
- (BOOL) shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}
@end
