//
//  US_QRShareTemplateVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_QRShareTemplateVC.h"
#import "QRShareTemplateCell.h"
#import "US_ShareApi.h"
#import "ShareTemplateModel.h"
#import "US_QRGraphShareView.h"
#import "USShareModel.h"
#import <FileController.h>
#import "ShareParseTool.h"
static CGFloat KComfirmButtonHeight = 44;

@interface US_QRShareTemplateVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView      *mCollectionView;
@property (nonatomic, strong) NSMutableArray        *listArray;
@property (nonatomic, strong) USShareModel * shareModel;
@property (nonatomic, strong) ShareTemplateList * templateModel;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@end

@implementation US_QRShareTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view sd_addSubviews:@[self.mCollectionView,self.confirmButton]];
    self.shareModel=[self.m_Params objectForKey:@"shareModel"];
    [self.uleCustemNavigationBar customTitleLabel:@"选择分享图片主题"];
    
    self.confirmButton.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, -KComfirmButtonHeight)
    .heightIs(KComfirmButtonHeight);
    
    self.mCollectionView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.confirmButton, 0);
    

    [self startRequestTemplateList];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    ShareTemplateList * selectedTemplate;
    if (self.templateModel==nil) {
        selectedTemplate=[[ShareTemplateList alloc] init];
        selectedTemplate.modelNo=@"1";
         ShareTemplateList * localTemplate=[ShareParseTool getLocalShareTemplateModel];
        if (localTemplate) {
            selectedTemplate=localTemplate;
        }
    }else{
        selectedTemplate=self.templateModel;
    }
    USShareViewBlock callBack=[self.m_Params objectForKey:@"callBackBlock"];
    [US_QRGraphShareView showQRGraphShareViewWithModel:self.shareModel withTemplate:selectedTemplate callBack:callBack];
}

#pragma mark - <network>
- (void)startRequestTemplateList{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_ShareApi buildShareTemplateListRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        ShareTemplateModel * shareTemplate=[ShareTemplateModel yy_modelWithDictionary:responseObject];
        [shareTemplate.indexInfo sortUsingComparator:^NSComparisonResult(ShareTemplateList *obj1, ShareTemplateList *obj2) {
            NSInteger num1 = [obj1.priority integerValue];
            NSInteger num2 = [obj2.priority integerValue];
            if (num1 <= num2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        //是否存在用户选择的模板
        ShareTemplateList * localTemplate=[ShareParseTool getLocalShareTemplateModel];
        //存在用户选择模板，则把它置为已选择
        for (int i=0; i<shareTemplate.indexInfo.count; i++) {
            ShareTemplateList *newList=shareTemplate.indexInfo[i];
            if ([newList._id isEqualToString:localTemplate._id]) {
                newList.cellSelected=YES;
                self.templateModel=newList;
                [self showComfirmButton:YES];
                break;
            }
        }
        self.listArray=shareTemplate.indexInfo;
        [self.mCollectionView reloadData];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:[error.error.userInfo objectForKey:NSLocalizedDescriptionKey] afterDelay:0.3];
    }];
}

#pragma mark - <CollectionView delegate and Datasource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QRShareTemplateCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setTemplateModel:self.listArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (ShareTemplateList * model in self.listArray) {
        model.cellSelected=NO;
    }
    ShareTemplateList * cellModel=self.listArray[indexPath.row];
    cellModel.cellSelected=YES;
    self.selectedIndexPath=indexPath;
    [self.mCollectionView reloadData];
    [self showComfirmButton:YES];
}

- (void)showComfirmButton:(BOOL) show{
    [UIView animateWithDuration:0.3 animations:^{
        if (show) {
            self.confirmButton.sd_layout.bottomSpaceToView(self.view, 0);
        }else{
            self.confirmButton.sd_layout.bottomSpaceToView(self.view, -44);
        }
        [self.confirmButton updateLayout];
    }];
}

#pragma mark - <Button action>
- (void)confirmBtnAction:(id)sender{
    //保存模板
    ShareTemplateList *listItem = [self.listArray objectAtIndex:self.selectedIndexPath.row];
    //记录用户选择的模板
    for (ShareTemplateList *listModel in self.listArray) {
        listModel.cellSelected=NO;
    }
    listItem.cellSelected=YES;
    self.templateModel=listItem;
    [NSKeyedArchiver archiveRootObject:self.listArray toFile:[FileController fullpathOfFilename:TemplateCachePlist]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <setter and getter>
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
        layout.itemSize=CGSizeMake((__MainScreen_Width-30)/2.0, KScreenScale(600));
        layout.minimumLineSpacing=10;
        layout.minimumInteritemSpacing=10;
        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.delegate=self;
        _mCollectionView.dataSource=self;
        [_mCollectionView registerClass:[QRShareTemplateCell class] forCellWithReuseIdentifier:@"cell"];
        _mCollectionView.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
        
    }
    return _mCollectionView;
}

-(UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        [_confirmButton setTitle:@"确认选择" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
