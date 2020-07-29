//
//  UleRedPacketRainAwardView.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/25.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleRedPacketRainAwardView.h"
#import "UleRedPacketConfig.h"
#import "UleRedPacketRainRuleView.h"
#define  kLabelTextColor  [UIColor colorWithRed:0x97/255.0f green:0x65/255.0f blue:0x00/255.0f alpha:1]

#define kRuleColor   [UIColor colorWithRed:0xDF/255.0f green:0xAE/255.0f blue:0x28/255.0f alpha:1]

#define kNoteLabelColor [UIColor colorWithRed:0xFD/255.0f green:0x90/255.0f blue:0x54/255.0f alpha:1]

//static NSInteger const ALERTTAG_COUPON = 1111111;
//static NSInteger const ALERTTAG_CASH = 2222222;

typedef enum : NSUInteger {
    UleAwardCouponShowBig,
    UleAwardCouponShowSmall,
} UleAwardCouponShowType;


@implementation UleAwardCellModel

@end


@interface UleAwardCashCell:UITableViewCell

@end

@implementation UleAwardCashCell

@end

typedef void(^UleAwardRuleClick)(void);

@interface UleAwardConponCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UleAwardCellModel * model;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UILabel * typeLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * limitLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) UILabel * activityTimeLabel;
@property (nonatomic, strong) UleAwardRuleClick clickBlock;
@property (nonatomic, strong) UILabel * wishesLabel;
@end

@implementation UleAwardConponCell

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_bgImageView];
        [self.contentView addSubview:self.activityTimeLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.limitLabel];
        [self.contentView addSubview:self.wishesLabel];
        
        CGPoint point=self.contentView.center;
        self.activityTimeLabel.frame=CGRectMake(0, HORIZONTA(22), frame.size.width, HORIZONTA(12));
        self.moneyLabel.center=CGPointMake(point.x, point.y-HORIZONTA(70));
        self.dateLabel.frame=CGRectMake(10, CGRectGetMaxY(self.moneyLabel.frame)+HORIZONTA(5), frame.size.width-20, HORIZONTA(15));
        self.limitLabel.frame=CGRectMake(HORIZONTA(40), CGRectGetMaxY(self.dateLabel.frame)-3, frame.size.width-2*HORIZONTA(40), HORIZONTA(40));
        
        _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(HORIZONTA(40), point.y+HORIZONTA(70), frame.size.width-2*HORIZONTA(40), HORIZONTA(20))];
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        _contentLabel.textColor=kRuleColor;
        _contentLabel.font=[UIFont boldSystemFontOfSize:HORIZONTA(14)];
        [self.contentView addSubview:self.contentLabel];
        
        _noteLabel=[[UILabel alloc] initWithFrame:CGRectMake(HORIZONTA(40), CGRectGetMaxY(self.contentLabel.frame), frame.size.width-2*HORIZONTA(40),HORIZONTA(40))];
        _noteLabel.textColor=kNoteLabelColor;
        _noteLabel.font=[UIFont systemFontOfSize:HORIZONTA(11)];
        _noteLabel.numberOfLines=0;
        _noteLabel.textAlignment=NSTextAlignmentCenter;
        self.wishesLabel.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame)-20, HORIZONTA(30));
        self.wishesLabel.center=self.center;
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)setModel:(UleAwardCellModel *)model{
    _model=model;
    if (model.awardType!=UleAwardNoneType) {
        self.bgImageView.image=LoadBundleImage(@"中奖");
        if (model.awardType==UleAwardCashType) {
            self.bgImageView.image=LoadBundleImage(@"中奖_去头");
        }
        NSString * moneyStr=[NSString stringWithFormat:@"￥%@",model.money];
        CGSize size=[self getStringSize:moneyStr];
        if (size.width<HORIZONTA(150)) {
            self.moneyLabel.frame=CGRectMake(0, 0,size.width+10, CGRectGetHeight(self.moneyLabel.frame));
            CGPoint point=self.contentView.center;
            self.moneyLabel.center=CGPointMake(point.x, point.y-HORIZONTA(70));
        }
        self.moneyLabel.text=[NSString stringWithFormat:@"￥%@",model.money];
        
        
        NSString * limitStr=@"";
        NSString * limiPurchase=_model.limitPurchase.length>0?_model.limitPurchase:@"";
        if (_model.limitMoney.length>0) {
            if ([_model.limitMoney isEqualToString:@"0"]) {
                limitStr=[NSString stringWithFormat:@"无金额门槛 %@",limiPurchase];
            }else{
                limitStr=[NSString stringWithFormat:@"满%@减%@ %@",_model.limitMoney,_model.money,limiPurchase];
            }
        }else{
            if (model.awardType!=UleAwardCashType) {
                limitStr=limiPurchase;
            }
        }
        self.limitLabel.text=limitStr;
        self.typeLabel.frame=CGRectMake(CGRectGetMaxX(self.moneyLabel.frame)+5, HORIZONTA(30), 20, HORIZONTA(60));
        self.typeLabel.center=CGPointMake(self.typeLabel.center.x, self.moneyLabel.center.y);
        
        if ([_model.awardTypeStr containsString:@"优惠券"]) {
            self.contentLabel.text=@"恭喜您!抢到1张优惠券";
            self.noteLabel.text=@"优惠券预计半个小时内到账，请前往\"我的优惠券\"查看";
            self.dateLabel.text=_model.expiryDate.length>0?[NSString stringWithFormat:@"%@有效",_model.expiryDate]:@"";
        }else{
            self.contentLabel.text=@"恭喜您！抢到一份奖励金！";
            self.noteLabel.text=@"下单可直接当现金使用哦";
            if (_model.expiryDate.length>0) {
                NSArray *array=[_model.expiryDate componentsSeparatedByString:@"至"];
                self.dateLabel.text=array.count>1?[NSString stringWithFormat:@"%@失效",array[1]]:[NSString stringWithFormat:@"%@失效", _model.expiryDate];
            }else{
                self.dateLabel.text=@"";
            }
        }
        self.typeLabel.text=_model.awardTypeStr.length>0?_model.awardTypeStr:@"优惠券";
        self.wishesLabel.hidden=YES;
    }else{
        self.bgImageView.image=LoadBundleImage(@"未中奖_去头");
        self.contentLabel.text=@"好可惜，差一点就中了";
        self.noteLabel.text=@"";//@"万水千山总是情，再来一次行不行";
        self.wishesLabel.hidden=NO;
        NSArray * wishes= [model.wishes componentsSeparatedByString:@"&&"];
        NSInteger random=arc4random()%(wishes.count);
        if (wishes.count>random) {
            self.wishesLabel.text=wishes[random];
        }
    }
    self.activityTimeLabel.text=model.activityDate.length>0?model.activityDate:@"";
}

