//
//  HttpActivityAction.m
//  qch
//
//  Created by 苏宾 on 16/1/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpActivityAction.h"

@implementation HttpActivityAction

+ (void)getActivityList:(NSString *)userGuid cityName:(NSString *)cityName feeType:(NSString *)feeType day:(NSString *)day  page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&cityName=%@&feeType=%@&day=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,cityName,feeType,day,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/GetActivity?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetActivityView:(NSString *)guid userGuid:(NSString *)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&userGuid=%@&Token=%@",guid,userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/GetActivityView?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)DelActivity:(NSString *)guid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/DelActivity?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddOrCancelPraise:(NSString *)userGuid activityGuid:(NSString *)activityGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&activityGuid=%@&Token=%@",userGuid,activityGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/AddOrCancelPraise?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddActivity:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@Activity_WebService.asmx/AddActivity",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        block(dataArray,nil);
    } fail:^{
        
    }];
}

+ (void)AddActivityApply:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@Activity_WebService.asmx/AddActivityApply",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        block(dataArray,nil);
    } fail:^{
        
    }];
}

+(void)AddOrder:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@UserOrder_WebService.asmx/AddOrder",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        block(dataArray,nil);
    } fail:^{
        
    }];
}
+(void)GetPayKey:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"type=%@&Token=%@",type,Token];
    NSString *path = [NSString stringWithFormat:@"%@OnOff_WebService.asmx/GetPayKey?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+(void)ProofList:(NSInteger)page pagesize:(NSInteger)pagesize guid:(NSString *)guid complete:(HttpCompleteBlock)block
{
    NSString *moethed = [NSString stringWithFormat:@"page=%ld&pagesize=%ld&guid=%@",page,pagesize,guid];
    NSString *path = [NSString stringWithFormat:@"%@activity/ProofList?",SERIVE_NEWURL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,moethed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)ApplyProof:(NSString *)guid complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"guid=%@",guid];
    NSString *path = [NSString stringWithFormat:@"%@activity/ApplyProof?",SERIVE_NEWURL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)apply:(NSString *)guid phone:(NSString *)phone dict:(NSDictionary *)dict complete:(HttpCompleteBlock)block
{
    NSString *mothod = [NSString stringWithFormat:@"guid=%@&phone=%@",guid,phone];
    NSString *path = [NSString stringWithFormat:@"%@activity/apply?",SERIVE_NEWURL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothod];

    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSDictionary *datadic = responseObject;
        block(datadic,nil);
    } fail:^{
        
    }];
    
}

+(void)AddActivityApply:(NSString *)userGuid activityGuid:(NSString *)activityGuid applyName:(NSString *)applyName applyMobile:(NSString *)applyMobile applyReamrk:(NSString *)applyReamrk Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&activityGuid=%@&applyName=%@&applyMobile=%@&applyReamrk=%@&Token=%@",userGuid,activityGuid,applyName,applyMobile,applyReamrk,Token];
    NSString *path = [NSString stringWithFormat:@"%@Activity_WebService.asmx/AddActivityApply?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetMyApplyView:(NSString *)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Activity_WebService.asmx/GetMyApplyView?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetMyApplyList:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@Activity_WebService.asmx/GetMyApplyList?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)IfApply:(NSString *)userGuid activityGuid:(NSString *)activityGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&activityGuid=%@&Token=%@",userGuid,activityGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Activity_WebService.asmx/IfApply?",SERIVE_URL];
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
