//
//  CommentAddPicView.m
//  UleApp
//
//  Created by denghuan on 2018/10/11.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "CommentAddPicView.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import <TZPhotoPickerController.h>
#import <TZImageManager.h>
#import "Ule_RSABase64.h"
#include "sys/stat.h"
#import "MBProgressHUD.h"
#import "NSArray+ReplaceObjectAtIndex.h"

static const char associatedkey;
#define ORIGINAL_MAX_WIDTH 640.0f
#define kCommentPicHeight 64
#define kCommentPicWidth 74
#define kMaginOffsetX 6

@implementation PicView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self sd_addSubviews:@[self.picImageView, self.cancelBtn, self.countLabel]];
    self.picImageView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
    self.cancelBtn.sd_layout
    .rightSpaceToView(self, -10)
    .topSpaceToView(self, -10)
    .widthIs(20)
    .heightIs(20);
    
    self.countLabel.sd_layout
    .rightSpaceToView(self, 2)
    .leftSpaceToView(self, 2)
    .bottomSpaceToView(self, 0)
    .heightIs(25);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (void)cancelSeletedPic{
    NSLog(@"取消该图片");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSelectedPic:)]) {
        [self.delegate didCancelSelectedPic:self.tag];
    }
}

#pragma mark - setter and getter
- (UIImageView *)picImageView {
    if (_picImageView == nil) {
        _picImageView = [[UIImageView alloc] init];
    }
    return _picImageView;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"comment_btn_closepic"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelSeletedPic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UILabel *)countLabel {
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:13];
    }
    return _countLabel;
}

@end


@implementation CommentAddPicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _picsArray = [NSMutableArray array];
        _imagePickerVcSelectedAssetsArray = [NSMutableArray array];
        self.contentSize = CGSizeMake(__MainScreen_Width-20, kCommentPicWidth);
    }
    return self;
}

- (void)reloadPicsWithModel:(CommentTextCellModel *)model {
    
    if (!self.model) {
        self.model = model;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger picsCount = self.picsArray.count;
    CGFloat contentSizeWidth = __MainScreen_Width-20;
    if (picsCount>0 && picsCount<5) {
        if ((picsCount+1) * kCommentPicWidth + picsCount*kMaginOffsetX > contentSizeWidth) {
            contentSizeWidth = (picsCount+1) * kCommentPicWidth + picsCount*kMaginOffsetX;
        }
    } else if (picsCount == 5) {
        contentSizeWidth = 394;
    }
    self.contentSize = CGSizeMake(contentSizeWidth, 74);
    
    NSInteger count;
    NSString * countLabelText = @"添加图片";
    if (self.picsArray && self.picsArray.count>0) {
        if (self.picsArray.count == 5) {
            count = self.picsArray.count;
        } else {
            count = self.picsArray.count+1;
        }
        countLabelText = [NSString stringWithFormat:@"%ld/5", self.picsArray.count];
    } else {
        count = 1;
    }
    for (int i = 0; i<count; i++) {
        PicView * picview = [[PicView alloc] initWithFrame:CGRectMake(0+(kCommentPicWidth+kMaginOffsetX)*i, 10, kCommentPicHeight, kCommentPicHeight)];
        picview.tag = 10000+i;
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAddOrShowPicAction:)];
        self.userInteractionEnabled = YES;
        [picview addGestureRecognizer:tapGes];
        if (i == count-1 && self.picsArray.count !=5) {
            picview.picState = PicViewStateAddPic;
            picview.picImageView.image = [UIImage bundleImageNamed:@"comment_btn_defaultAdd"];
            picview.cancelBtn.hidden = YES;
            picview.countLabel.text = countLabelText;
            picview.countLabel.hidden = NO;
        } else {
            picview.picState = PicViewStateShowPic;
            if (self.picsArray.count>0 && [self.picsArray objectAtIndex:i]) {
                picview.picImageView.image = [self.picsArray objectAtIndex:i];
            }
            picview.cancelBtn.hidden = NO;
            picview.countLabel.hidden = YES;
        }
        picview.delegate = self;
        [self addSubview:picview];
    }
}

