//
//  UlePopupMenu.m
//  UleNavgationBarPop
//
//  Created by uleczq on 2017/7/28.
//  Copyright © 2017年 uleczq. All rights reserved.
//

#import "UlePopupMenu.h"
#import <UIView+SDAutoLayout.h>
#import <YYWebImage.h>
#define kMenuMaxWith  150
#define kMenuMaxHeight 200
#define kArrowWidth  15
#define kArrowHeight  10
#define kCornerRadius  5
#define kMenuCellHeight  44


@interface UlePopupMenu ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UITableView * menuTable;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * iconArray;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat arrowPosition;
@property (nonatomic, assign) CGPoint touchPoint;
@end

@implementation UlePopupMenu

- (instancetype)init{
    self= [super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.layer.shadowOpacity =0.5 ;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 2.0 ;
        self.layer.anchorPoint = CGPointMake(1, 0);
        _borderWidth=0.0;
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.menuTable.frame=CGRectMake(_borderWidth, 10, frame.size.width, frame.size.height-10);
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //利用path进行绘制三角形
    CGFloat beginX=(self.touchPoint.x-CGRectGetMinX(self.frame));
    CGFloat beginY=0;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint topLeftArcCenter = CGPointMake(5, 15);
    CGPoint topRightArcCenter = CGPointMake(rect.size.width-5, beginY+kArrowHeight+5);
    CGPoint bottomLeftArcCenter = CGPointMake(5,CGRectGetHeight(rect)-5);
    CGPoint bottomRightArcCenter = CGPointMake(rect.size.width-5,CGRectGetHeight(rect)-5);
    
    [bezierPath moveToPoint:CGPointMake(beginX, beginY)];
    [bezierPath addLineToPoint:CGPointMake(beginX+kArrowWidth/2.0, beginY+kArrowHeight)];
    [bezierPath addLineToPoint:CGPointMake(topRightArcCenter.x, beginY+kArrowHeight)];
    [bezierPath addArcWithCenter:topRightArcCenter radius:5 startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, bottomRightArcCenter.y)];
    [bezierPath addArcWithCenter:bottomRightArcCenter radius:5 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(bottomLeftArcCenter.x, CGRectGetHeight(rect))];
    [bezierPath addArcWithCenter:bottomLeftArcCenter radius:5 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(0, topLeftArcCenter.y)];
    [bezierPath addArcWithCenter:topLeftArcCenter radius:5 startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    
    [bezierPath addLineToPoint:CGPointMake(beginX-kArrowWidth/2.0, beginY+kArrowHeight)];
    
    [[UIColor whiteColor] setStroke];
    [[UIColor whiteColor]  setFill];
    [bezierPath fill];
    [bezierPath stroke];
    
}

+ (instancetype)showOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons delegate:(id<UlePopupMenuDelegate>)mdelegate{
    if ((titles.count==icons.count)&&titles.count>0) {
        CGRect absoluteRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGPoint touchPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height-2);
        UlePopupMenu * popupMenu=[[UlePopupMenu alloc] init];
        [popupMenu.titleArray addObjectsFromArray:titles];
        [popupMenu.iconArray addObjectsFromArray:icons];
        popupMenu.delegate=mdelegate;
        popupMenu.touchPoint=touchPoint;
        [popupMenu layoutMeneAtPoint:touchPoint];
        [popupMenu addSubview:popupMenu.menuTable];
        [popupMenu show];
        return popupMenu;
    }
    return nil;
}

- (void)layoutMeneAtPoint:(CGPoint)point{
    //右上角
//    if (point.x+kMenuMaxWith/2.0>[UIScreen mainScreen].bounds.size.width) {
        CGFloat height;
        if (self.titleArray.count>4) {
            height=kMenuMaxHeight;
        }else{
            height=kMenuCellHeight*self.titleArray.count+10;
        }
        NSLog(@"==%f",(point.x-([UIScreen mainScreen].bounds.size.width-kMenuMaxWith-5))/kMenuMaxWith);
        self.layer.anchorPoint=CGPointMake((point.x-([UIScreen mainScreen].bounds.size.width-kMenuMaxWith-5))/kMenuMaxWith, 0);
        self.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-kMenuMaxWith-5, point.y, kMenuMaxWith, height);
//    }
//    //左上角
//    if ((point.x-kMenuMaxWith/2.0)<0) {
//        NSLog(@"==%f",(point.x)/kMenuMaxWith);
//        self.layer.anchorPoint=CGPointMake((point.x)/kMenuMaxWith, 0);
//        self.frame=CGRectMake(5, point.y, kMenuMaxWith, kMenuMaxHeight);
//        
//    }
}

- (void)show{
    UIWindow * window= [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    [window addSubview:self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dissmiss{
    [UIView animateWithDuration: 0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
    
}

#pragma tableView delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify=@"menuCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
    }
    cell.textLabel.text=self.titleArray[indexPath.row];
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:self.iconArray[indexPath.row]] placeholder:[UIImage imageNamed:@"placehold80x80"]];
     CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&& [self.delegate respondsToSelector:@selector(didClickAtIndex:)]) {
        [self.delegate didClickAtIndex:indexPath.row];
    }
    [self dissmiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kMenuCellHeight;
}


#pragma click event
- (void)touchOutSide:(UIGestureRecognizer *)recognizer{
    [self dissmiss];
}

#pragma mark-  setter and getter
- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _bgView.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha=0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide:)];
        [_bgView addGestureRecognizer: tap];
    }
    return _bgView;
}

- (UITableView *)menuTable{
    if (!_menuTable) {
        _menuTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-10) style:UITableViewStylePlain];
        _menuTable.dataSource=self;
        _menuTable.delegate=self;
//        _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTable.backgroundColor=[UIColor whiteColor];
        _menuTable.layer.cornerRadius=5;
    }
    return _menuTable;
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)iconArray{
    if (!_iconArray) {
        _iconArray=[[NSMutableArray alloc] init];
    }
    return _iconArray;
}
@end
