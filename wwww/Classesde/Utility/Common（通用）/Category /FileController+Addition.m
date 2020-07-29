//
//  FileController+Addition.m
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/21.
//

#import "FileController+Addition.h"



@implementation FileController (Addition)


+ (NSDictionary *)getAddtionCurNameDic{
    NSURL *matchFileURL = [[NSBundle mainBundle] URLForResource:@"viewNameMatch" withExtension:@"plist"];
    NSDictionary *matchDic = [NSDictionary dictionaryWithContentsOfURL:matchFileURL];
    NSDictionary * logVCNameInf=[matchDic objectForKey:@"logVcNameInfo"];
    NSMutableDictionary * curDic =[[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"UleStoreApp.bundle/CurNameMatch" withExtension:@"plist"]] mutableCopy];
    //合并curName
    if (logVCNameInf &&[logVCNameInf objectForKey:@"curNameDic"]) {
        [curDic addEntriesFromDictionary:[logVCNameInf objectForKey:@"curNameDic"]];
        return curDic;
    }
    return curDic;
}
+ (NSDictionary *)getAddtionCtiNameDic{
    NSURL *matchFileURL = [[NSBundle mainBundle] URLForResource:@"viewNameMatch" withExtension:@"plist"];
    NSDictionary *matchDic = [NSDictionary dictionaryWithContentsOfURL:matchFileURL];
    NSDictionary * logVCNameInf=[matchDic objectForKey:@"logVcNameInfo"];
    NSMutableDictionary * ctiDic= [[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"UleStoreApp.bundle/CtiNameMatch" withExtension:@"plist"]] mutableCopy];
    //合并ctiName
    if (logVCNameInf&&[logVCNameInf objectForKey:@"ctiNameDic"]) {
        [ctiDic addEntriesFromDictionary:[logVCNameInf objectForKey:@"ctiNameDic"]];
    }
    return ctiDic;
}
+ (NSDictionary *)getAddtionPushNameDic{
    NSURL *matchFileURL = [[NSBundle mainBundle] URLForResource:@"viewNameMatch" withExtension:@"plist"];
    NSDictionary *matchDic = [NSDictionary dictionaryWithContentsOfURL:matchFileURL];
    NSDictionary * pushNameInf=[matchDic objectForKey:@"pushVcNameInfo"];
//    NSURL *localURL = [[NSBundle mainBundle] URLForResource:@"PushViewName" withExtension:@"plist"];
//    NSMutableDictionary *localDic = [[NSDictionary dictionaryWithContentsOfURL:localURL] mutableCopy];
    NSMutableDictionary * localDic= [[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"UleStoreApp.bundle/PushViewName" withExtension:@"plist"]] mutableCopy];

    //合并新加的
    if (pushNameInf) {
        [localDic addEntriesFromDictionary:pushNameInf];
    }
    return localDic;
}

@end
