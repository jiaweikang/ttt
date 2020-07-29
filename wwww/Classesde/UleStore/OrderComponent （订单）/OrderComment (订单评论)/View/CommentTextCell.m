//
//  CommentTextCell.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/20.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "CommentTextCell.h"
#import <UIView+SDAutoLayout.h>
#import "CommentStarView.h"
#import "LPlaceholderTextView.h"
#import "TagListView.h"
#import "CommentTextCellModel.h"
#import "CommentAddPicView.h"

#define kMaginOffsetX 10

@interface CommentTextCell ()<UITextViewDelegate,CommentStarViewDelegate>
@property (nonatomic, strong) UIImageView * pdImageView;
@property (nonatomic, strong) CommentStarView * productStarView;
@property (nonatomic, strong) LPlaceholderTextView * inputTextView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIView * lineView2;
@property (nonatomic, strong) CommentAddPicView * addCommentPicView;
@property (nonatomic, strong) TagListView * labelsView;
@property (nonatomic, strong) CommentTextCellModel * model;

@end

@implementation CommentTextCell


#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self DidNotification];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.pdImageView, self.productStarView, self.inputTextView, self.addCommentPicView, self.lineView, self.labelsView, self.lineView2]];
    
    self.pdImageView.sd_layout
    .leftSpaceToView(self.contentView, kMaginOffsetX)
    .topSpaceToView(self.contentView, kMaginOffsetX)
    .widthIs(60)
    .heightIs(60);
    
    self.productStarView.sd_layout
    .centerYEqualToView(self.pdImageView)
    .leftSpaceToView(self.pdImageView, 16)
    .rightSpaceToView(self.contentView, kMaginOffsetX)
    .heightIs(30);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.pdImageView, kMaginOffsetX)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0.5);
    
    self.inputTextView.sd_layout
    .leftSpaceToView(self.contentView, kMaginOffsetX)
    .topSpaceToView(self.pdImageView, 2*kMaginOffsetX)
    .rightSpaceToView(self.contentView, kMaginOffsetX)
    .heightIs(70);
    
    self.addCommentPicView.sd_layout
    .leftSpaceToView(self.contentView, kMaginOffsetX)
    .topSpaceToView(self.inputTextView, 0)
    .rightSpaceToView(self.contentView, kMaginOffsetX)
    .heightIs(74);
    
    self.lineView2.sd_layout
    .leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.addCommentPicView, kMaginOffsetX)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0.5);
    
    self.labelsView.sd_layout
    .leftSpaceToView(self.contentView, kMaginOffsetX)
    .topSpaceToView(self.addCommentPicView, kMaginOffsetX)
    .rightSpaceToView(self.contentView, kMaginOffsetX)
    .heightIs(32);
    
    [self setupAutoHeightWithBottomView:self.labelsView bottomMargin:kMaginOffsetX];
    __weak __typeof(self)weakSelf = self;
    self.labelsView.clickTagBlock = ^(NSString *tag) {
        [weakSelf.model.selectLabelsArray addObject:tag];
        weakSelf.inputTextView.text = [weakSelf.inputTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@！",tag]];
        weakSelf.model.commentInfo = weakSelf.inputTextView.text;
    };
    
    self.labelsView.clickCancelTagBlock = ^(NSString *tag) {
        [weakSelf.model.selectLabelsArray removeObject:tag];
        weakSelf.inputTextView.text = [weakSelf.inputTextView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@！",tag] withString:@""];
        weakSelf.model.commentInfo = weakSelf.inputTextView.text;
    };
    
    self.labelsView.showAlertBlock = ^(NSString *alertText) {
           [UleMBProgressHUD showHUDWithText:alertText afterDelay:1.2];
    };
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(CommentTextCellModel *)model {
    _model = model;
    [self.pdImageView yy_setImageWithURL:[NSURL URLWithString:_model.imgeUrl] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    self.inputTextView.text = _model.commentInfo;
    [self.productStarView setUpStar:[_model.productStars integerValue]];
    [self.addCommentPicView reloadPicsWithModel:model];
    if (self.labelsView.tagArray.count==0) {
        [self.labelsView addTags:model.labelsArray];
    }
    self.labelsView.sd_layout.heightIs(self.labelsView.size.height);
    [self.labelsView updateLayout];
    [self setupAutoHeightWithBottomView:self.labelsView bottomMargin:kMaginOffsetX];
    [self.labelsView setTagSelected:model.selectLabelsArray];
}

- (void)didSetCommentStars:(NSString *)stars{
    _model.productStars=stars;
}

- (void)DidNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardDidShow:(NSNotification *)notify {
    
}

- (void)handleKeyboardWillHide:(NSNotification *)notfiy {
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.scrollIndicatorInsets = contentInsets;
}

//跳转到当前列
- (void)scrollToRowAtCurrentIndex {
//    [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 246, 0);
//    self.tableView.contentInset = contentInsets;
//    [self scrollToRowAtCurrentIndex];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"End textView ==");
    _model.commentInfo = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - setter and getter
- (UIImageView *)pdImageView {
    if (!_pdImageView) {
        _pdImageView = [[UIImageView alloc] init];
        _pdImageView.layer.borderWidth = 0.5;
        _pdImageView.layer.borderColor = [[UIColor convertHexToRGB:@"c8c7cc"] CGColor];
    }
    return _pdImageView;
}

- (CommentStarView *)productStarView {
    if (!_productStarView) {
        _productStarView = [[CommentStarView alloc] initWithFrame:CGRectZero andTitle:@"商品评价" andType:@"0"];
        _productStarView.delegate = self;
    }
    return _productStarView;
}

- (LPlaceholderTextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[LPlaceholderTextView alloc] init];
        _inputTextView.placeholderText = @"亲，快来写下你的购物体会和使用感受吧~";
        _inputTextView.font = [UIFont systemFontOfSize:14.0];
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeyDone;
        _inputTextView.textColor = [UIColor convertHexToRGB:@"333333"];
        [_inputTextView setBackgroundColor:[UIColor whiteColor]];
    }
    return _inputTextView;
}

- (CommentAddPicView *)addCommentPicView {
    if (!_addCommentPicView) {
        _addCommentPicView = [[CommentAddPicView alloc] initWithFrame:CGRectZero];
    }
    return _addCommentPicView;
}

- (TagListView *)labelsView {
    if (!_labelsView) {
        _labelsView = [[TagListView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width-kMaginOffsetX*2, 0)];
        _labelsView.isSort = NO;
        _labelsView.tagMargin = 6;
        _labelsView.tagCornerRadius = 13.5;
        _labelsView.borderWidth = 0.5;
        _labelsView.tagFont = [UIFont systemFontOfSize:13];
        _labelsView.tagColor = [UIColor convertHexToRGB:@"666666"];
        _labelsView.borderColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _labelsView.tagBackgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _labelsView.selectedTagBackgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
        _labelsView.selectedTagColor = [UIColor convertHexToRGB:@"ffffff"];
        _labelsView.selectedBorderColor = [UIColor convertHexToRGB:@"ef3b39"];
        _labelsView.canTouchNum = 3;
    }
    return _labelsView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setBackgroundColor:[UIColor convertHexToRGB:@"e5e5e5"]];
    }
    return _lineView;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        [_lineView2 setBackgroundColor:[UIColor convertHexToRGB:@"e5e5e5"]];
    }
    return _lineView2;
}

@end
