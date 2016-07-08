//
//  HttpUserBankAction.m
//  qch
//
//  Created by 青创汇 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpUserBankAction.h"

@implementation HttpUserBankAction

+ (void)AddBank:(NSString *)userGuid userName:(NSString *)userName userNO:(NSString *)userNO Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&userName=%@&userNO=%@&Token=%@",userGuid,userName,userNO,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserBank_WebService.asmx/AddBank?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetUserBank:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserBank_WebService.asmx/GetUserBank?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}


+(void)SendVoiceSMS:(NSString *)userMobile Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userMobile=%@&Token=%@",userMobile,Token];
    NSString *path = [NSString stringWithFormat:@"%@SMS_WebService.asmx/SendVoiceSMS?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)CompleteBank:(NSString *)guid bankName:(NSString *)bankName bankNO:(NSString *)bankNO openAddress:(NSString *)openAddress Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&bankName=%@&bankNO=%@&openAddress=%@&Token=%@",guid,bankName,bankNO,openAddress,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserBank_WebService.asmx/CompleteBank?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)AddWithdrawal:(NSString *)userGuid money:(NSString *)money remark:(NSString *)remark bankGuid:(NSString *)bankGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&money=%@&remark=%@&bankGuid=%@&Token=%@",userGuid,money,remark,bankGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Withdrawal_WebService.asmx/AddWithdrawal?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)EditOrderNO:(NSString *)orderNO Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"orderNO=%@&Token=%@",orderNO,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserOrder_WebService.asmx/EditOrderNO?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetVoiceCode:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"Token=%@",Token];
    NSString *path = [NSString stringWithFormat:@"%@OnOff_WebService.asmx/GetVoiceCode?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetWithdrawalWithUserGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block {
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid, page, pagesize, Token];
    NSString *path = [NSString stringWithFormat:@"%@Withdrawal_WebService.asmx/GetWithdrawal?",SERIVE_URL];
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
