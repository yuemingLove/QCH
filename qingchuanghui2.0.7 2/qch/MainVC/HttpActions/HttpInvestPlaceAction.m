//
//  HttpInvestPlaceAction.m
//  qch
//
//  Created by 青创汇 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpInvestPlaceAction.h"

@implementation HttpInvestPlaceAction

+(void)GetInvestPlaceList:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"page=%ld&pagesize=%ld&Token=%@",page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@InvestPlace_WebService.asmx/GetInvestPlaceList?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+(void)GetInvestPlaceView:(NSString *)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    NSString *path = [NSString stringWithFormat:@"%@InvestPlace_WebService.asmx/GetInvestPlaceView?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddInvestPlaceProject:(NSString*)projectGuid investplaceGuid:(NSString*)investplaceGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed = [NSString stringWithFormat:@"projectGuid=%@&investplaceGuid=%@&Token=%@",projectGuid,investplaceGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@InvestPlace_WebService.asmx/AddInvestPlaceProject?",SERIVE_URL];
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
