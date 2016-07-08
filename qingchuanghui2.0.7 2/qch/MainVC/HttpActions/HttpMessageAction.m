//
//  HttpMessageAction.m
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpMessageAction.h"

@implementation HttpMessageAction

+ (void)GetHistoryPush:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@HistoryPush_WebService.asmx/GetHistoryPush?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+ (void)GetMessageCount:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&Token=%@",userGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@HistoryPush_WebService.asmx/GetMessageCount?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+ (void)EditReadPush:(NSString*)Guid type:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed=[NSString stringWithFormat:@"guid=%@&type=%@&Token=%@",Guid, type, Token];
    
    NSString *path=[NSString stringWithFormat:@"%@HistoryPush_WebService.asmx/EditRead?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)DelHistoryPush:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&Token=%@",guid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@HistoryPush_WebService.asmx/DelHistoryPush?",SERIVE_URL];
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
