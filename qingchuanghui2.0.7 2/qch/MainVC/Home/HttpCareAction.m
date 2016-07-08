//
//  HttpCareAction.m
//  qch
//
//  Created by W.兵 on 16/6/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpCareAction.h"

@implementation HttpCareAction

+ (void)getCarelist:(NSString *)userGuid city:(NSString *)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block {
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&city=%@&page=%ld&pagesize=%ld&Token=%@",userGuid, city, page, pagesize, Token];
    
    NSString *path = [NSString stringWithFormat:@"%@Topic_WebService.asmx/GetMyPraiseTopic?",SERIVE_URL];
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
