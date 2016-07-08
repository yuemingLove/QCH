//
//  HttpRoomAction.h
//  qch
//
//  Created by 苏宾 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRoomAction : NSObject

+ (void)GetPlace:(NSString*)userGuid cityName:(NSString*)cityName lat:(NSString*)lat lng:(NSString*)lng page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;


+ (void)GetPlaceView:(NSString*)guid userGuid:(NSString*)userGuid lat:(NSString*)lat lng:(NSString*)lng Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetPlaceStyle:(NSString*)placeGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetPlaceProject:(NSString*)placeGuid top:(NSInteger)top Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetPlaceOrderDateTime:(NSString*)placeStyleGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block;

+ (void)GetPlaceOrderDate:(NSString*)placeStyleGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block;

+ (void)GetPlaceOrderTime:(NSString*)dateGuid Token:(NSString*)Token  complete:(HttpCompleteBlock)block;

+ (void)EnSureOrdered:(NSString*)orderPlaceGuid userGuid:(NSString*)userGuid remark:(NSString*)remark Token:(NSString*)Token  complete:(HttpCompleteBlock)block;


+ (void)AddSendProject:(NSString*)userGuid projectGuid:(NSString*)projectGuid placeGuid:(NSString*)placeGuid type:(NSInteger)type Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//判断是否预约
+ (void)IfOrder:(NSString *)orderPlaceGuid userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

@end
