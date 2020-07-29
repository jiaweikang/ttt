//
//  US_RewardChooseBtn.m
//  u_store
//
//  Created by mac_chen on 2019/6/26.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_RewardChooseBtn.h"

static const NSArray    *titles;

@interface US_RewardChooseBtn ()
@property (nonatomic, strong) NSMutableArray    *btnsArray;
@property (nonatomic, strong) UIView        *lineView;//底部线条
@property (nonatomic, strong) UIButton      *selectedBtn;
@property(nonatomic, weak) id<ChooseBtnViewDelegate>topViewDelegate;

@end

@implementation US_RewardChooseBtn

+(void)initialize
{
    if (self != [US_RewardChooseBtn class])
        return;
    
    titles = @[@"全部",@"收入",@"支出"];
}

+(US_RewardChooseBtn *)topViewWithDelegate:(id<ChooseBtnViewDelegate>)delegate frame:(CGRect)frame
{
    return [[self alloc]initWithDelegate:delegate frame:frame];
}

-(instancetype)initWithDelegate:(id<ChooseBtnViewDelegate>)delegate frame:(CGRect)frame{
    if (self = [super init]) {
        _topViewDelegate = delegate;
        _btnsArray = [NSMutableArray array];
        self.frame = frame;
        [self setUI];
    }
    return self;
}

-(void)selectBtnAtIndex:(NSInteger)index
{
    for (UIButton *btn in _btnsArray) {
        if (btn.tag==index) {
            [self btnAction:btn];
        }
    }
}

//
-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenScale(96), __MainScreen_Width, 1)];
    bottomView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    [self addSubview:bottomView];
    //选择按钮
    CGFloat btnW = __MainScreen_Width/titles.count;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
        [btn setFrame:CGRectMake(i*btnW, 0, btnW, KScreenScale(96))];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnsArray addObject:btn];
        
    }
    [self addSubview:self.lineView];
    [self layoutLineWidth:titles[0]];
}



-(void)btnAction:(UIButton *)sender{
    if (_topViewDelegate&&[_topViewDelegate respondsToSelector:@selector(topViewDidSelectAtIndex:)]) {
        [_topViewDelegate topViewDidSelectAtIndex:sender.tag];
    }
    
    
    if (sender == _selectedBtn) return;
    [sender setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
    if (_selectedBtn) {
        [_selectedBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    }
    _selectedBtn = sender;
    [self layoutLineWidth:sender.titleLabel.text];
    [self displayLineView:sender];
}

-(void)displayLineView:(UIButton *)sender{
//    [UIView animateWithDuration:0.3 animations:^{
        _lineView.center = CGPointMake(sender.center.x, _lineView.center.y);
//    } completion:^(BOOL finished) {
//    }];
}

- (void)layoutLineWidth:(NSString *)title
{
    CGFloat lineWidth = [title widthForFont:[UIFont systemFontOfSize:KScreenScale(30)]];
    _lineView.frame = CGRectMake(0, KScreenScale(90), lineWidth, KScreenScale(6));
}

#pragma mark - getter
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.frame = CGRectMake(0, KScreenScale(90), KScreenScale(48), KScreenScale(6));
        _lineView.layer.cornerRadius = KScreenScale(3);
        _lineView.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
