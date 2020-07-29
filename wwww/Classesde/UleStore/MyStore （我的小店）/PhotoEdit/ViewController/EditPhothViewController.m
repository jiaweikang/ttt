//
//  EditPhothViewController.m
//  自定义相机测试
//
//  Created by chenxiaoqiang on 2/14/14.
//  Copyright (c) 2014 ule. All rights reserved.
//

#import "EditPhothViewController.h"
#import "EditPhotoView.h"
#import <AVFoundation/AVFoundation.h>
#import<AssetsLibrary/AssetsLibrary.h>


@implementation EditPhothViewController
@synthesize image,imageView,cutSize,cutRect,lastScale,bkButton,useButton,centerText,saveUIImageView,delegate,isCamera;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc]init];
    CGFloat width = __MainScreen_Width;
    CGFloat height = self.image.size.height/self.image.size.width * __MainScreen_Width;
    imageView.image = self.image;
    imageView.frame = CGRectMake(0, 0, width, height);
    imageView.center = CGPointMake(__MainScreen_Width/2, __MainScreen_Height/2);
    [self.view addSubview:imageView];
    
    EditPhotoView *editView = [[EditPhotoView alloc]initWithFrame:self.view.bounds andSizeForChangeView:cutSize];
    editView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    editView.tag = 00001;
    [self.view addSubview:editView];
    
    cutRect = CGRectMake((CGRectGetWidth(self.view.bounds) - cutSize.width)/2, (CGRectGetHeight(self.view.bounds) - cutSize.height)/2, cutSize.width, cutSize.height);
    
    UIPanGestureRecognizer *panGesTure = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureMethod:)];
    [self.view addGestureRecognizer:panGesTure];
    
    UITapGestureRecognizer *tapGesTure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesTureMethod:)];
    tapGesTure.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesTure];
    
    UIPinchGestureRecognizer *pinchGesTure = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureMethod:)];
    [self.view addGestureRecognizer:pinchGesTure];
    
    [self addSubForToolBar];
}
- (void)addSubForToolBar
{
    saveUIImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 53, CGRectGetWidth(self.view.bounds), 53)];
    saveUIImageView.backgroundColor = [UIColor whiteColor];
    saveUIImageView.userInteractionEnabled = YES;
    [self.view addSubview:saveUIImageView];
    
    bkButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 6.5, 54.5, 40)];
    bkButton.layer.borderColor = [UIColor blackColor].CGColor;
    bkButton.layer.borderWidth = 1.0f;
    bkButton.layer.cornerRadius = 3.0;
    [bkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bkButton setTitle:@"取消" forState:UIControlStateNormal];
    [bkButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchDown];
    [saveUIImageView addSubview:bkButton];

    centerText = [[UILabel alloc]initWithFrame:CGRectZero];
    centerText.textAlignment = NSTextAlignmentCenter;
    centerText.text = @"移动和缩放";
    centerText.backgroundColor = [UIColor clearColor];
    [centerText sizeToFit];
    centerText.textColor = [UIColor blackColor];
    centerText.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(saveUIImageView.frame)/2);
    [saveUIImageView addSubview:centerText];

    useButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 15 - 54.5, 6.5, 54.5, 40)];
    useButton.backgroundColor = [UIColor redColor];
    useButton.layer.borderColor = [UIColor blackColor].CGColor;
    useButton.layer.borderWidth = 1.0f;
    useButton.layer.cornerRadius = 3.0;
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useButton setTitle:@"使用" forState:UIControlStateNormal];
    [useButton addTarget:self action:@selector(useButtonPress:) forControlEvents:UIControlEventTouchDown];
    [saveUIImageView addSubview:useButton];
}

- (void)backButtonPress:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
//        [US_UserUtility shareLogin].presentController = NO;
    }];
}

- (void)useButtonPress:(UIButton *)sender
{
    EditPhotoView *edit = (EditPhotoView *)[self.view viewWithTag:00001];
    [edit removeFromSuperview];
    
    UIGraphicsBeginImageContext(self.view.frame.size); //currentView 当前的view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect defaultRect     = cutRect;
    CGImageRef imageRef    = viewImage.CGImage;
    CGImageRef newCGImage = CGImageCreateWithImageInRect(imageRef, defaultRect);
    UIImage *newImage = [UIImage imageWithCGImage:newCGImage];
    CGImageRelease(newCGImage);
    
    //判断是不是刚拍的，如果是就保存到相册。
    if(isCamera)
    {
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    }
    
    [self.delegate EditPhotoMethod:newImage];
    [self dismissViewControllerAnimated:YES completion:^{
//        [US_UserUtility shareLogin].presentController = NO;
    }];
}