- (CGSize) getStringSize:(NSString *)targetStr{
    CGFloat maxWidth=HORIZONTA(150);
    NSDictionary * attridic=@{NSFontAttributeName:[UIFont boldSystemFontOfSize:HORIZONTA(40)]};
    CGSize size=[targetStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attridic context:nil].size;
    return size;
}

#pragma mark - <>
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,HORIZONTA(150), HORIZONTA(50))];
        _moneyLabel.textAlignment=NSTextAlignmentCenter;
        _moneyLabel.textColor=[UIColor redColor];
        _moneyLabel.adjustsFontSizeToFitWidth=YES;
        _moneyLabel.font=[UIFont boldSystemFontOfSize:HORIZONTA(40)];
    }
    return _moneyLabel;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.font=[UIFont systemFontOfSize:HORIZONTA(12)];
        _typeLabel.numberOfLines=0;
        _typeLabel.textColor=[UIColor redColor];
    }
    return _typeLabel;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textColor=kLabelTextColor;
        _dateLabel.textAlignment=NSTextAlignmentCenter;
        _dateLabel.adjustsFontSizeToFitWidth=YES;
        _dateLabel.font=[UIFont systemFontOfSize:HORIZONTA(12)];
    }
    return _dateLabel;
}

- (UILabel *)limitLabel{
    if (!_limitLabel) {
        _limitLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _limitLabel.textColor=kLabelTextColor;
        _limitLabel.textAlignment=NSTextAlignmentCenter;
        _limitLabel.font=[UIFont systemFontOfSize:HORIZONTA(12)];
        _limitLabel.numberOfLines=0;
    }
    return _limitLabel;
}
- (UILabel *)activityTimeLabel{
    if (!_activityTimeLabel) {
        _activityTimeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _activityTimeLabel.textColor=[UIColor whiteColor];
        _activityTimeLabel.font=[UIFont systemFontOfSize:HORIZONTA(8)];
        _activityTimeLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _activityTimeLabel;
}

- (UILabel *)wishesLabel{
    if (!_wishesLabel) {
        _wishesLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _wishesLabel.textColor=[UIColor redColor];
        _wishesLabel.font=[UIFont boldSystemFontOfSize:HORIZONTA(16)];
        _wishesLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _wishesLabel;
}

@end




@interface UleRedPacketRainAwardView()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UIButton * shareButton;
@property (nonatomic, strong) UIButton * cashButton;
@property (nonatomic, strong) UIButton * ruleButton;
@property (nonatomic, strong) UICollectionView * mCollectionView;
@property (nonatomic, strong) NSMutableArray * awardDataArray;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) UleAwardType awardType;
@property (nonatomic, strong) UleRedpacketRainClickBlock clickBlock;
@property (nonatomic, assign) UleAwardCouponShowType couponShowType;
@property (nonatomic, strong) NSString  *channel;
@property (nonatomic, assign) BOOL isShowShareBtn;
@end

@implementation UleRedPacketRainAwardView

#pragma mark - <life cycle>
- (instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        _awardDataArray=[[NSMutableArray alloc] init];
        [self setupView];
    }
    return self;
}

