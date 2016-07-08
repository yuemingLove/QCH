//
//  HttpDynamicAction.m
//  qch
//
//  Created by 青创汇 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpDynamicAction.h"

@implementation HttpDynamicAction
+(void)publishdynamic:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/AddTopicByMemcached",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *resultDic = [dataArray objectAtIndex:0];
        block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}


+(void)dynamiclist:(NSDictionary *)dic complete:(HttpCompleteBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/GetTopic",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}

+(void)dynamiclist:(NSString *)userGuid city:(NSString*)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&city=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,city,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Topic_WebService.asmx/GetTopic2?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}


+(void)care:(NSDictionary *)dict complete:(HttpCompleteBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/AddOrCancelPraise",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *result = [dataArray objectAtIndex:0];
            block(result,nil);
    } fail:^{
        
    }];
}


+ (void)GetTalk:(NSString *)associateGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"associateGuid=%@&page=%ld&pagesize=%ld&Token=%@",associateGuid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserTalk_WebService.asmx/GetTalk?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)dynamictalk:(NSDictionary *)dict complete:(HttpCompleteBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@UserTalk_WebService.asmx/GetTalk",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *result = [dataArray objectAtIndex:0];
            block(result,nil);
    } fail:^{
        
    }];
}


+ (void)commonAddTalk:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url = [NSString stringWithFormat:@"%@UserTalk_WebService.asmx/AddTalk_Version2",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *dict=dataArray[0];
        block(dict,nil);
    } fail:^{
        
    }];
}

+(void)commitsend:(NSDictionary *)dict complete:(HttpCompleteBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@UserTalk_WebService.asmx/AddTalk",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *dict=dataArray[0];
        block(dict,nil);
    } fail:^{
        
    }];
}
+(void)dynamicstate:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/GetTopicView",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *result = [dataArray objectAtIndex:0];
            block(result,nil);
    } fail:^{
        
    }];
}


+ (void)dynamicreport:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/AddOrCancelReport",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *result = [dataArray objectAtIndex:0];
        block(result,nil);
        
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}
+(void)dynamicdelete:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@Topic_WebService.asmx/DelTopic",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *result = [dataArray objectAtIndex:0];
        block(result,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}
+(void)talkdelete:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@UserTalk_WebService.asmx/DelTalk",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *result = [dataArray objectAtIndex:0];
        block(result,nil);
        
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}


@end
