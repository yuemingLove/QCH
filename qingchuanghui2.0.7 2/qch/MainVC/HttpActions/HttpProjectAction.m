//
//  HttpProjectAction.m
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpProjectAction.h"

@implementation HttpProjectAction

+ (void)GetProject:(NSString *)userGuid cityName:(NSString *)cityName pPhase:(NSString*)pPhase pFinancePhase:(NSString *)pFinancePhase pParterWant:(NSString *)pParterWant pField:(NSString*)pField page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&cityName=%@&pPhase=%@&pFinancePhase=%@&pParterWant=%@&pField=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,cityName,pPhase,pFinancePhase,pParterWant,pField,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/GetProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetProjectView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString *)Token omplete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&userGuid=%@&Token=%@",guid,userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/GetProjectView?",SERIVE_URL];
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

+ (void)AddOrCancelPraise:(NSString*)userGuid projectGuid:(NSString*)projectGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&projectGuid=%@&Token=%@",userGuid,projectGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/AddOrCancelPraise?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddProject:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@Project_WebService.asmx/AddProject",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        block(dataArray,nil);
    } fail:^{
        
    }];

}

+ (void)DelProject:(NSString *)guid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/DelProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddSendProject:(NSString*)userGuid projectGuid:(NSString*)projectGuid investuserGuid:(NSString*)investuserGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&projectGuid=%@&investuserGuid=%@&Token=%@",userGuid,projectGuid,investuserGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@SendProject_WebService.asmx/AddSendProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetSendProject:(NSString*)userGuid state:(NSInteger)state page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&state=%ld&page=%ld&pagesize=%ld&Token=%@",userGuid,state,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@SendProject_WebService.asmx/GetSendProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)EditState:(NSString*)guid state:(NSInteger)state Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&state=%ld&Token=%@",guid,state,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@SendProject_WebService.asmx/EditState?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetPlaceProject:(NSString*)userGuid type:(NSInteger)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&type=%ld&page=%ld&pagesize=%ld&Token=%@",userGuid,type,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceProject_WebService.asmx/GetPlaceProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)AddProject2:(NSDictionary *)dic complete:(HttpCompleteBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@Project_WebService.asmx/AddProject2",SERIVE_URL];
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        NSDictionary *resultDic = [dataArray objectAtIndex:0];
        block(resultDic,nil);
    } fail:^{
        
    }];
}

+ (void)GetProjectTeam:(NSString *)projectGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"projectGuid=%@&Token=%@",projectGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@ProjectTeam_WebService.asmx/GetProjectTeam?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetProject2:(NSString *)userGuid cityName:(NSString *)cityName pPhase:(NSString *)pPhase pFinancePhase:(NSString *)pFinancePhase pParterWant:(NSString *)pParterWant pField:(NSString *)pField key:(NSString *)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&cityName=%@&pPhase=%@&pFinancePhase=%@&pParterWant=%@&pField=%@&key=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,cityName,pPhase,pFinancePhase,pParterWant,pField,key,page,pagesize,Token];
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/GetProject2?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+(void)GetIsInvestor:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetIsInvestor?",SERIVE_URL];
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
