//
//  SettingTableViewCell.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "SettingTableViewCell.h"
#import <UIView+SDAutoLayout.h>
#import "SettingCellModel.h"
#import "USKeychainLocalData.h"

@interface SettingTableViewCell ()

@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * leftTitleLabel;
@property (nonatomic, strong) UILabel * leftSubTitleLabel;
@property (nonatomic, strong) UILabel * rightTitleLabel;
@property (nonatomic, strong) UISwitch * rightSwitch;

@end


@implementation SettingTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView sd_addSubviews:@[self.iconImageView,self.leftTitleLabel,self.rightTitleLabel,self.leftSubTitleLabel,self.rightSwitch]];
        self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 15)
        .widthIs(19)
        .heightIs(19);
        self.leftTitleLabel.sd_layout.leftSpaceToView(self.iconImageView, 10)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .widthIs(KScreenScale(300));
        self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.leftTitleLabel, 10);
        
        [self setupAutoHeightWithBottomView:self.iconImageView bottomMargin:15];
        
    }
    return self;
}

- (void)setModel:(SettingCellModel *)model{
    self.iconImageView.image=[UIImage bundleImageNamed:model.iconStr];
    self.leftTitleLabel.text=model.leftTitleStr;
    self.rightTitleLabel.text=model.rightTitleStr;
    if (model.showRightArrow) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0);
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
        self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 15);
    }
    if (model.leftSubTitleStr.length>0) {
        self.leftSubTitleLabel.hidden = NO;
        self.leftSubTitleLabel.text = model.leftSubTitleStr;
        self.leftTitleLabel.font = [UIFont systemFontOfSize:16];
        self.leftTitleLabel.sd_layout.topSpaceToView(self.contentView, 5)
        .bottomSpaceToView(self.contentView, 25);
        CGFloat leftSubLabWidth = [self.leftSubTitleLabel.text widthForFont:self.leftSubTitleLabel.font];
        self.leftSubTitleLabel.sd_layout.topSpaceToView(self.leftTitleLabel, 0)
        .leftEqualToView(self.leftTitleLabel)
        .widthIs(leftSubLabWidth)
        .bottomSpaceToView(self.contentView, 5);
    }
    if (model.switchState.length > 0) {
        self.rightTitleLabel.hidden = YES;
        self.rightSwitch.hidden = NO;
        self.rightSwitch.sd_layout.rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.iconImageView)
        .widthIs(50)
        .heightIs(30);
        [self.rightSwitch setOn:[model.switchState boolValue]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchAction{
    [USKeychainLocalData data].isVoicePromptOn = self.rightSwitch.isOn;
    NSString * state=[USKeychainLocalData data].isVoicePromptOn?@"false":@"true";
    [LogStatisticsManager onClickLog:Setting_VoiceClose andTev:state];
}

#pragma mark - <setter and getter>
- (UIImageView *) iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}
- (UILabel *)leftTitleLabel{
    if (!_leftTitleLabel) {
        _leftTitleLabel=[[UILabel alloc] init];
        _leftTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _leftTitleLabel.font = [UIFont systemFontOfSize:15];
        _leftTitleLabel.textAlignment = NSTextAlignmentLeft;
        _leftTitleLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _leftTitleLabel;
}
- (UILabel *)leftSubTitleLabel{
    if (!_leftSubTitleLabel) {
        _leftSubTitleLabel = [[UILabel alloc]init];
        _leftSubTitleLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _leftSubTitleLabel.font = [UIFont systemFontOfSize:14];
        _leftSubTitleLabel.hidden = YES;
    }
    return _leftSubTitleLabel;
}
- (UILabel *)rightTitleLabel{
    if (!_rightTitleLabel) {
        _rightTitleLabel=[[UILabel alloc] init];
        _rightTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        _rightTitleLabel.font = [UIFont systemFontOfSize:14];
        _rightTitleLabel.textAlignment = NSTextAlignmentRight;
        _rightTitleLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _rightTitleLabel;
}
- (UISwitch *)rightSwitch{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc]init];
        [_rightSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
        _rightSwitch.hidden = YES;
    }
    return _rightSwitch;
}

@end
