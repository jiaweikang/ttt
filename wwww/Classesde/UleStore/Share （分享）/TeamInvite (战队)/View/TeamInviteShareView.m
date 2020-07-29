//
//  TeamInviteShareView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "TeamInviteShareView.h"
#import <UIView+SDAutoLayout.h>
#import "UIImage+USAddition.h"
#import "USAuthorizetionHelper.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIImage+Extension.h>
#import "UleKoulingDetectManager.h"
#import "DeviceInfoHelper.h"

@interface TeamInviteShareView ()
@property (nonatomic, strong) UIImageView * topImgView;
@property (nonatomic, strong) UILabel * iconLabel;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel * topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIImageView *qrImgview;
@property (nonatomic, strong) UIButton * bottomLeftBtn;
@property (nonatomic, strong) UIButton * bottomRightBtn;
@end

@implementation TeamInviteShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self loadTeamInvitePosterViewUI];
    }
    return self;
}

- (void)loadTeamInvitePosterViewUI{
    self.alpha=0.0;
    [self sd_addSubviews:@[self.topImgView,self.topLabel,self.qrImgview,self.bottomLabel,self.iconImgView,self.iconLabel,self.bottomLeftBtn,self.bottomRightBtn]];
    self.topImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.topLabel.sd_layout.topSpaceToView(self, KScreenScale(110))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(100));
    
    self.qrImgview.sd_layout.topSpaceToView(self, KScreenScale(225))
    .centerXEqualToView(self)
    .heightIs(KScreenScale(280)).widthEqualToHeight();
    self.bottomLabel.sd_layout.topSpaceToView(self.qrImgview, KScreenScale(10))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0).heightIs(KScreenScale(80));
    
    self.iconImgView.sd_layout.topSpaceToView(self.bottomLabel, KScreenScale(10))
    .leftSpaceToView(self, KScreenScale(150))
    .widthIs(KScreenScale(90)).heightEqualToWidth();
    
    self.iconLabel.sd_layout.topEqualToView(self.iconImgView)
    .leftSpaceToView(self.iconImgView, KScreenScale(10))
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(90));
    
    self.bottomLeftBtn.sd_layout.bottomSpaceToView(self, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(280)).heightIs(KScreenScale(80));
    
    self.bottomRightBtn.sd_layout.bottomSpaceToView(self, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(280)).heightIs(KScreenScale(80));
    
}

- (void)setModel:(TeamInviteModel *)model{
    TeamInviteModel *teamInviteModel = (TeamInviteModel *)model;
    _model=teamInviteModel;
    self.topLabel.text=[NSString isNullToString:teamInviteModel.headerText];
    self.qrImgview.image= [UIImage uleQRCodeForString:[NSString isNullToString:teamInviteModel.qrCodeUrl] size:200 fillColor:[UIColor blackColor] iconImage:teamInviteModel.logoImage];
    self.bottomLabel.text=[NSString isNullToString:teamInviteModel.footerText];
}

- (void)saveClick:(id)sender{
    if ([USAuthorizetionHelper photoLibaryAuth]) {
        [self saveKoulingStr];
        UIImage * postImage=[self buildPostViewToImage];
        UIImageWriteToSavedPhotosAlbum(postImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [LogStatisticsManager onClickLog:Share_SavePoster andTev:@""];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 回调
    if (error) {
         [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:2.0];
    }else{
         [UleMBProgressHUD showHUDWithText:@"保存成功" afterDelay:2.0];
    }
}

- (void)copyClick:(id)sender{
    if (self.model) {
        [self saveKoulingStr];
        [UleMBProgressHUD showHUDWithText:@"口令已复制，快去粘贴吧！" afterDelay:1];
        [LogStatisticsManager onClickLog:Share_CopyToken andTev:@""];
    }
}

- (void)saveKoulingStr{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:self.model.kouling];
    [UleKoulingDetectManager sharedManager].localKouLing = self.model.kouling;
}

- (UIImage *)buildPostViewToImage{
    self.bottomLeftBtn.hidden=YES;
    self.bottomRightBtn.hidden=YES;
    UIImage * postImage=[UIImage makeImageWithView:self];
    self.bottomLeftBtn.hidden=NO;
    self.bottomRightBtn.hidden=NO;
    return postImage;
}

#pragma mark - <setter and getter>
- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView=[UIImageView new];
        _topImgView.image=[UIImage bundleImageNamed:@"share_img_inviteBg"];
        _topImgView.backgroundColor=[UIColor redColor];
    }
    return _topImgView;
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView=[UIImageView new];
        _iconImgView.image=[UIImage imageNamed:@"US_icon"];
    }
    return _iconImgView;
}

- (UILabel *)iconLabel{
    if (!_iconLabel) {
        _iconLabel=[UILabel new];
        _iconLabel.text = [@"更多详情请上" stringByAppendingString:[DeviceInfoHelper getAppName]];
        _iconLabel.textColor = [UIColor redColor];
        _iconLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
    }
    return _iconLabel;
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel=[UILabel new];
        _topLabel.textColor=[UIColor whiteColor];
        _topLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(36)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}
- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel=[UILabel new];
        _bottomLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _bottomLabel.textAlignment=NSTextAlignmentCenter;
        _bottomLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(32)];
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.numberOfLines=0;
    }
    return _bottomLabel;
}
- (UIImageView *)qrImgview{
    if (!_qrImgview) {
        _qrImgview=[UIImageView new];
        _qrImgview.backgroundColor=[UIColor redColor];
    }
    return _qrImgview;
}
- (UIButton *)bottomLeftBtn{
    if (!_bottomLeftBtn) {
        _bottomLeftBtn=[UIButton new];
        [_bottomLeftBtn setImage:[UIImage bundleImageNamed:@"share_btn_save_normal"] forState:UIControlStateNormal];
        [_bottomLeftBtn setImage:[UIImage bundleImageNamed:@"share_btn_save_press"] forState:UIControlStateHighlighted];
        [_bottomLeftBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomLeftBtn;
}
- (UIButton *)bottomRightBtn{
    if (!_bottomRightBtn) {
        _bottomRightBtn=[UIButton new];
        [_bottomRightBtn setImage:[UIImage bundleImageNamed:@"share_btn_copy_normal"] forState:UIControlStateNormal];
        [_bottomRightBtn setImage:[UIImage bundleImageNamed:@"share_btn_copy_press"] forState:UIControlStateHighlighted];
        [_bottomRightBtn addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightBtn;
}

@end
