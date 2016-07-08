//
//  HttpCenterAction.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpCenterAction.h"

@implementation HttpCenterAction

+(void)GetMyTopic:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Topic_WebService.asmx/GetMyTopic?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetUserCenterCount:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetUserCenterCount?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error==nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetMyProject:(NSString *)userGuid ifAudit:(NSInteger)ifAudit page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&ifAudit=%ld&page=%ld&pagesize=%ld&Token=%@",userGuid,ifAudit,page,pagesize,Token];

    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/GetMyProject?",SERIVE_URL];

    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
    
}

+(void)GetMyActivity:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/GetMyActivity?",SERIVE_URL];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)GetPraiseProject:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Project_WebService.asmx/GetPraiseProject?",SERIVE_URL];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetPraiseActivity:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/GetPraiseActivity?",SERIVE_URL];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)GetMyApplyActivity:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Activity_WebService.asmx/GetMyApplyActivity?",SERIVE_URL];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)GetPraiseUser:(NSString *)userGuid type:(NSInteger)type Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&type=%ld&Token=%@",userGuid,type,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/GetPraiseUser?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}


+(void)GetUserFuns:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@User_WebService.asmx/GetUserFuns?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetMyOrderPlace:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path=[NSString stringWithFormat:@"%@Place_WebService.asmx/GetMyOrderPlace?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)DelThree:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/DelThree?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetInviteUser:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetInviteUser?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetInviteUserList:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetInviteUserList?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetInviteUserView:(NSString *)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    NSString *path = [NSString stringWithFormat:@"%@User_WebService.asmx/GetInviteUserView?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetMyVoucher:(NSString *)userGuid type:(NSString *)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&type=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,type,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserVoucher_WebService.asmx/GetMyVoucher?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetIntegral:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserIntegral_WebService.asmx/GetIntegral?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetVoucher:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"Token=%@",Token];
    NSString *path = [NSString stringWithFormat:@"%@Voucher_WebService.asmx/GetVoucher?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
    
}

+(void)AddUserVoucher:(NSString *)userGuid voucherGuid:(NSString *)voucherGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&voucherGuid=%@&Token=%@",userGuid,voucherGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserVoucher_WebService.asmx/AddUserVoucher?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetVoucherByKey:(NSString *)userGuid key:(NSString *)key Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&key=%@&Token=%@",userGuid,key,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserVoucher_WebService.asmx/GetVoucherByKey?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)IntegralList:(NSString *)userGuid type:(NSString*)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&type=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,type,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserIntegral_WebService.asmx/IntegralList?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)ShareIntegral:(NSString *)userGuid type:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"userGuid=%@&type=%@&Token=%@",userGuid,type,Token];
    NSString *path = [NSString stringWithFormat:@"%@UserIntegral_WebService.asmx/ShareIntegral?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    Liu_DBG(@"%@",url);
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
@end
