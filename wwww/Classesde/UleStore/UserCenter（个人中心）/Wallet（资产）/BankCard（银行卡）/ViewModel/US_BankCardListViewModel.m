//
//  US_BankCardListViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/12.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_BankCardListViewModel.h"
#import "US_WalletBindingCardModel.h"
#import "US_BankCardListCell.h"
#import "US_BankCardListCellModel.h"

@interface US_BankCardListViewModel ()

@property (nonatomic, strong) UIButton *bindingButton;
@end

@implementation US_BankCardListViewModel
//组装成sectionModel 数组用于显示
- (void)fetchBankCardListWithData:(NSDictionary *)dic{
    //每次先清空下数据
    [self.mDataArray removeAllObjects];
    US_WalletBindingCardModel * cardListData = [US_WalletBindingCardModel yy_modelWithDictionary:dic];
    if (cardListData.data.cardList.count == 0) {
        if (self.sucessBlock) {
            self.sucessBlock(self.mDataArray);
        }
        return;
    }
    UleSectionBaseModel * sectionModel = [[UleSectionBaseModel alloc] init];
    for (int i=0; i<[cardListData.data.cardList count]; i++) {
        
        US_WalletBindingCardInfo * cardInfo = [cardListData.data.cardList objectAtIndex:i];
        US_BankCardListCellModel * cellModel = [[US_BankCardListCellModel alloc] init];
        cellModel.cellName=@"US_BankCardListCell";
        if ([cardInfo.cardType isEqualToString:@"D"]) {
           NSString * string  = @"中国邮政储蓄银行  储蓄卡";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(30)] range:NSMakeRange(string.length - 3, 3)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"d9d9d9"] range:NSMakeRange(string.length - 3, 3)];
            cellModel.bankName = attributedString;
        }
        else{
            cellModel.bankName = [[NSMutableAttributedString alloc] initWithString:@"中国邮政储蓄银行"];
        }
        if (cardInfo.cardNo.length > 4) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"**** **** **** %@",[cardInfo.cardNo substringFromIndex:cardInfo.cardNo.length-4]]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(44)] range:NSMakeRange(cardInfo.cardNo.length - 4, 4)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"ffffff"] range:NSMakeRange(cardInfo.cardNo.length - 4, 4)];
            cellModel.cardNum = attributedString;
        }
        cellModel.name = cardInfo.usrName;
        cellModel.mobileNum = cardInfo.mobileNumber;
        cellModel.cardNumber = cardInfo.cardNoCipher;
        cellModel.isEditing = NO;
        [sectionModel.cellArray addObject:cellModel];
        @weakify(self);
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(cellModel);
            [self bankListCellClickWithCardInfo:cardInfo andCellModel:cellModel];
        };
    }
    [self.mDataArray addObject:sectionModel];
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)setBankCardListEdit:(BOOL)isEditing{
    UleSectionBaseModel * sectionModel = self.mDataArray.firstObject;
    for (int i=0; i<[sectionModel.cellArray count]; i++) {
        US_BankCardListCellModel * cellModel = [sectionModel.cellArray objectAtIndex:i];
        cellModel.isEditing=isEditing;
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

//cell点击
- (void)bankListCellClickWithCardInfo:(US_WalletBindingCardInfo *)cardInfo andCellModel:(US_BankCardListCellModel *)cellModel{
    if (cellModel.isEditing) {
        return;
    }
    
    if (_cellSelectBlock) {
        _cellSelectBlock(cardInfo);
    }
}

@end
