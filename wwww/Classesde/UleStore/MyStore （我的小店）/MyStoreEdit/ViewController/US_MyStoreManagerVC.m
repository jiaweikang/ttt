//
//  US_MyStoreManagerVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_MyStoreManagerVC.h"
#import "UleBaseViewModel.h"
#import "US_MystoreManangerApi.h"
#import "FindStoreInfoModel.h"
#import "US_StoreManagerCellModel.h"
#import "USImagePicker.h"
#include "sys/stat.h"
#import <NSData+Base64.h>
#import "UserHeadImg.h"
#import "UleModulesDataToAction.h"
#import "US_HomeBtnData.h"
#import "DeviceInfoHelper.h"
@interface US_MyStoreManagerVC ()
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_StoreManagerCellModel * onecellModel;
@property (nonatomic, strong) US_StoreManagerCellModel * twoellModel;
@property (nonatomic, strong) US_StoreManagerCellModel * threellModel;
@property (nonatomic, copy) NSString * storeName;
@property (nonatomic, copy) NSString *storeNameStandard;
@end

@implementation US_MyStoreManagerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else{
        [self.uleCustemNavigationBar customTitleLabel:@"小店设置"];
    }
    if ([US_UserUtility sharedLogin].myStoreLink.length>0) {
        self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    }
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self loadCellData];
    [self startGetStoreInfor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storeInfoChanged:) name:Notify_EditStoreInfo object:nil];
}

- (void)storeInfoChanged:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        self.threellModel.rightTitle=[US_UserUtility sharedLogin].m_storeDesc;
        self.storeName=@"";
        if ([US_UserUtility sharedLogin].m_stationName && [US_UserUtility sharedLogin].m_stationName.length>0){
            self.storeName = [US_UserUtility sharedLogin].m_stationName;
        }else {
            self.storeName = [NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
        }
        self.twoellModel.rightTitle=self.storeName;
        NSString * headImage=userInfo[@"headImage"];
        if (headImage&&headImage.length>0) {
            self.onecellModel.imagePath=headImage;
        }
        [self.mTableView reloadData];
    });
}


