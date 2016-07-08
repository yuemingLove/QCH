//
//  HttpPartnerAction.h
//  qch
//
//  Created by 青创汇 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpPartnerAction : NSObject

//合伙人列表
+(void)partnerlist:(NSDictionary*)dic complete:(HttpCompleteBlock)block;

//投资人列表
+ (void)GetUserList:(NSString*)userStyle userGuid:(NSString *)userGuid best:(NSString*)best foucs:(NSString*)foucs city:(NSString*)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//合伙人完善资料
+(void)Completepartner:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//合伙人完善资料
+ (void)CompleteUserVersion2:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//添加工作经历
+(void)AddHistoryWork:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//删除工作经历
+(void)CommitHistoryWork:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//关注 取消关注合伙人
+(void)AddCareOrCancelPraise:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

+(void)AddOrCancelFoucs:(NSString *)userGuid foucsUserGuid:(NSString*)foucsUserGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//或许合伙人筛选条件
+ (void)getStyles:(NSString*)Token Byids:(NSString *)Byids complete:(HttpCompleteBlock)block;
//合伙人详情
+(void)GetUserView:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//添加投资案例
+(void)AddInvestCase:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//删除投资案例
+(void)DelInvestCase:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//获取合伙人列表
+(void)GetUserList2:(NSString*)userStyle userGuid:(NSString *)userGuid best:(NSString*)best foucs:(NSString*)foucs city:(NSString*)city key:(NSString*)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//合伙人列表
+(void)GetUserList3:(NSString *)userStyle userGuid:(NSString *)userGuid best:(NSString *)best foucs:(NSString*)foucs nowneed:(NSString *)nowneed intetion:(NSString *)intetion city:(NSString *)city key:(NSString *)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;
@end
