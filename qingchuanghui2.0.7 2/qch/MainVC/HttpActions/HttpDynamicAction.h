//
//  HttpDynamicAction.h
//  qch
//
//  Created by 青创汇 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpBaseAction.h"
@interface HttpDynamicAction : NSObject
//发布活动
+(void)publishdynamic:(NSDictionary*)dic complete:(HttpCompleteBlock)block;

//活动列表
+(void)dynamiclist:(NSDictionary *)dic complete:(HttpCompleteBlock)block;
+(void)dynamiclist:(NSString *)userGuid city:(NSString*)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//活动关注
+ (void)care:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

+ (void)GetTalk:(NSString *)associateGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)commonAddTalk:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//活动评论
+ (void)dynamictalk:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//发布评论
+ (void)commitsend:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//动态详情
+ (void)dynamicstate:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//举报动态
+ (void)dynamicreport:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//删除动态
+ (void)dynamicdelete:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

//删除评论
+ (void)talkdelete:(NSDictionary *)dict complete:(HttpCompleteBlock)block;



@end
