//
//  US_SyncGoodsAlert.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SyncGoodsAlert.h"
#import <UIView+SDAutoLayout.h>


@interface US_SyncGoodsAlert ()

@property (nonatomic, assign) US_SyncGoodsAlertType alertType;
@property (nonatomic, strong) SyncAlertBlock clickBlock;
@property (nonatomic, strong) UIImageView * topImgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton * normalBtn;
@property (nonatomic, strong) UIButton * syncAgainBtn;
@end


@implementation US_SyncGoodsAlert

+ (US_SyncGoodsAlert *)alertWithType:(US_SyncGoodsAlertType)type clickBlock:(__nullable SyncAlertBlock) click{
    US_SyncGoodsAlert * alertView=[[US_SyncGoodsAlert alloc] initWithFrame:CGRectMake(0, 0, KScreenScale(500), KScreenScale(600)) alertType:type clickBLock:click];
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame alertType:(US_SyncGoodsAlertType) alertType clickBLock:(SyncAlertBlock)clickBlock{
    self = [super initWithFrame:frame];
    self.alertType=alertType;
    self.clickBlock = [clickBlock copy];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=8.0;
        self.clipsToBounds=YES;
        [self sd_addSubviews:@[self.topImgView,self.contentLabel,self.normalBtn,self.syncAgainBtn]];
        self.topImgView.sd_layout.centerXEqualToView(self)
        .topSpaceToView(self, KScreenScale(150))
        .widthIs(KScreenScale(170)).heightIs(KScreenScale(190));
        
        self.contentLabel.sd_layout.topSpaceToView(self.topImgView, KScreenScale(25))
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(KScreenScale(45));
        
        if (self.alertType==US_SyncGoodsAlertTypeSuccess) {
            self.topImgView.image=[UIImage bundleImageNamed:@"myGoods_sync_success"];
            self.contentLabel.text=@"同步成功";
            self.normalBtn.sd_layout.leftSpaceToView(self, KScreenScale(40))
            .rightSpaceToView(self, KScreenScale(40))
            .bottomSpaceToView(self, KScreenScale(40))
            .heightIs(KScreenScale(80));
            [self.normalBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
             self.topImgView.image=[UIImage bundleImageNamed:@"myGoods_sync_fail"];
            self.contentLabel.text=@"同步失败";
            [self.normalBtn setTitle:@"取消" forState:UIControlStateNormal];
            self.normalBtn.backgroundColor=[UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
            self.normalBtn.layer.cornerRadius=KScreenScale(40);
            [self.normalBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.normalBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
            self.normalBtn.sd_layout.leftSpaceToView(self, KScreenScale(30))
            .bottomSpaceToView(self, KScreenScale(40))
            .heightIs(KScreenScale(80))
            .widthIs((self.width_sd-KScreenScale(30)*3)/2.0);
            self.syncAgainBtn.sd_layout.rightSpaceToView(self, KScreenScale(30))
            .bottomSpaceToView(self, KScreenScale(40))
            .heightIs(KScreenScale(80))
            .leftSpaceToView(self.normalBtn, KScreenScale(30));
         
        }
        

    }
    return self;
}

- (void)syncAgainBtnClick:(id)sender{
    if (self.clickBlock) {
        self.clickBlock();
    }
    [self hiddenView];
}

- (void)normalBtnClick:(id)sender{
    [self hiddenView];
}

#pragma mark - <setter and getter>
- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView=[[UIImageView alloc] init];
    }
    return _topImgView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[UILabel new];
        _contentLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _contentLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];
        _contentLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)normalBtn{
    if (!_normalBtn) {
        _normalBtn=[UIButton new];
        [_normalBtn addTarget:self action:@selector(normalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _normalBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        _normalBtn.layer.cornerRadius=KScreenScale(40);
        [_normalBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_normalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _normalBtn;
}

- (UIButton *)syncAgainBtn{
    if (!_syncAgainBtn) {
        _syncAgainBtn=[[UIButton alloc] init];
        [_syncAgainBtn addTarget:self action:@selector(syncAgainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _syncAgainBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        _syncAgainBtn.layer.cornerRadius=KScreenScale(40);
        [_syncAgainBtn setTitle:@"再试一下" forState:UIControlStateNormal];
        [_syncAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _syncAgainBtn;
}

@end
