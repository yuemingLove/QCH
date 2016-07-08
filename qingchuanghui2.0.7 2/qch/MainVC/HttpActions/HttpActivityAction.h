//
//  HttpActivityAction.h
//  qch
//
//  Created by 苏宾 on 16/1/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpActivityAction : NSObject

+ (void)getActivityList:(NSString *)userGuid cityName:(NSString *)cityName feeType:(NSString *)feeType day:(NSString *)day page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)GetActivityView:(NSString *)guid userGuid:(NSString *)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)DelActivity:(NSString *)guid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)AddOrCancelPraise:(NSString *)userGuid activityGuid:(NSString *)activityGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)AddActivity:(NSDictionary *)dict complete:(HttpCompleteBlock)block;


+ (void)AddActivityApply:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

+ (void)AddOrder:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

+ (void)GetPayKey:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+(void)ProofList:(NSInteger)page pagesize:(NSInteger)pagesize guid:(NSString*)guid complete:(HttpCompleteBlock)block;

+ (void)ApplyProof:(NSString *)guid complete:(HttpCompleteBlock)block;

+ (void)apply:(NSString *)guid phone:(NSString *)phone dict:(NSDictionary*)dict complete:(HttpCompleteBlock)block;

//活动报名
+ (void)AddActivityApply:(NSString*)userGuid activityGuid:(NSString*)activityGuid applyName:(NSString *)applyName applyMobile:(NSString *)applyMobile applyReamrk:(NSString *)applyReamrk Token:(NSString*)Token complete:(HttpCompleteBlock)block;
//活动报名凭证详情
+ (void) GetMyApplyView:(NSString *)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//活动报名凭证列表
+ (void) GetMyApplyList:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//是否能报名
+ (void)IfApply:(NSString *)userGuid activityGuid:(NSString*)activityGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

@end