- (void) setupView{
    UIImageView * backgourdView=[[UIImageView alloc] initWithFrame:self.bounds];
    backgourdView.image=LoadBundleImage(@"背景图片");
    [self addSubview:backgourdView];
    UIButton * closeBtn=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40, kStatusBarHeight, 32, 32)];
    [closeBtn setImage:LoadBundleImage(@"关闭") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.shareButton];
    [self addSubview:self.cashButton];
    
    [self addSubview:self.mCollectionView];
    [self addSubview:closeBtn];
    [self addSubview:self.ruleButton];
    self.shareButton.frame=CGRectMake((SCREEN_WIDTH-HORIZONTA(200))*0.5, CGRectGetMaxY(self.mCollectionView.frame)+HORIZONTA750(70),HORIZONTA(200), HORIZONTA(55));
    self.cashButton.frame=CGRectMake((SCREEN_WIDTH-HORIZONTA(150))*0.5, CGRectGetMaxY(self.shareButton.frame)+HORIZONTA750(40), HORIZONTA(150), HORIZONTA(40));
}

- (void)reloadView{
    [self.mCollectionView reloadData];
    if (self.awardType==UleAwardCouponType) {
        self.shareButton.hidden=self.isShowShareBtn==YES?NO:YES;
        [self.shareButton setImage:LoadBundleImage(@"分享领红包") forState:UIControlStateNormal];
        self.cashButton.hidden=YES;
    }else if (self.awardType==UleAwardCashType) {
        self.shareButton.hidden=NO;
        CGRect shareFrame = self.shareButton.frame;
        shareFrame.origin.x=(SCREEN_WIDTH-HORIZONTA(255))*0.5;
        shareFrame.size.width=HORIZONTA(255);
        self.shareButton.frame=shareFrame;
        [self.shareButton setImage:LoadBundleImage(@"前往首页继续分享") forState:UIControlStateNormal];
        self.cashButton.hidden=NO;
    }else{
        self.shareButton.hidden=NO;
        [self.shareButton setImage:LoadBundleImage(@"前往首页继续分享") forState:UIControlStateNormal];
        self.cashButton.hidden=YES;
    }
}

- (void)parserAwardDataInfor:(NSArray *)array{
    if (array.count>0) {
        [self.awardDataArray addObjectsFromArray:array];
        UleAwardCellModel * modle=[array firstObject];
        self.awardType=modle.awardType;
    }else{
        self.awardType=UleAwardNoneType;
    }
}

+ (instancetype)showAwardViewWithDataArray:(NSArray<UleAwardCellModel *> *)dataArray channel:(NSString *)channel isShowShareBtn:(BOOL)showShareBtn clickBlock:(UleRedpacketRainClickBlock)clickBlock{
    UleRedPacketRainAwardView * awardView=[[UleRedPacketRainAwardView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    awardView.channel=channel;
    awardView.isShowShareBtn=showShareBtn;
    awardView.clickBlock = [clickBlock copy];
    [awardView parserAwardDataInfor:dataArray];
    [awardView reloadView];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:awardView];
    return awardView;
}

- (void)hiddenAwardView{
    [self removeFromSuperview];
}

#pragma mark - <event>
- (void)closeView:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.awardType==UleAwardNoneType) {
            [self hiddenAwardView];
        }else if (self.awardType==UleAwardCashType) {
            [self hiddenAwardView];
            if (self.clickBlock) {
                self.clickBlock(UleRedpacketRainEventOneMore,nil);
            }
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"恭喜您中奖啦，赶紧去使用吧！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"再抽一次",@"去使用", nil];
//            alertView.tag=ALERTTAG_CASH;
//            [alertView show];
        }else{
            [self hiddenAwardView];
//            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"恭喜你获得优惠券，快去使用吧！" message:@"" delegate:self cancelButtonTitle:@"去主会场" otherButtonTitles:@"去使用", nil];
//            alert.tag=ALERTTAG_COUPON;
//            [alert show];
        }
    });
}