- (void)panGestureMethod:(UIPanGestureRecognizer *)sender
{
    CGPoint panpoint = [sender translationInView:self.view];
    
    float image_width  = CGRectGetWidth(imageView.frame);
    float image_heitht = CGRectGetHeight(imageView.frame);
    float image_x      = CGRectGetMinX(imageView.frame);
    float image_y      = CGRectGetMinY(imageView.frame);
    float min_x        = CGRectGetMinX(cutRect);
    float min_y        = CGRectGetMinY(cutRect);
    float max_x        = CGRectGetMaxX(cutRect);
    float max_y        = CGRectGetMaxY(cutRect);
    

    panpoint.x = panpoint.x + image_x;
    if(panpoint.x >  min_x)
    {
        panpoint.x = min_x;
    }
    else if(panpoint.x <= max_x - image_width)
    {
        panpoint.x = max_x - image_width;
    }

    panpoint.y = panpoint.y + image_y;
    if(panpoint.y > min_y)
    {
        panpoint.y = min_y;
    }
    else if(panpoint.y <= max_y - image_heitht)
    {
        panpoint.y = max_y - image_heitht;
    }
    
    imageView.frame = CGRectMake(panpoint.x, panpoint.y ,image_width, image_heitht);
    panpoint = CGPointMake(0, 0);
    [sender setTranslation:panpoint inView:self.view];
}

- (void)tapGesTureMethod:(UITapGestureRecognizer *)sender
{
    CGRect frame = imageView.frame;
    
    if((int)frame.size.width == (int)self.view.bounds.size.width)
    {
        frame.size.width  = self.image.size.width;
        frame.size.height = self.image.size.height;
    }
    else if((int)frame.size.width == (int)self.view.bounds.size.width - 1)
    {
        frame.size.width  = self.image.size.width;
        frame.size.height = self.image.size.height;
    }
    else
    {
        frame.size.width  = self.view.bounds.size.width;
        frame.size.height = self.view.bounds.size.height;
    }
    frame.origin.x = 0;
    frame.origin.y = 0;
    imageView.frame   = frame;
}

- (void)pinchGestureMethod:(UIPinchGestureRecognizer *)sender
{
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        lastScale = 1.0;
        //开始的时候讲scale置为1.0防止，先变大一下。
    }
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        //当手指离开屏幕时,将lastscale设置为1.0
        
        if(imageView.frame.size.width < image.size.width) //当小于原图大小的时候进行下列操作
        {
            CGRect frame = imageView.frame;
            if(cutSize.width >= cutSize.height) //判断截取框宽大还是高大
            {
                //宽大
                if(frame.size.width < cutSize.width)
                {
                    float a           = frame.size.height / frame.size.width;
                    frame.size.width  = cutSize.width;
                    frame.size.height = frame.size.width * a;
                    frame.origin.x    = (CGRectGetWidth(self.view.bounds) - cutSize.width) / 2;
                    frame.origin.y    = (CGRectGetHeight(self.view.bounds)- frame.size.height) / 2;
                    //当缩小到小于截取框的时候，将他的大小重置为合适的大小
                }
            }
            else
            {
                //高大
                if(frame.size.height < cutSize.height)
                {
                    float a           = frame.size.height / frame.size.width;
                    frame.size.height  = cutSize.height;
                    frame.size.width = frame.size.height / a;
                    frame.origin.x    = (CGRectGetWidth(self.view.bounds) - frame.size.width) / 2;
                    frame.origin.y    = (CGRectGetHeight(self.view.bounds)- cutSize.height) / 2;
                    //当缩小到小于截取框的时候，将他的大小重置为合适的大小
                }
            }
            imageView.frame = frame;
            
            float image_width      = CGRectGetWidth(imageView.frame);
            float image_heitht     = CGRectGetHeight(imageView.frame);
            float image_x          = CGRectGetMinX(imageView.frame);
            float image_y          = CGRectGetMinY(imageView.frame);
            float min_x            = CGRectGetMinX(cutRect);
            float min_y            = CGRectGetMinY(cutRect);
            float max_x            = CGRectGetMaxX(cutRect);
            float max_y            = CGRectGetMaxY(cutRect);
            
            //在放大缩小过程中图片移出截取框时，将图片移回来
            if(image_y > min_y)
            {
                image_y = min_y;
            }
            else if(image_y <= max_y - image_heitht)
            {
                image_y = max_y - image_heitht;
            }
            
            if(image_x >  min_x)
            {
                image_x = min_x;
            }
            else if(image_x <= max_x - image_width)
            {
                image_x = max_x - image_width;
            }
            imageView.frame = CGRectMake(image_x, image_y, image_width, image_heitht);
        }
        else
        {
            CGRect frame       = imageView.frame;
            frame.size.width   = self.image.size.width;
            frame.size.height  = self.image.size.height;
            imageView.frame    = frame;
            imageView.center   = self.view.center;
            //当放大到原图大小的时候就不允许在放大了，并将图片放在正中间位置。
        }
        
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.imageView setTransform:newTransform];
    lastScale = [sender scale];
    
}

+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        successBlock(NO);
        return;
    }
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            successBlock(YES);
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            successBlock(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             successBlock(granted);
                                         });
                                     }];
            break;
    }
}

@end
