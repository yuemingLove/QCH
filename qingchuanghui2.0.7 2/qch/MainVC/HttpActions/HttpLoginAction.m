//
//  HttpLoginAction.m
//  qch
//
//  Created by 苏宾 on 16/1/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpLoginAction.h"

@implementation HttpLoginAction


+ (void)loginWithAccount:(NSString *)userMobile userPwd:(NSString *)userPwd androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token2:(NSString*)Token2 complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userMobile=%@&userPwd=%@&androidRid=%@&IOSRid=%@&Token=%@",userMobile,userPwd,@"",IOSRid,Token2];
    
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/Login?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}


+(void)registerUser:(NSString *)userMobile userPwd:(NSString *)userPwd userRecommend:(NSString *)userRecommend Token:(NSString *)Token type:(NSInteger)type userId:(NSString *)userId androidRid:(NSString *)androidRid IOSRid:(NSString *)IOSRid complete:(HttpCompleteBlock)block{
    
    NSString *mothed=nil;
    NSString *path=nil;
    if (type==1) {
        mothed=[NSString stringWithFormat:@"userMobile=%@&userPwd=%@&userRecommend=%@&Token=%@",userMobile,userPwd,userRecommend,Token];
        path=[NSString stringWithFormat:@"%@User_WebService.asmx/AddUsers2?",SERIVE_URL];
    }else if(type==2){
        mothed=[NSString stringWithFormat:@"userMobile=%@&userPwd=%@&userId=%@&androidRid=%@&IOSRid=%@&Token=%@",userMobile,userPwd,userId,androidRid,IOSRid,Token];
        path=[NSString stringWithFormat:@"%@User_WebService.asmx/ThreeLogin?",SERIVE_URL];
    }else if(type==3){
        mothed=[NSString stringWithFormat:@"userMobile=%@&userPwd=%@&Token=%@",userMobile,userPwd,Token];
        path=[NSString stringWithFormat:@"%@User_WebService.asmx/ForgetPwd?",SERIVE_URL];
    }
    
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)SendSMS:(NSString *)userMobile type:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block {
    
    NSString *mothed=[NSString stringWithFormat:@"userMobile=%@&type=%@&Token=%@",userMobile,type,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@SMS_WebService.asmx/SendSMSVerson2?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)publishMessage:(NSString *)fromUserGuid toUserGuid:(NSString *)toUserGuid operation:(NSString *)operation message:(NSString*)message Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"fromUserGuid=%@&toUserGuid=%@&operation=%@&message=%@&Token=%@",fromUserGuid,toUserGuid,operation,message,@""];
    NSString *path=[NSString stringWithFormat:@"%@RongCloud_WebService.asmx/PublishMessage?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)getRYToken:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@RongCloud_WebService.asmx/GetRongCloudToken?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}


+ (void)updateImage:(NSDictionary*)dic complete:(HttpCompleteBlock)block{
    
    NSString *url=[NSString stringWithFormat:@"%@User_WebService.asmx/UpdatePic",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        if ([[dataArray[0]objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            if ([[resultDic objectForKey:@"state"]isEqualToString:@"true"]) {//此时有值 将将刷新tableview
                NSDictionary *dict=[resultDic objectForKey:@"result"][0];
                block(dict,nil);
            }
        }else{
            block(nil,[dataArray[0]objectForKey:@"result"]);
        }

    } fail:^{

    }];
}

+ (void)EditBackPic:(NSDictionary*)dic complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@User_WebService.asmx/EditBackPic",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dic success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        if ([[dataArray[0]objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            if ([[resultDic objectForKey:@"state"]isEqualToString:@"true"]) {//此时有值 将将刷新tableview
                NSString *dict=[resultDic objectForKey:@"result"];
                block(dict,nil);
            }
        }else{
            block(nil,[dataArray[0]objectForKey:@"result"]);
        }
        
    } fail:^{
        
    }];
}

+ (void)complateUser:(NSDictionary *)dict complete:(HttpCompleteBlock)block{

    NSString *url=[NSString stringWithFormat:@"%@User_WebService.asmx/CompleteUser",SERIVE_URL];
    
    [HttpBaseAction postJSONWithUrl:url parameters:dict success:^(id responseObject) {
        NSArray *dataArray = responseObject;
        if ([[dataArray[0]objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *resultDic = [dataArray objectAtIndex:0];
            if ([[resultDic objectForKey:@"state"]isEqualToString:@"true"]) {//此时有值 将将刷新tableview
                NSDictionary *dict=[resultDic objectForKey:@"result"][0];
                block(dict,nil);
            }
        }else{
            block(nil,[dataArray[0]objectForKey:@"result"]);
        }
        
    } fail:^{
        
    }];
}

+ (void)getHotCity:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"Token=%@",Token];
    NSString *path=[NSString stringWithFormat:@"%@HotCity_WebService.asmx/GetHotCity?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)getStyle:(NSString*)Token Byid:(NSInteger)Byid complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"Id=%ld&Token=%@",Byid,Token];
    NSString *path=[NSString stringWithFormat:@"%@Style_WebService.asmx/GetStyleById?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)IfThreeLogin:(NSString *)userId androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"userId=%@&androidRid=%@&IOSRid=%@&Token=%@",userId,androidRid,IOSRid,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/IfThreeLogin?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetUserPic:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/GetUserPic?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)EditRid:(NSString*)userGuid androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&androidRid=%@&IOSRid=%@&Token=%@",userGuid,androidRid,IOSRid,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/EditRid?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)EditBackPic:(NSString*)userGuid base64Pic:(NSString*)base64Pic Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&base64Pic=%@&Token=%@",userGuid,base64Pic,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/EditBackPic?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)OnOffTravel:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"Token=%@",Token];
    NSString *path=[NSString stringWithFormat:@"%@OnOff_WebService.asmx/OnOffTravel?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)LoadPic:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"Token=%@",Token];
    NSString *path=[NSString stringWithFormat:@"%@OnOff_WebService.asmx/LoadPic?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetPayKey:(NSString *)type Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"type=%@&Token=%@",type,Token];
    NSString *path=[NSString stringWithFormat:@"%@OnOff_WebService.asmx/GetPayKey?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetIsLoginId:(NSString *)userLoginID Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userLoginID=%@&Token=%@",userLoginID,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetIsLoginId?",SERIVE_URL];
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
