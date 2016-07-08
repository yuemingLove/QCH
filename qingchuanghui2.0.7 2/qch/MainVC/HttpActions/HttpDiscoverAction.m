//
//  HttpDiscoverAction.m
//  qch
//
//  Created by 苏宾 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpDiscoverAction.h"

@implementation HttpDiscoverAction

+ (void)GetNewsList:(NSInteger)page pagesize:(NSInteger)pagesize style:(NSString*)style province:(NSString *)province Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"page=%ld&pagesize=%ld&style=%@&province=%@&Token=%@",page,pagesize,style,province,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@News_WebService.asmx/GetNewsList?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetData:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"Token=%@",Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Ads_WebService.asmx/GetData?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddPersonal:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@Personal_WebService.asmx/AddPersonal",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        block(dataArray,nil);
    } fail:^{
        
    }];

}

+(void)Discovery:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"Token=%@",Token];
    NSString *path = [NSString stringWithFormat:@"%@OnOff_WebService.asmx/Discovery1?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

@end
