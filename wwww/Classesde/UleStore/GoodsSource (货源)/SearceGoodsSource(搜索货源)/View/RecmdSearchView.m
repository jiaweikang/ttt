//
//  RecmdSearchView.m
//  UleApp
//
//  Created by chenzhuqing on 2017/10/25.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "RecmdSearchView.h"
#import <UIView+SDAutoLayout.h>
#import "UIViewController+UleExtension.h"
#import <UIView+ShowAnimation.h>
#import "UleControlView.h"
#import "US_AlertView.h"
#import "UserDefaultManager.h"
#define kSectionMargin 10
#define kViewMargin 20
#define kLineSpace 10
#define kButtonHeight 35
#define kButtonMargin  50
@interface RecmdSearchView()

@property (nonatomic, assign) CGFloat topY;
@property (nonatomic, assign) CGFloat historyTopY;
@end


@implementation RecmdSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
    }
    return self;
}

- (void)loadHotSearchTitle{
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    title.text=@"热门搜索";
    title.textColor=[UIColor lightGrayColor];
    title.font=[UIFont systemFontOfSize:16.0];
    self.topY=title.bottom_sd;
    [self addSubview:title];
}

- (void)reloadHotSearchViewWithData:(NSArray<SearchKeyWordItem*> *)searchKeyWords{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    if ([searchKeyWords count]>0) {
        [self loadHotSearchTitle];
    }
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGFloat x=kViewMargin;
    CGFloat y=self.topY+5;
    for (int i=0; i<searchKeyWords.count; i++) {
        SearchKeyWordItem * item=searchKeyWords[i];
        CGSize size =[item.title boundingRectWithSize:CGSizeMake(__MainScreen_Width-2*kViewMargin, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        //限制按键最大长度
        CGFloat currentBtnWidth=(size.width+kButtonMargin)>__MainScreen_Width-2*kViewMargin?__MainScreen_Width-2*kViewMargin:(size.width+kButtonMargin);
        //如果文字高度大于30则取文字高度，否则默认30
        CGFloat maxBtnHeight=size.height+5>kButtonHeight?size.height+5:kButtonHeight;
        if (x+currentBtnWidth>(__MainScreen_Width-kViewMargin)) {
            //另起一行（最右边留20）
            y=y+maxBtnHeight+kLineSpace;
            x=kViewMargin;
        }
        UIButton * searchKeyBtn=[self creatSearchKeyButtonWithFrame:CGRectMake(x, y,currentBtnWidth, maxBtnHeight) andTitle:item.title];
        searchKeyBtn.tag=1000+i;
        [self addSubview:searchKeyBtn];
        x=searchKeyBtn.right_sd+kLineSpace;
    }
    
    [self loadHistorySearchViewWithOriginY:y+kButtonHeight];
}


- (void)reloadHistorySearchView{
    if(self.historyTopY<=0){
        return;
    }
    for (int i=2000; i<2010; i++) {
        UIView * subView= [self viewWithTag:i];
        [subView removeFromSuperview];
    }
    UIView * title= [self viewWithTag:3000];
    [title removeFromSuperview];
    UIView * deletBtn= [self viewWithTag:3001];
    [deletBtn removeFromSuperview];

    [self loadHistorySearchViewWithOriginY:self.historyTopY];
}


- (void)loadHistorySearchViewWithOriginY:(CGFloat)originY{
    self.historyTopY=originY;
    NSMutableArray * search_arr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_SearchRecord];
    if ([search_arr count] <= 0) {
        return;
    }
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(20, originY+10, 100, 30)];
    title.text=@"历史搜索";
    title.textColor=[UIColor lightGrayColor];
    title.font=[UIFont systemFontOfSize:16.0];
    title.tag=3000;
    [self addSubview:title];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGFloat x=kViewMargin;
    CGFloat y=title.bottom_sd+5;
    
    for (int i=0; i<search_arr.count; i++) {
        NSString * title =search_arr[i];
        CGSize size =[title boundingRectWithSize:CGSizeMake((__MainScreen_Width-3*kViewMargin)/2, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        //限制按键最大长度
        CGFloat currentBtnWidth=(size.width+kButtonMargin)>(__MainScreen_Width-3*kViewMargin)/2?(__MainScreen_Width-3*kViewMargin)/2:(size.width+kButtonMargin);
        //高度固定
        CGFloat maxBtnHeight=kButtonHeight;
        if (x+currentBtnWidth>(__MainScreen_Width-kViewMargin)) {
            //另起一行（最右边留20）
            y=y+maxBtnHeight+kLineSpace;
            x=kViewMargin;
        }
        UIButton * searchKeyBtn=[self creatSearchKeyButtonWithFrame:CGRectMake(x, y,currentBtnWidth, maxBtnHeight) andTitle:title];
        searchKeyBtn.tag=2000+i;
        [self addSubview:searchKeyBtn];
        x=searchKeyBtn.right_sd+kLineSpace;
    }
    
    UleControlView * deletBtn=[[UleControlView alloc] initWithFrame:CGRectMake(__MainScreen_Width-56-kViewMargin, 0, 56, 30)];
    deletBtn.userInteractionEnabled=YES;
    deletBtn.tag=3001;
    deletBtn.mImageView.frame=CGRectMake(0, 5, 20, 20);
    deletBtn.mTitleLabel.frame=CGRectMake(18, 6, 36, 19);
    deletBtn.mTitleLabel.text=@"清除";
    deletBtn.mImageView.image=[UIImage bundleImageNamed:@"goods_btn_deleteSearch"];
    [deletBtn.mTitleLabel setTextColor:[UIColor convertHexToRGB:@"98999a"]];
    [deletBtn.mTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [deletBtn addTouchTarget:self action:@selector(deletBtnClick:)];
    [self addSubview:deletBtn];
    deletBtn.sd_layout.centerYEqualToView(title);

}

- (void)deletBtnClick:(id)sender{
    US_AlertView * alertView=[[US_AlertView alloc] initWithWithTitle:@"" message:@"确定要清空吗？" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    [alertView showViewWithAnimation:AniamtionAlert];
    @weakify(self);
    alertView.clickBlock = ^(NSInteger buttonIndex,NSString * title) {
        @strongify(self);
        if (buttonIndex==1) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSMutableArray * search_arr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_SearchRecord];
            
            for (int i=2000; i<2000+[search_arr count]; i++) {
                UIView * subView= [self viewWithTag:i];
                [subView removeFromSuperview];
            }
            UIView * title= [self viewWithTag:3000];
            [title removeFromSuperview];
            UIView * deletBtn= [self viewWithTag:3001];
            [deletBtn removeFromSuperview];
            [defaults removeObjectForKey:kUserDefault_SearchRecord];
            [defaults synchronize];
            
            
        }
    };
}

- (void)btnClick:(UIButton *)btn{
    [UserDefaultManager saveRecordSearchText:btn.titleLabel.text];
    NSMutableDictionary *   dic = [[NSMutableDictionary alloc]init];
    [dic setObject:btn.titleLabel.text forKey:@"searchName"];
    [dic setObject:@"0" forKey:@"levelClassified"];
    [LogStatisticsManager onShareLog:btn.titleLabel.text tev:Search_Normal andShareTo:@""];
    [[UIViewController currentViewController] pushNewViewController:@"US_SearchGoodsSourceVC" isNibPage:NO withData:dic];
}

- (UIButton *) creatSearchKeyButtonWithFrame:(CGRect) rect andTitle:(NSString *)title{
    UIButton * formatBtn=[[UIButton alloc] initWithFrame:rect];
    formatBtn.layer.cornerRadius=(rect.size.height)/2.0;
    formatBtn.backgroundColor=[UIColor whiteColor];
    [formatBtn setTitle:title  forState:UIControlStateNormal];
    [formatBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [formatBtn.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    formatBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [formatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return formatBtn;
}

@end
