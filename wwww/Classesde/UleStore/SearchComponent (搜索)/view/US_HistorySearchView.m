//
//  US_HistorySearchView.m
//  u_store
//
//  Created by uleczq on 2017/6/26.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "US_HistorySearchView.h"
#import "FileController.h"
#import <UIView+SDAutoLayout.h>

@interface US_HistorySearchView ()
@property (nonatomic, strong) UILabel * emptyNoteLabel;
@end

@implementation US_HistorySearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    CGFloat x=10;
    CGFloat y=10;
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 30)];
    titleLabel.text=@"历史搜索";
    titleLabel.tag=-10;
    titleLabel.font=[UIFont systemFontOfSize:14.0f];
    titleLabel.textColor=[UIColor convertHexToRGB:@"B3B3B3"];
    [self addSubview:titleLabel];
    
    UIButton * cancel=[[UIButton alloc] initWithFrame:CGRectMake(__MainScreen_Width-45, y, 40, 30)];
    [cancel setImage:[UIImage bundleImageNamed:@"search_btn_delete"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag=-11;
    [self addSubview:cancel];
}


- (void)setKeywordsArray:(NSMutableArray *)keywordsArray{
    _keywordsArray=keywordsArray;
    if (_keywordsArray.count>0) {
        [self loadHistoryKeywords];
        [self.emptyNoteLabel removeFromSuperview];
        self.emptyNoteLabel=nil;
    }else{
        self.emptyNoteLabel.hidden=NO;
    }
}

- (void)loadHistoryKeywords{
    CGFloat x=10;
    CGFloat y=50;
    CGFloat height=30;
    CGFloat rows=0;
    //先删除页面上的视图，避免重复添加
    for (UIButton * btn in self.subviews) {
        if (btn.tag>=0) {
            [btn removeFromSuperview];
        }
    }
    for (int i=0; i<_keywordsArray.count; i++) {
        CGSize strSize=[self caculeteSizeOfText:_keywordsArray[i]];
        CGFloat btnWith=strSize.width+20;
        if (btnWith>__MainScreen_Width-20) {//设置关键字按键最大长度
            btnWith=__MainScreen_Width-20;
        }
        if ((x+btnWith+10)>__MainScreen_Width) {//换行
            y=y+height+10;
            x=10;
            rows++;
        }
        UIButton * btn= [self creatSearchBtnWithFrame:CGRectMake(x, y, btnWith, height) andTitle:_keywordsArray[i]];
        btn.layer.cornerRadius=height/2.0;
        btn.tag=i;
        x=x+btnWith+10;
        if (rows>=4) {//最多显示4行
            break;
        }
        [self addSubview:btn];
    }
}


- (UIButton *)creatSearchBtnWithFrame:(CGRect)rect andTitle:(NSString *)title{
    UIButton * btn=[[UIButton alloc] initWithFrame:rect];
    btn.backgroundColor=[UIColor convertHexToRGB:@"DADADA"];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    btn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    btn.layer.cornerRadius=4.0f;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(CGSize) caculeteSizeOfText:(NSString *) text{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize titleSize=[text boundingRectWithSize:CGSizeMake(__MainScreen_Width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return titleSize;
}

- (void)searchClick:(UIButton *)sender{
    if (self.searchClick) {
        NSString * keyword=self.keywordsArray[sender.tag];
        self.searchClick(keyword);
    }
}

- (void)cancelClick:(id)sender{
    if (self.cancelClick) {
        self.cancelClick();
        for (UIButton * btn in self.subviews) {
            if (btn.tag>=0) {
                [btn removeFromSuperview];
            }
        }
        [self.keywordsArray removeAllObjects];
        self.emptyNoteLabel.hidden=NO;
    }
}

#pragma mark- setter and getter
- (UILabel *)emptyNoteLabel{
    if (!_emptyNoteLabel) {
        UILabel * placeHoldLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        placeHoldLabel.text=@"暂无搜索记录";
        placeHoldLabel.tag=-10;
        placeHoldLabel.textAlignment=NSTextAlignmentCenter;
        placeHoldLabel.font=[UIFont systemFontOfSize:16.0f];
        placeHoldLabel.textColor=[UIColor convertHexToRGB:@"B3B3B3"];
        [self addSubview:placeHoldLabel];
        _emptyNoteLabel=placeHoldLabel;
        placeHoldLabel.sd_layout.centerXEqualToView(self)
        .topSpaceToView(self, 150)
        .heightIs(30)
        .widthIs(130);
    }
    return _emptyNoteLabel;
}
@end
