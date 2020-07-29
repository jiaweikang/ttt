//
//  WalletButtonCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/11/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "WalletButtonCell.h"
#import <UIView+SDAutoLayout.h>
#import "MineCellModel.h"
#import "UleControlView.h"
#import "UleModulesDataToAction.h"
static CGFloat USButtonOffset = 10.0;
static CGFloat USButtonWidth = 66.0;
static CGFloat USButtonHeight = 50.0;

@interface WalletButtonCell ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) MineCellModel * model;
@end
@implementation WalletButtonCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.contentView.backgroundColor=[UIColor whiteColor];
        self.accessoryType=UITableViewCellAccessoryNone;
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(MineCellModel *)model{

    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    _model=model;
    int amountButtonNum=model.walletButtonArr.count-1;
    CGFloat rightWidth=__MainScreen_Width-20-USButtonOffset*3-USButtonWidth-10;
    CGFloat rightButtonWidth=rightWidth/amountButtonNum;
    CGFloat rightFirstButtonX=0.0;
    for (int i=0; i<_model.walletButtonArr.count; i++) {
        MineCellModel * buttonModel=[_model.walletButtonArr objectAtIndex:i];
        UleControlView * buttonView = [[UleControlView alloc] init];
        buttonView.tag=100+i;
        // 点击手势
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonViewClickAction:)];
        [buttonView addGestureRecognizer:mTap];
        
        [self.contentView addSubview:buttonView];
        //第一个按钮固定位置
        if (i==0) {
            [buttonView setFrame:CGRectMake(USButtonOffset, USButtonOffset, USButtonWidth, USButtonHeight)];
            
            [self setupAutoHeightWithBottomView:buttonView bottomMargin:USButtonOffset];
            //第一个按钮右边加分隔线
            UIImageView * lineView=[[UIImageView alloc] initWithFrame:CGRectMake(buttonView.right_sd+USButtonOffset, 15, 10, USButtonHeight)];
            [lineView setImage:[UIImage bundleImageNamed:@"my_img_shadowLine"]];
            rightFirstButtonX=lineView.right_sd+USButtonOffset;
            
            [self.contentView addSubview:lineView];
        }
        else{
            [buttonView setFrame:CGRectMake(rightButtonWidth*(i-1)+rightFirstButtonX, USButtonOffset, rightButtonWidth, USButtonHeight)];
        }
       if (buttonModel.iconUrlStr.length>0) {
           buttonView.mImageView.frame = buttonView.bounds;
           [buttonView.mImageView yy_setImageWithURL:[NSURL URLWithString:buttonModel.iconUrlStr] placeholder:nil];
       }
       else{
           UILabel * bottomLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightButtonWidth, USButtonHeight/2)];
           bottomLab.font=[UIFont systemFontOfSize:12];
           bottomLab.textAlignment = NSTextAlignmentCenter;
           [bottomLab setTextColor:[UIColor convertHexToRGB:@"999999"]];
           [bottomLab setText:buttonModel.titleStr];
           [buttonView addSubview:bottomLab];
           if (buttonModel.functionId.length>0) {
               [buttonView.mTitleLabel setFrame:CGRectMake(0, 4, rightButtonWidth, USButtonHeight/2)];
               buttonView.mTitleLabel.font=[UIFont boldSystemFontOfSize:16];
               bottomLab.top_sd=USButtonHeight/2;
               [buttonView.mTitleLabel setText:buttonModel.rightTitleStr];
           }
           else{
               bottomLab.sd_layout.centerYEqualToView(buttonView);
           }
       }
    }
}

- (void)buttonViewClickAction:(UITapGestureRecognizer *)tap{
    UleControlView * buttonView=(UleControlView *)tap.view;
    MineCellModel * buttonModel=[self.model.walletButtonArr objectAtIndex:buttonView.tag-100];
    if (buttonModel && buttonModel.ios_action.length>0) {
        UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:buttonModel.ios_action];
        [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
    }
}
@end
