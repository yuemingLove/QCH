//
//  HttpProjectAction.h
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpProjectAction : NSObject

+ (void)GetProject:(NSString *)userGuid cityName:(NSString *)cityName pPhase:(NSString*)pPhase pFinancePhase:(NSString *)pFinancePhase pParterWant:(NSString *)pParterWant pField:(NSString*)pField page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetProjectView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString *)Token omplete:(HttpCompleteBlock)block;


//获取职位
+ (void)getStyles:(NSString*)Token Byids:(NSString *)Byids complete:(HttpCompleteBlock)block;

+ (void)AddOrCancelPraise:(NSString*)userGuid projectGuid:(NSString*)projectGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;


+ (void)AddProject:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

+ (void)DelProject:(NSString *)guid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//
+ (void)AddSendProject:(NSString*)userGuid projectGuid:(NSString*)projectGuid investuserGuid:(NSString*)investuserGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetSendProject:(NSString*)userGuid state:(NSInteger)state page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)EditState:(NSString*)guid state:(NSInteger)state Token:(NSString*)Token complete:(HttpCompleteBlock)block;


+ (void)GetPlaceProject:(NSString*)userGuid type:(NSInteger)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+(void)AddProject2:(NSDictionary *)dic complete:(HttpCompleteBlock)block;

//得到团队成员
+ (void)GetProjectTeam:(NSString *)projectGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+(void)GetProject2:(NSString *)userGuid cityName:(NSString *)cityName pPhase:(NSString*)pPhase pFinancePhase:(NSString *)pFinancePhase pParterWant:(NSString *)pParterWant pField:(NSString*)pField key:(NSString*)key page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;
//判断是不是合伙人
+(void)GetIsInvestor:(NSString *)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

@end