- (void)loadCellData{
    self.storeNameStandard = [self.m_Params objectForKey:@"storeNameStandard"]?[self.m_Params objectForKey:@"storeNameStandard"]:@"";
    self.storeName=@"";
    if ([US_UserUtility sharedLogin].m_stationName && [US_UserUtility sharedLogin].m_stationName.length>0){
        self.storeName = [US_UserUtility sharedLogin].m_stationName;
    }else {
        self.storeName = [NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
    }
    UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
    US_StoreManagerCellModel * oneCell=[[US_StoreManagerCellModel alloc] initWithCellName:@"US_StoreManagerCell"];
    oneCell.imagePath=[US_UserUtility sharedLogin].m_userHeadImgUrl;
    oneCell.leftTitle=@"";
    oneCell.rightTitle=@"店铺LOGO";
    oneCell.cellType=US_StoreManagerCellType0;
    self.onecellModel=oneCell;
    @weakify(self);
    oneCell.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self showImagePickVC];
    };
    
    
    US_StoreManagerCellModel * twoCell=[[US_StoreManagerCellModel alloc] initWithCellName:@"US_StoreManagerCell"];
    twoCell.imagePath=@"mystore_icon_name";
    twoCell.leftTitle=@"店铺名";
    twoCell.rightTitle=self.storeName;
    twoCell.cellType=US_StoreManagerCellType1;
    self.twoellModel=twoCell;
    twoCell.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        NSMutableDictionary *params = @{@"editType":@"0",@"storeName":self.storeName,@"storeNameStandard":self.storeNameStandard}.mutableCopy;
        [self pushNewViewController:@"US_EditStoreNameAndShareVC" isNibPage:NO withData:params];
    };
    
    US_StoreManagerCellModel * threeCell=[[US_StoreManagerCellModel alloc] initWithCellName:@"US_StoreManagerCell"];
    threeCell.imagePath=@"mystore_icon_share";
    threeCell.leftTitle=@"店铺分享介绍";
    threeCell.cellType=US_StoreManagerCellType2;
    self.threellModel=threeCell;
    threeCell.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        NSMutableDictionary *params = @{@"editType":@"1",@"storeName":self.storeName,@"storeNameStandard":NonEmpty(self.threellModel.rightTitle)}.mutableCopy;
        [self pushNewViewController:@"US_EditStoreNameAndShareVC" isNibPage:NO withData:params];
    };
    sectionModel.cellArray=@[oneCell,twoCell,threeCell].mutableCopy;
    self.mViewModel.mDataArray=@[sectionModel].mutableCopy;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)dealloc{
    NSLog(@"--%s--",__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - <UITableVewCell click Event>
- (void)showImagePickVC{
    @weakify(self);
    [USImagePicker startWKImagePicker:self cameraFailCallBack:^(NSInteger code){
        @strongify(self);
        switch (code) {
            case 1:
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"该设备不支持拍照" afterDelay:1.5];
                break;
            case 2:
                //相机权限不通过
                [self showAlertNormal:[NSString stringWithFormat:@"相机开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"相机\">\"%@\"", [DeviceInfoHelper getAppName]]];
                break;
            default:
                break;
        }
    } photoAlbumFailCallBack:^{
        //相册权限不通过
        [self showAlertNormal:[NSString stringWithFormat:@"相册开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"照片\">\"%@\"",[DeviceInfoHelper getAppName]]];
    } chooseCallBack:^(NSDictionary<NSString *,id> *info) {
        if(![[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"只能上传图片" afterDelay:1.5];
            return;
        }
        UIImage *original = [info objectForKey:UIImagePickerControllerEditedImage];
        [self uploadPhotoImage:original];
    } cancelCallBack:^{
    }];
}

#pragma mark - <http>
- (void)startGetStoreInfor{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    [self.networkClient_API beginRequest:[US_MystoreManangerApi buildFindStoreInfoReqeust] success:^(id responseObject) {
        FindStoreInfoModel *model=[FindStoreInfoModel yy_modelWithDictionary:responseObject];
        NSString *storeDesStr=model.data.store.storeDescription;
        if (!storeDesStr||storeDesStr.length==0) {
            storeDesStr=@"有一家不错的店铺！分享给你们";
        }
        self.threellModel.rightTitle=storeDesStr;
        [self.mTableView reloadData];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        NSLog(@"==failed===");
        [self showErrorHUDWithError:error];
    }];
}

- (void)uploadPhotoImage:(UIImage *)image{
    //将截好的图片存到本地
    NSError *err;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&err];
    }
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
    NSData *imageData;
    if([self fileSizeAtPath:filePath] > 512*512)
    {
        imageData = UIImageJPEGRepresentation(image, 512*512/[self fileSizeAtPath:filePath]);
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    NSString *hash = [imageData base64EncodedString];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在上传头像"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MystoreManangerApi buildUploadImageWithStreamData:hash] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"上传成功" afterDelay:2];
         UserHeadImg *headImg = [UserHeadImg yy_modelWithDictionary:responseObject];
        NSString *imageLink=headImg.data.imageUrl?headImg.data.imageUrl:headImg.data.picUrl;
        self.onecellModel.imagePath=imageLink;
        [US_UserUtility saveUserHeadImgUrl:imageLink];
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

//图片长度
- (long long) fileSizeAtPath:(NSString*) filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

#pragma mark - <button Action>
- (void)rightButtonAction:(UIButton *)sender{
    HomeBtnItem * item=[[HomeBtnItem alloc] init];
    item.ios_action=[US_UserUtility sharedLogin].myStoreLink;
    UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
    [self pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}


#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
    }
    return _mTableView;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        _rightButton.adjustsImageWhenHighlighted=NO;
        _rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_rightButton setTitle:@"浏览小店" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

@end
