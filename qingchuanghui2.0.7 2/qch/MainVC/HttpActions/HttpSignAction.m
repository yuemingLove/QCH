//
//  HttpSignAction.m
//  qch
//
//  Created by W.兵 on 16/7/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpSignAction.h"

@implementation HttpSignAction

// 获取已经签到
+ (void)getGetSignInWithUserGuid:(NSString *)userGuid Token:(NSString *)Token  complete:(HttpCompleteBlock)block {
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid, Token];
    
    NSString *path = [NSString stringWithFormat:@"%@UserSignIn_WebService.asmx/GetSignIn?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}
// 签到
+ (void)getSignInWithUserGuid:(NSString *)userGuid Token:(NSString *)Token  complete:(HttpCompleteBlock)block {
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid, Token];
    
    NSString *path = [NSString stringWithFormat:@"%@UserSignIn_WebService.asmx/SignIn?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

@end
