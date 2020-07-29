//
//  WKImagePicker.m
//  裁剪照片上传头像
//
//  Created by wangkun on 16/7/20.
//  Copyright © 2016年 ule. All rights reserved.
//

#import "USImagePicker.h"
#import "USImagePickerController.h"
#import "EditPhothViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


static USImagePicker *usImagePicker = nil;
static UIViewController *usViewController = nil;

@interface USImagePicker () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, copy) CameraFailedCallBack    cameraBlock;
@property (nonatomic, copy) PhotoAlbumCallBack  photoBlock;
@property (nonatomic, copy) ChooseCallBack chooseBlock;   //选取回调
@property (nonatomic, copy) CancelCallBack cancelBlock;   //取消回调
@end

@implementation USImagePicker

+ (void)startWKImagePicker:(UIViewController *)viewController
            cameraFailCallBack:(CameraFailedCallBack)cameraBlock
            photoAlbumFailCallBack:(PhotoAlbumCallBack)photoBlock
            chooseCallBack:(ChooseCallBack)chooseBlock
            cancelCallBack:(CancelCallBack)cancelBlock {
    
    usImagePicker = [[self alloc]initWithCameraStatusCallBack:cameraBlock photoCallBack:photoBlock  ChooseCallBack:chooseBlock cancelCallBack:cancelBlock];
    usViewController = viewController;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0)
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [usImagePicker showCameraView];
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [usImagePicker showPhotoAlbumView];
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [usImagePicker touchCancelBlock];
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [alertC addAction:action3];
        [viewController presentViewController:alertC
                                     animated:YES
                                   completion:^{
                                   }];
    }
    else
    {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:usImagePicker
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [sheet showInView:viewController.view];
    }
}

//初始化
- (instancetype)initWithCameraStatusCallBack:(CameraFailedCallBack)cameraBlock
                               photoCallBack:(PhotoAlbumCallBack)photoBlock
                              ChooseCallBack:(ChooseCallBack)chooseBlock
                        cancelCallBack:(CancelCallBack)cancelBlock {
    if (self = [super init]) {
        _cameraBlock = [cameraBlock copy];
        _photoBlock = [photoBlock copy];
        _chooseBlock = [chooseBlock copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"获取成功");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.chooseBlock) {
            self.chooseBlock(info);
        }
        usImagePicker = nil;
        usViewController = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
        usImagePicker = nil;
        usViewController = nil;
    }];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [usImagePicker showCameraView];
            break;
        case 1:
            [usImagePicker showPhotoAlbumView];
            break;
        case 2:
            [usImagePicker touchCancelBlock];
            break;
        default:
            break;
    }
}

#pragma mark - private methods
- (void)presentPickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    USImagePickerController *imagePickerC = [[USImagePickerController alloc]init];
    imagePickerC.sourceType = sourceType;
    imagePickerC.delegate = usImagePicker;
    imagePickerC.allowsEditing = YES;
    [usViewController presentViewController:imagePickerC
                                 animated:YES
                               completion:^{
                               }];
}

- (void)touchCancelBlock {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

-(void)cameraFailedBlock:(NSInteger)code{
    if (_cameraBlock) {
        _cameraBlock(code);
    }
}

-(void)photoFailedBlock{
    if (_photoBlock) {
        _photoBlock();
    }
}

-(void)showCameraView{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [usImagePicker cameraFailedBlock:1];
        return;
    }
    [EditPhothViewController requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [usImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }else{
            [usImagePicker cameraFailedBlock:2];
        }
    }];
}

-(void)showPhotoAlbumView{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    //无相册访问权限
    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        [usImagePicker photoFailedBlock];
        return;
    }
    [usImagePicker presentPickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
@end