//添加或者展示图片
- (void)tapToAddOrShowPicAction:(UIGestureRecognizer *)recognizer{
    PicView * picview=(PicView *)recognizer.view;
    if (picview.picState == PicViewStateAddPic) {
        NSLog(@"添加图片");
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照片" otherButtonTitles:@"我的相册", nil];
        [actionsheet showInView:self];
    } else if (picview.picState == PicViewStateShowPic) {
        NSLog(@"展示图片");
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = picview.tag - 10000;
        browser.sourceImagesContainerView = picview;
        browser.imageCount = self.picsArray.count;
        browser.delegate = self;
        browser.showSaveButton = NO;
        [browser show];
    }
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIImage * placeHolder=self.picsArray[index];
    return placeHolder;
}

//删除图片
- (void)didCancelSelectedPic:(NSInteger)tag{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确认删除图片吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    objc_setAssociatedObject(alert, &associatedkey, [NSString stringWithFormat:@"%ld", tag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString * tag = objc_getAssociatedObject(alertView, &associatedkey);
        if ([tag integerValue]-10000 < self.picsArray.count) {
            [self.picsArray removeObjectAtIndex:[tag integerValue]-10000];
        }
        if ([tag integerValue]-10000 < self.imagePickerVcSelectedAssetsArray.count) {
            [self.imagePickerVcSelectedAssetsArray removeObjectAtIndex:[tag integerValue]-10000];
        }
        if (self.model.selectCommentPicsArray) {
            [self.model.selectCommentPicsArray removeAllObjects];
        }
        if (self.model.selectCommentPicHttpsArray) {
            [self.model.selectCommentPicHttpsArray removeAllObjects];
        }
        for (int i=0; i<self.picsArray.count; i++) {
            NSString * picData=[self uploadPictureWithImage:self.picsArray[i]];
            [self.model.selectCommentPicsArray addObject:picData];
        }
        [self reloadPicsWithModel:self.model];
//        NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[self picStringArrayFromImageArray:self.picsArray],@"picsArray", self.model.itemId,@"itemId", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"frechCommentPicsNotification" object:info];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 拍照
    if (buttonIndex == 0) {
        [self userHeadFromCamera];
    }
    // 相册
    else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

/** 拍照 */
- (void)userHeadFromCamera {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerControler = [[UIImagePickerController alloc]init];
        imagePickerControler.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerControler.delegate = self;
        [[UIViewController currentViewController] presentViewController:imagePickerControler animated:YES completion:nil];
    }
    else {
        [UleMBProgressHUD showHUDWithText:@"该设备不支持拍照" afterDelay:1.2f];
        return;
    }
}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary*) info {
    [reader dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        if (self.picsArray) {
            [self.picsArray addObject:portraitImg];
        } else {
            [self.picsArray arrayByAddingObject:portraitImg];
        }

        if (self.model.selectCommentPicsArray) {
            [self.model.selectCommentPicsArray removeAllObjects];
        }
        if (self.model.selectCommentPicHttpsArray) {
            [self.model.selectCommentPicHttpsArray removeAllObjects];
        }
        for (int i=0; i<self.picsArray.count; i++) {
            NSString * picData=[self uploadPictureWithImage:self.picsArray[i]];
            [self.model.selectCommentPicsArray addObject:picData];
        }
//        NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[self picStringArrayFromImageArray:self.picsArray],@"picsArray", self.model.itemId,@"itemId", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"frechCommentPicsNotification" object:info];
        [self reloadPicsWithModel:self.model];
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        [self reloadPhotoArrayWithMediaType:type WithImage:portraitImg];
    }];
}

