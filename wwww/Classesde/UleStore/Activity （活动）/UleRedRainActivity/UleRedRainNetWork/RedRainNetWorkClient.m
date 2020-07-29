//
//  RedRainNetWorkClient.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/30.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "RedRainNetWorkClient.h"
#import "NSString+RedRain.h"
@implementation RedRainNetWorkClient

- (void) beginRequest:(RedRainRequest *)request onResponse:(UleResponseObject)responseBlock onError:(UleErrorObject)errorBlock{
    NSURLSession * session=[NSURLSession sharedSession];
    NSMutableURLRequest * mRequest=[NSMutableURLRequest requestWithURL:request.url];
    mRequest.HTTPMethod=@"POST";
    mRequest.timeoutInterval=12;
    NSString *bodyStr=[self genParameters:request.params];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES];
    mRequest.HTTPBody=postData;
    USLog(@"抽奖URL: %@ \n%@", mRequest.URL.absoluteString, request.params);
    [request.hparams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mRequest setValue:obj forHTTPHeaderField:key];
    }];
    NSURLSessionDataTask * task=[session dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (errorBlock) {
                     errorBlock(nil,error);
                }
            }else{
                NSString *resultString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result==%@",resultString);
                NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                responseBlock(nil,resultDictionary);
            }
        });
    } ];
    [task resume];
}

-(NSMutableString*) genParameters:(NSMutableDictionary*) parametersDic{
    if (!parametersDic) {
        return nil;
    }
    NSMutableString *bodyStr=[[NSMutableString alloc] init];
    for(NSString * akey in parametersDic){
        NSString *dicValue=[parametersDic objectForKey:akey];
        [bodyStr appendFormat:@"%@=%@&",[akey RD_UrlEncodedString],[dicValue RD_UrlEncodedString]];
    }
    if(bodyStr.length>1){
        [bodyStr deleteCharactersInRange:NSMakeRange(bodyStr.length-1, 1)];
    }
    return bodyStr;
}

@end