//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UleRedpacketRainClickEventType event;
//    if (alertView.tag==ALERTTAG_COUPON) {
//        if (buttonIndex==0) {
//            event = UleRedpacketRainEventToMain;
//        }else{
//            event = UleRedpacketRainEventToUse;
//        }
//    }else if (alertView.tag==ALERTTAG_CASH) {
//        if (buttonIndex==0) {
//            event = UleRedpacketRainEventOneMore;
//        }else{
//            event = UleRedpacketRainEventToUse;
//        }
//    }
//    [self hiddenAwardView];
//    if (self.clickBlock) {
//        self.clickBlock(event,nil);
//    }
//}

- (void)shareClick:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        UleRedpacketRainClickEventType event;
        if (self.awardType==UleAwardNoneType) {
            event = UleRedpacketRainEventToHomePage;
        }else if (self.awardType==UleAwardCashType){
            event = UleRedpacketRainEventToHomePage;
        }else{
            event = UleRedpacketRainEventShare;
        }
        [self hiddenAwardView];
        if (self.clickBlock) {
            self.clickBlock(event,nil);
        }
    });
}

- (void)cashBtnAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hiddenAwardView];
        if (self.clickBlock) {
            self.clickBlock(UleRedpacketRainEventToUse,nil);
        }
    });
}

- (void)showRule:(id)sender{
    
    [UleRedPacketRainRuleView showRuleViewAtRootView:self ruleHtmlPath:kRulePath];
}

#pragma mark - <Collection>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.awardDataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UleAwardConponCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"awardCell" forIndexPath:indexPath];
    UleAwardCellModel *model=self.awardDataArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - <setter and getter>

- (UIButton *)shareButton{
    if (!_shareButton) {
        CGFloat delt=0;
        if (kStatusBarHeight>20) {
            delt=24;
        }
        _shareButton=[[UIButton alloc] initWithFrame:CGRectMake(HORIZONTA(30), SCREEN_HEIGHT-HORIZONTA(70)-delt, SCREEN_WIDTH-HORIZONTA(60), HORIZONTA(50))];
        UIImage * image=LoadBundleImage(@"分享领红包");
        [_shareButton setImage:image forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _shareButton.titleLabel.font=[UIFont boldSystemFontOfSize:HORIZONTA(18)];
        [_shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)cashButton
{
    if (!_cashButton) {
        _cashButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, HORIZONTA(150), HORIZONTA(40))];
        UIImage * image=LoadBundleImage(@"右箭头");
        [_cashButton setImage:image forState:UIControlStateNormal];
        [_cashButton setTitle:@"查看我的资产" forState:UIControlStateNormal];
        [_cashButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _cashButton.titleLabel.font=[UIFont boldSystemFontOfSize:HORIZONTA(15)];
        _cashButton.imageEdgeInsets=UIEdgeInsetsMake(0, HORIZONTA(100), 0, 0);
        _cashButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, HORIZONTA(20));
        [_cashButton addTarget:self action:@selector(cashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashButton;
}


- (UICollectionView *) mCollectionView{
    if (!_mCollectionView) {
        CGFloat width=650;
        CGFloat hight=620;
        UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
        layout.itemSize=CGSizeMake(HORIZONTA750(width), HORIZONTA750(hight));
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-HORIZONTA750(width))/2.0, (SCREEN_HEIGHT-HORIZONTA750(hight))*0.4,  HORIZONTA750(width), HORIZONTA750(hight)) collectionViewLayout:layout];
        _mCollectionView.dataSource=self;
        _mCollectionView.delegate=self;
        [_mCollectionView registerClass:[UleAwardConponCell class] forCellWithReuseIdentifier:@"awardCell"];
        _mCollectionView.backgroundColor=[UIColor clearColor];
        _mCollectionView.clipsToBounds=NO;
    }
    return _mCollectionView;
}
- (UIButton *)ruleButton{
    if (!_ruleButton) {
        _ruleButton=[[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarHeight, 100, 40)];
        [_ruleButton setTitle:@"活动规则" forState:UIControlStateNormal];
        [_ruleButton setTitleColor:kRuleColor forState:UIControlStateNormal];
        _ruleButton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        [_ruleButton addTarget:self action:@selector(showRule:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ruleButton;
}
@end
