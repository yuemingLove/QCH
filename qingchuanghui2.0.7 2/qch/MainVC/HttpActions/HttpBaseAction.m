//
//  HttpBaseAction.m
//  qch
//
//  Created by 苏宾 on 16/1/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpBaseAction.h"

#define TIMEOUTSECONDS 30

@implementation HttpBaseAction

+ (AFHTTPSessionManager *)defaultManager{
    static AFHTTPSessionManager *manager;
    @synchronized(self){
        if (manager == nil) {
            manager=[[AFHTTPSessionManager alloc]init];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", nil];
            // 设置请求格式
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval=TIMEOUTSECONDS;
        }
    }
    return manager;
}


+ (void)postMDRequest:(NSMutableDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block{

    NSError *parseError=nil;
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:&parseError];
    
    NSString *str=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[HttpBaseAction defaultManager] POST:url parameters:str progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDictionary=responseObject;
        block(responseDictionary,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}

+(void)postDRequest:(NSDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block{

    //把传进来的URL字符串转变为URL地址
    NSURL *URL = [NSURL URLWithString:url];
    //请求初始化，可以在这针对缓存，超时做出一些设置
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:30];
    //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
    NSString *parseParamsResult = [self parseParams:parameters];
    NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray *result = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    block(result,nil);

}

//把NSDictionary解析成post格式的NSString字符串
+ (NSString *)parseParams:(NSDictionary *)params{
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}



+(void)getRequest:(NSString*)str complete:(HttpCompleteBlock)block{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    // 设置支持text/html文本格式的解析
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"text/javascript",@"application/json", nil];
    [manger GET:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        Liu_DBG(@"%@",error);
        block(nil,error);
    }];
    
 }

+ (void)alipayData:(NSString*)orderStr complete:(HttpCompleteBlock)block{

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"qch" callback:^(NSDictionary *resultDic) {
        block([resultDic objectForKey:@"resultStatus"],nil);
    }];
}

+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail {
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    // 设置支持text/html文本格式的解析
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain",@"application/json",@"text/javascript", nil];
    [manger POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail();
           Liu_DBG(@"---%@", error);
        }
    }];

}

+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
