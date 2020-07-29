//
//  US_OrderCommentDetailVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/27.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderCommentDetailVC.h"
#import "US_OrderCommentViewModel.h"
#import "US_MyOrderApi.h"
#import "CommentUploadPicModel.h"

@interface US_OrderCommentDetailVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UIButton * commentBtn;
@property (nonatomic, strong) US_OrderCommentViewModel * mViewModel;
@property (nonatomic, strong) WaybillOrder *billOrder;
@property (nonatomic, strong) dispatch_group_t downloadGroup;
@property (nonatomic, assign) BOOL isUploadFaild;
@end

@implementation US_OrderCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"评价商品"];
    [self createUI];
    [self handleData];
    @weakify(self);
    self.mViewModel.sucessBlock = ^(id returnValue) {
        @strongify(self);
        [self.mTableView reloadData];
    };
}
- (void)createUI {
    [self.view sd_addSubviews:@[self.mTableView,self.commentBtn]];
    self.commentBtn.sd_layout.bottomSpaceToView(self.view,(kStatusBarHeight == 20 ? 10 : 34))
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(40);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.commentBtn,10);
}
- (void)handleData {
    self.billOrder = self.m_Params[@"waybillOrder"];
    [self.mViewModel handleOriginData:self.billOrder];
    [self startRequestCommentLabels];
}

- (void)startRequestCommentLabels{
    @weakify(self);
    [self.networkClient_Ule beginRequest:[US_MyOrderApi buildEvaluateLabelsApi] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel frechLabelsInfoDic:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
#pragma mark - <button Click>
- (void)commentClick:(id)sender{
    self.isUploadFaild=NO;
    _downloadGroup = dispatch_group_create();
    NSMutableArray * selectPicArray=[self.mViewModel getSelectedPicArray];
    if (selectPicArray.count>0) {
        //有图片先上传图片
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在上传"];
        for (int i=0 ; i<selectPicArray.count; i++) {
            dispatch_group_enter(self.downloadGroup);//进入组
            @weakify(self);
            NSDictionary * dic=selectPicArray[i];
            NSString * imageData=dic[@"imageBase64"];
            NSString * itemId=dic[@"itemId"];
            [self.networkClient_API beginRequest:[US_MyOrderApi buildUploadCommentImageData:imageData] success:^(id responseObject) {
                @strongify(self);
                
                CommentUploadPicBaseModel * baseModel = [CommentUploadPicBaseModel yy_modelWithDictionary:responseObject];
                [self.mViewModel addUploadImagePicUrlString:baseModel.data.imageUrl forItemId:itemId];
                NSLog(@"imageUrl==%@",baseModel.data.imageUrl);
                dispatch_group_leave(self.downloadGroup);
            } failure:^(UleRequestError *error) {
                @strongify(self);
                NSLog(@"failed====%@",error.error.userInfo);
                self.isUploadFaild=YES;
                dispatch_group_leave(self.downloadGroup);
            }];
        }
        
        dispatch_group_notify(self.downloadGroup, dispatch_get_main_queue(), ^{
            if (self.isUploadFaild) {
                [self.mViewModel cleanCommentPicsUrlArray];
                [UleMBProgressHUD showHUDWithText:@"上传图片失败，请重新上传" afterDelay:2];
            }else{
                [self startSubmitCommentInfor];
            }
        });
    }else{
        //没有图片的时候
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在上传"];
         [self startSubmitCommentInfor];
    }
    
}

- (void)startSubmitCommentInfor{
    UleRequest * request=[US_MyOrderApi buildCommitEscOrderId:self.billOrder.esc_orderid PrdId:[self.mViewModel getCommentProductId] Content:[self.mViewModel getCommentContent] logisticStar:[self.mViewModel getLogisticsStar] serverStar:[self.mViewModel getServersStar] productStar:[self.mViewModel getProductStar] andPicUrls:[self.mViewModel getCommentPicsHttpString]];
    @weakify(self);
    [self.networkClient_API beginRequest:request success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
        [dic setObject:@"待评论" forKey:@"orderStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self.mViewModel cleanCommentPicsUrlArray];
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}
- (UIButton *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _commentBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
        _commentBtn.layer.cornerRadius = 20;
        [_commentBtn setTitle:@"发表评价" forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (US_OrderCommentViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_OrderCommentViewModel alloc] init];
    }
    return _mViewModel;
}

@end
