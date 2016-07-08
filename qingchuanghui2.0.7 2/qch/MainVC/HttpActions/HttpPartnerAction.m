//
//  HttpPartnerAction.m
//  qch
//
//  Created by 青创汇 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpPartnerAction.h"

@implementation HttpPartnerAction

+(void)partnerlist:(NSDictionary *)dic complete:(HttpCompleteBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/GetUserList",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        
    }];
}

+ (void)GetUserList:(NSString*)userStyle userGuid:(NSString *)userGuid best:(NSString*)best foucs:(NSString*)foucs city:(NSString*)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userStyle=%@&userGuid=%@&best=%@&foucs=%@&city=%@&page=%ld&pagesize=%ld&Token=%@",userStyle,userGuid,best,foucs,city,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/GetUserList?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)Completepartner:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/CompleteUser",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}

+(void)CompleteUserVersion2:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/CompleteUserVersion2",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *resultDic = [dataArray objectAtIndex:0];
        block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}

+(void)AddHistoryWork:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/AddHistoryWork",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}

+(void)CommitHistoryWork:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/DelHistoryWork",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}
+(void)AddCareOrCancelPraise:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/AddOrCancelFoucs",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}

+(void)AddOrCancelFoucs:(NSString *)userGuid foucsUserGuid:(NSString*)foucsUserGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&foucsUserGuid=%@&Token=%@",userGuid,foucsUserGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/AddOrCancelFoucs?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+ (void)getStyles:(NSString*)Token Byids:(NSString *)Byids complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"Ids=%@&Token=%@",Byids,Token];
    NSString *path=[NSString stringWithFormat:@"%@Style_WebService.asmx/GetStyleByIds?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+(void)GetUserView:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/GetUserView",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            block(resultDic,nil);
    } fail:^{
        Liu_DBG(@"请求失败");
    }];
}
+(void)AddInvestCase:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/AddInvestCase",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *resultDic = [dataArray objectAtIndex:0];
        block(resultDic,nil);
    } fail:^{
         Liu_DBG(@"请求失败");
    }];
}
+(void)DelInvestCase:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@User_WebService.asmx/DelInvestCase",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *resultDic = [dataArray objectAtIndex:0];
        block(resultDic,nil);
    } fail:^{
        
    }];
}
+(void)GetUserList2:(NSString *)userStyle userGuid:(NSString *)userGuid best:(NSString *)best foucs:(NSString *)foucs city:(NSString *)city key:(NSString *)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userStyle=%@&userGuid=%@&best=%@&foucs=%@&city=%@&key=%@&page=%ld&pagesize=%ld&Token=%@",userStyle,userGuid,best,foucs,city,key,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetUserList2?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetUserList3:(NSString *)userStyle userGuid:(NSString *)userGuid best:(NSString *)best foucs:(NSString*)foucs nowneed:(NSString *)nowneed intetion:(NSString *)intetion city:(NSString *)city key:(NSString *)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userStyle=%@&userGuid=%@&best=%@&foucs=%@&nowneed=%@&intetion=%@&city=%@&key=%@&page=%ld&pagesize=%ld&Token=%@",userStyle,userGuid,best,foucs,nowneed,intetion,city,key,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetUserList3?",SERIVE_URL];
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