- (void)reloadPhotoArrayWithMediaType:(NSString *)mediaType WithImage:(UIImage *)image{
    if (image) {
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(PHAsset *asset, NSError *error) {
            [[TZImageManager manager] getCameraRollAlbum:self.imagePickerVc.allowPickingVideo allowPickingImage:self.imagePickerVc.allowPickingImage needFetchAssets:NO completion:^(TZAlbumModel *model) {
                
                [[TZImageManager manager] getAssetsFromFetchResult:model.result completion:^(NSArray<TZAssetModel *> *models) {
                    TZAssetModel *assetModel;
                    if (self.imagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    } else {
                        assetModel = [models firstObject];
                    }
                    if (self.imagePickerVc.maxImagesCount <= 1) {
                        return;
                    }
                    if (self.imagePickerVc.selectedModels.count < self.imagePickerVc.maxImagesCount) {
                        if ([mediaType isEqualToString:@"public.movie"] && !self.imagePickerVc.allowPickingMultipleVideo) {
                            // 不能多选视频的情况下，不选中拍摄的视频
                        } else {
                            assetModel.isSelected = YES;
                            [self.imagePickerVc addSelectedModel:assetModel];
                            [self.imagePickerVcSelectedAssetsArray addObject:assetModel];
                        }
                    }
                }];
            }];
        }];
    }
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/** 相册 */
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
    @weakify(self);
    // 你可以通过block或者代理，来得到用户选择的照片.
    [self.imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        NSLog(@"选择的图片：%@", photos);
        [self.picsArray removeAllObjects];
        [self.picsArray addObjectsFromArray:photos];
        
        [self.imagePickerVcSelectedAssetsArray removeAllObjects];
        
        for (PHAsset * asset in assets) {
            
            TZAssetModel *model = [[TZAssetModel alloc] init];
            model.asset = asset;
            model.isSelected = YES;
            model.type = TZAssetModelMediaTypePhoto;
            [self.imagePickerVcSelectedAssetsArray addObject:model];
        }
        if (self.model.selectCommentPicsArray) {
            [self.model.selectCommentPicsArray removeAllObjects];
        }
        if (self.model.selectCommentPicHttpsArray) {
            [self.model.selectCommentPicHttpsArray removeAllObjects];
        }
        for (int i=0; i<self.picsArray.count; i++) {
            NSString * picData=[self uploadPictureWithImage:self.picsArray[i]];
            [self.model.selectCommentPicsArray addObject:picData];
        }
//        NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:[self picStringArrayFromImageArray:self.picsArray],@"picsArray", self.model.itemId,@"itemId", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"frechCommentPicsNotification" object:info];
        [self reloadPicsWithModel:self.model];
        
    }];
    
    [self.imagePickerVc.selectedModels removeAllObjects];
    if (self.imagePickerVcSelectedAssetsArray.count>0) {
        for (int i=0; i<self.imagePickerVcSelectedAssetsArray.count; i++) {
            [self.imagePickerVc addSelectedModel:self.imagePickerVcSelectedAssetsArray[i]];
        }
    }
    
    //将photoPickerVC的_models属性设为空，使其在villappear的时候调用fetchAssetModels方法，起到刷新数据的作用，使imagePickerVc显示的选中图片为最新数据
    if ([self.imagePickerVc.topViewController isKindOfClass:[TZPhotoPickerController class]]) {
        TZPhotoPickerController * photoPickerVC=(TZPhotoPickerController *)self.imagePickerVc.topViewController;
        [photoPickerVC setValue:nil forKeyPath:@"_models"];
    }
    
    [[UIViewController currentViewController] presentViewController:self.imagePickerVc animated:YES completion:nil];
   
}

#pragma mark - 上传图片前UIImage转NSString
- (NSMutableArray *)picStringArrayFromImageArray:(NSMutableArray *)array{
    NSMutableArray * stringArray = [NSMutableArray array];
    for (UIImage * image in array) {
        [stringArray addObject:[self uploadPictureWithImage:image]];
    }
    return stringArray;
}

- (NSString *)uploadPictureWithImage:(UIImage *)image{
    NSData *imageData =[self compressImageQuality:image toByte:(1024*1024)*1];
    NSString *picStream = [Ule_RSABase64 ule_encode:imageData];

    return picStream;
}
- (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    while (data.length > maxLength && compression > 0) {
        compression -= 0.01;
        data = UIImageJPEGRepresentation(image, compression); // When compression less than a value, this code dose not work
    }
    return data;
}

#pragma mark  -图片长度
- (long long) fileSizeAtPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

#pragma mark - setter and getter
- (TZImagePickerController *)imagePickerVc{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:4 delegate:nil];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
        _imagePickerVc.isSelectOriginalPhoto = YES;
        _imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
        // 2. 在这里设置imagePickerVc的外观
        _imagePickerVc.navigationBar.barTintColor=[UIColor whiteColor];
        [_imagePickerVc setNaviTitleColor:[UIColor blackColor]];
        [_imagePickerVc setBarItemTextColor:[UIColor blackColor]];
        [_imagePickerVc setIsStatusBarDefault:YES];
        // 3. 设置是否可以选择视频/图片/原图
        _imagePickerVc.allowPickingVideo = NO;
        _imagePickerVc.allowPickingImage = YES;
        _imagePickerVc.allowPickingOriginalPhoto = YES;
        // 4. 照片排列按修改时间升序
        _imagePickerVc.sortAscendingByModificationDate = NO;
#pragma mark - 到这里为止
    }
    return _imagePickerVc;
}

@end
