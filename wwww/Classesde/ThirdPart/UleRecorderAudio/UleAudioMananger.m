//
//  UleAudioMananger.m
//  RecorderDemo
//
//  Created by 陈竹青 on 2020/4/8.
//  Copyright © 2020 xuxiwen. All rights reserved.
//

#import "UleAudioMananger.h"
#import <AVFoundation/AVFoundation.h>
#import "ConvertAudioFile.h"


#define ETRECORD_RATE 11025.0
#define AUDIO_MAXTIME 20

@interface UleAudioMananger ()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) NSString *mp3Path;
@property (nonatomic,strong) NSString *cafPath;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic,strong) UIViewController *currentViewController;
@end

@implementation UleAudioMananger

- (void)startRecorderAudioWithCurrentViewController:(UIViewController *)currentViewController startStatus:(void(^) (BOOL))success{
    self.currentViewController=currentViewController;
    // 重置录音机
    if (_audioRecorder) {
        [self cleanMp3File];
        [self cleanCafFile];
        _audioRecorder = nil;
        self.time = 0;
        [self destoryTimer];
    }

    [self requestRecordingPermission:^(BOOL result) {
        success(result);
        if (result) {
            
            if (![self.audioRecorder isRecording]) {
                AVAudioSession *session = [AVAudioSession sharedInstance];
                NSError *sessionError;
                //AVAudioSessionCategoryPlayAndRecord用于录音和播放
                [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
                if(session == nil)
                    NSLog(@"Error creating session: %@", [sessionError description]);
                else
                    [session setActive:YES error:nil];
                            
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(record)
                                                            userInfo:nil
                                                             repeats:YES];
                [self.audioRecorder record];

                 NSLog(@"录音开始");
                [[ConvertAudioFile sharedInstance] conventToMp3WithCafFilePath:self.cafPath
                                                                   mp3FilePath:self.mp3Path
                                                                    sampleRate:ETRECORD_RATE
                                                                      callback:^(BOOL result){
                     if (result) {
                         NSLog(@"mp3 file compression sucesss");
                     }
                }];
                
            } else {
                
                NSLog(@"is  recording now  ....");
            }
        }else{
            
        }
    }];

}

- (void)endRecorderAudio{
    if ([self.audioRecorder isRecording]) {
        NSLog(@"完成");
        [self destoryTimer];
        [self.audioRecorder stop];
    }
}

- (void)record {
    self.time ++;
    if (self.time>=AUDIO_MAXTIME) {
        [self endRecorderAudio];
    }
}

- (void)cleanMp3File {
    if (self.mp3Path.length>0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.mp3Path isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.mp3Path error:nil];
            NSLog(@"  xxx.mp3  file   already delete");
        }
    }
}


- (void)cleanCafFile {
    if (self.cafPath.length>0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.cafPath error:nil];
            NSLog(@"  xxx.caf  file   already delete");
        }
    }
}
/**
 * 销毁定时器
 */
- (void)destoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"----- timer destory");
    }
}

- (void)requestRecordingPermission: (void(^) (BOOL))callback {

    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(recordPermission)]) {
    AVAudioSessionRecordPermission permission = [audioSession recordPermission];
        switch (permission) {
            case AVAudioSessionRecordPermissionUndetermined:
                callback(NO);
                NSLog(@"Undetermined");
                if ([audioSession respondsToSelector: @selector(requestRecordPermission:)]) {
                        [audioSession performSelector: @selector(requestRecordPermission:)
                                           withObject: ^(BOOL granted) {
                                               
                                           }];
                    }
                break;
            case AVAudioSessionRecordPermissionDenied:
                NSLog(@"Denied");
                [self requestOpenSettingAuthority];

                callback(NO);
                break;
            case AVAudioSessionRecordPermissionGranted:
                NSLog(@"Granted");
                callback(YES);
                break;
            default:
                break;
        }
    }
    
}

- (void)requestOpenSettingAuthority{
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIDevice currentDevice].systemVersion floatValue]>=10) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) { }];
                }
            }
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
   }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      }];
      UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:@"麦克风访问受限,前往设置" preferredStyle:UIAlertControllerStyleAlert];
      [alertController addAction:confirmAction];
      [alertController addAction:cancelAction];
    
    if (self.currentViewController) {
        [self.currentViewController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"----- 录音  完毕");
        [[ConvertAudioFile sharedInstance] sendEndRecord];
    }
}
#pragma mark - <getter and setter>
/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        //创建录音文件保存路径
        NSURL *url= [self getSavePath];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        [_audioRecorder prepareToRecord];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(ETRECORD_RATE) forKey:AVSampleRateKey];
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return dicM;
}


/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    NSLog(@"%@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
    NSString *fileName = @"record";
    NSString *cafFileName = [NSString stringWithFormat:@"%@.wav", fileName];
    NSString *mp3FileName = [NSString stringWithFormat:@"%@.mp3", fileName];
    NSString *cafPath = [path stringByAppendingPathComponent:cafFileName];
    NSString *mp3Path = [path stringByAppendingPathComponent:mp3FileName];
    self.mp3Path = mp3Path;
    self.cafPath = cafPath;
    NSLog(@"file path:%@",cafPath);
    
    NSURL *url=[NSURL fileURLWithPath:cafPath];
    return url;
}

- (NSString *)getRecorderAudioMp3Path{
    return self.mp3Path;
}
@end
