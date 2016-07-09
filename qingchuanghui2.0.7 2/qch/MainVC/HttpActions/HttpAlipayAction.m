//
//  HttpAlipayAction.m
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpAlipayAction.h"
#import "Order.h"
#import "DataSigner.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"

@implementation HttpAlipayAction


+ (void)AddAccount:(NSString*)accountNo userGuid:(NSString*)userGuid addReward:(NSString *)addReward reduceReward:(NSString*)reduceReward remark:(NSString*)remark Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"accountNo=%@&userGuid=%@&addReward=%@&reduceReward=%@&remark=%@&Token=%@",accountNo,userGuid,addReward,reduceReward,remark,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserAccount_WebService.asmx/AddAccount?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}


+ (void)AccountList:(NSString*)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserAccount_WebService.asmx/AccountList?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddOrder:(NSString*)associateGuid userGuid:(NSString*)userGuid ordertype:(NSInteger)ordertype paytype:(NSString*)paytype money:(NSString*)money name:(NSString*)name remark:(NSString *)remark Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"associateGuid=%@&userGuid=%@&ordertype=%ld&paytype=%@&money=%@&name=%@&remark=%@&Token=%@",associateGuid,userGuid,ordertype,paytype,money,name,remark,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/AddOrder?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)OrderList:(NSString*)guid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&page=%ld&pagesize=%ld&Token=%@",guid,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/OrderList?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}
+ (void)newOrderList:(NSString*)guid type:(NSString *)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"guid=%@&type=%@&page=%ld&pagesize=%ld&Token=%@",guid,type,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/OrderList2?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
    
}

+ (void)GetAccount:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",guid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserAccount_WebService.asmx/GetAccount?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)OrderView:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    NSString *mothed=[NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/OrderView?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
    
}
+ (void)EditVouher:(NSString*)orderGuid voucherGuid:(NSString *)voucherGuid uservoucherGuid:(NSString *)uservoucherGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block  {
    NSString *mothed=[NSString stringWithFormat:@"orderGuid=%@&voucherGuid=%@&uservoucherGuid=%@&Token=%@", orderGuid, voucherGuid, uservoucherGuid, Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/EditVouher?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)EditOrderState:(NSString*)orderGuid userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block {
    NSString *mothed=[NSString stringWithFormat:@"orderGuid=%@&userGuid=%@&Token=%@",orderGuid, userGuid, Token];
    
    NSString *path=[NSString stringWithFormat:@"%@UserOrder_WebService.asmx/EditOrderState?",SERIVE_URL];
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
