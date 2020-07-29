//
//  US_StoreDetailTabView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_StoreDetailTabView.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"

@interface US_StoreDetailTabButton : UleControlView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL upsort;
@property (nonatomic, copy) NSString * sortType;
@property (nonatomic, assign) BOOL cansort;//是否可以排序

@end

@implementation US_TopTabItem

+ (instancetype) tabItemWithTitle:(NSString *)title sortType:(NSString *)sortType{
    US_TopTabItem * item=[[US_TopTabItem alloc] init];
    item.title=title;
    item.sortType=sortType;
    item.canSortOrder=YES;
    return item;
}

@end

@implementation US_StoreDetailTabButton

+ (US_StoreDetailTabButton *) buildTabButton:(NSString *)name{
    US_StoreDetailTabButton * btn=[[US_StoreDetailTabButton alloc] init];
    btn.mTitleLabel.text=name;
    btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    btn.mTitleLabel.font=[UIFont systemFontOfSize:15];
    btn.mImageView.image=[UIImage bundleImageNamed:@"storeDetail_icn_downArrow"];
    btn.mTitleLabel.sd_layout.topSpaceToView(btn, 0)
    .bottomSpaceToView(btn, 0)
    .centerXEqualToView(btn).autoWidthRatio(0);
    [btn.mTitleLabel setSingleLineAutoResizeWithMaxWidth:200];
    btn.mImageView.sd_layout.leftSpaceToView(btn.mTitleLabel, 2)
    .centerYEqualToView(btn.mTitleLabel)
    .widthIs(12).heightIs(6);
    btn.upsort=NO;
    return btn;
}

- (void)setSelected:(BOOL)selected{
    _selected=selected;
    if (_selected) {
        self.mImageView.hidden=NO;
        self.mTitleLabel.textColor=[UIColor convertHexToRGB:@"ef3b39"];
    }else{
        self.mImageView.hidden=YES;
        self.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    }
}

- (void)setUpsort:(BOOL)upsort{
    self.mImageView.hidden=NO;
    _upsort=upsort;
    if (_upsort) {
        self.mImageView.image=[UIImage bundleImageNamed:@"storeDetail_icn_upArrow"];
    }else{
        self.mImageView.image=[UIImage bundleImageNamed:@"storeDetail_icn_downArrow"];
    }
}


@end

@interface US_StoreDetailTabView ()
@property (nonatomic, strong) US_StoreDetailTabButton * currentSelectBtn;
@property (nonatomic, strong) NSMutableArray * btnArray;
@end

@implementation US_StoreDetailTabView

- (instancetype)initWithItems:(NSArray *)items{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 49)];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _btnArray=[[NSMutableArray alloc] init];
        CGFloat btnWidth=__MainScreen_Width/items.count;
        for (int i=0; i<items.count; i++) {
            US_TopTabItem * item=items[i];
            US_StoreDetailTabButton * tabButton=[US_StoreDetailTabButton buildTabButton:item.title];
            [tabButton addTouchTarget:self action:@selector(tabButton:)];
            tabButton.selected=NO;
            tabButton.sortType=item.sortType;
            tabButton.cansort=item.canSortOrder;
            [self addSubview:tabButton];
            tabButton.sd_layout.leftSpaceToView(self, i*btnWidth)
            .topSpaceToView(self, 0)
            .bottomSpaceToView(self, 0)
            .widthIs(btnWidth);
             UIView * line=[self buildSplitLine];
            [self addSubview:line];
            line.sd_layout.leftSpaceToView(tabButton, 0)
            .topSpaceToView(self, 10)
            .bottomSpaceToView(self, 10)
            .widthIs(0.5);
            UIView * bottomLine=[self buildSplitLine];
            [self addSubview:bottomLine];
            bottomLine.sd_layout.leftSpaceToView(self, 0)
            .bottomSpaceToView(self, 0)
            .rightSpaceToView(self, 0)
            .heightIs(0.5);
            //默认第一个
            if (i==0) {
                tabButton.selected=YES;
                self.currentSelectBtn=tabButton;
            }
            [self.btnArray addObject:tabButton];
        }
    }
    return self;
}


#pragma mark - <button click>
- (void)tabButton:(US_StoreDetailTabButton *)sender{
    if (sender.selected==YES) {
        if (sender.cansort) {
           sender.upsort=!sender.upsort;
        }else{
            sender.upsort=NO;
        }
        
    }else{
        sender.selected=YES;
        self.currentSelectBtn.selected=NO;
        self.currentSelectBtn=sender;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSortType:sortOrder:)]) {
        [self.delegate didSelectedSortType:sender.sortType sortOrder:sender.upsort==YES?@"1":@"2"];
    }
}

#pragma mark - <setter and getter>

- (UIView *)buildSplitLine{
    UIView * splitLine=[UIView new];
    splitLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    return splitLine;
}

@end
