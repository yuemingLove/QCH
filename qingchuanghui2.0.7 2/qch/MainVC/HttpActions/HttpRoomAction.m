//
//  HttpRoomAction.m
//  qch
//
//  Created by 苏宾 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpRoomAction.h"

@implementation HttpRoomAction

+ (void)GetPlace:(NSString*)userGuid cityName:(NSString*)cityName lat:(NSString*)lat lng:(NSString*)lng  page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&cityName=%@&lat=%@&lng=%@&page=%ld&pagesize=%ld&Token=%@",userGuid,cityName,lat,lng,page,pagesize,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Place_WebService.asmx/GetPlace?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetPlaceView:(NSString*)guid userGuid:(NSString*)userGuid lat:(NSString*)lat lng:(NSString*)lng Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"guid=%@&userGuid=%@&lat=%@&lng=%@&Token=%@",guid,userGuid,lat,lng,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Place_WebService.asmx/GetPlaceView?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetPlaceStyle:(NSString*)placeGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"placeGuid=%@&Token=%@",placeGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Place_WebService.asmx/GetPlaceStyle?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}
+ (void)GetPlaceProject:(NSString*)placeGuid top:(NSInteger)top Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"placeGuid=%@&top=%ld&Token=%@",placeGuid,top,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@Place_WebService.asmx/GetPlaceProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetPlaceOrderDateTime:(NSString*)placeStyleGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"placeStyleGuid=%@&Token=%@",placeStyleGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceOrder_WebService.asmx/GetPlaceOrderDateTime?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+ (void)GetPlaceOrderDate:(NSString*)placeStyleGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"placeStyleGuid=%@&Token=%@",placeStyleGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceOrder_WebService.asmx/GetPlaceOrderDate?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+ (void)GetPlaceOrderTime:(NSString*)dateGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"dateGuid=%@&Token=%@",dateGuid,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceOrder_WebService.asmx/GetPlaceOrderTime?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+ (void)EnSureOrdered:(NSString*)orderPlaceGuid userGuid:(NSString*)userGuid remark:(NSString*)remark Token:(NSString*)Token  complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"orderPlaceGuid=%@&userGuid=%@&remark=%@&Token=%@",orderPlaceGuid,userGuid,remark,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceOrder_WebService.asmx/EnSureOrdered?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)AddSendProject:(NSString*)userGuid projectGuid:(NSString*)projectGuid placeGuid:(NSString*)placeGuid type:(NSInteger)type Token:(NSString*)Token complete:(HttpCompleteBlock)block{

    NSString *mothed=[NSString stringWithFormat:@"userGuid=%@&projectGuid=%@&placeGuid=%@&type=%ld&Token=%@",userGuid,projectGuid,placeGuid,type,Token];
    
    NSString *path=[NSString stringWithFormat:@"%@PlaceProject_WebService.asmx/AddSendProject?",SERIVE_URL];
    NSString *url=[NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];

}

+ (void)IfOrder:(NSString *)orderPlaceGuid userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"orderPlaceGuid=%@&userGuid=%@&Token=%@",orderPlaceGuid,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@PlaceOrder_WebService.asmx/IfOrder?",SERIVE_URL];
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
