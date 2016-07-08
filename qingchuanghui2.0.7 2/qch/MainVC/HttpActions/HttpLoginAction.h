//
//  HttpLoginAction.h
//  qch
//
//  Created by 苏宾 on 16/1/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpBaseAction.h"

@interface HttpLoginAction : NSObject

+ (void)loginWithAccount:(NSString *)userMobile userPwd:(NSString *)userPwd androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token2:(NSString*)Token2 complete:(HttpCompleteBlock)block;

+(void)registerUser:(NSString *)userMobile userPwd:(NSString *)userPwd userRecommend:(NSString*)userRecommend Token:(NSString*)Token type:(NSInteger)type userId:(NSString*)userId androidRid:(NSString *)androidRid IOSRid:(NSString*)IOSRid complete:(HttpCompleteBlock)block;


+(void)SendSMS:(NSString *)userMobile type:(NSString*)type Token:(NSString*)Token complete:(HttpCompleteBlock)block;


+ (void)publishMessage:(NSString *)fromUserGuid toUserGuid:(NSString *)toUserGuid operation:(NSString *)operation message:(NSString*)message Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)getRYToken:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;


+ (void)updateImage:(NSDictionary*)dic complete:(HttpCompleteBlock)block;
+ (void)EditBackPic:(NSDictionary*)dic complete:(HttpCompleteBlock)block;

+ (void)complateUser:(NSDictionary *)dict complete:(HttpCompleteBlock)block;

+ (void)getHotCity:(NSString *)Token complete:(HttpCompleteBlock)block;

//获取职位
+ (void)getStyle:(NSString*)Token Byid:(NSInteger)Byid complete:(HttpCompleteBlock)block;

//判断第三方登录
+ (void)IfThreeLogin:(NSString *)userId androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//获取聊天用户的头像信息
+ (void)GetUserPic:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)EditRid:(NSString*)userGuid androidRid:(NSString*)androidRid IOSRid:(NSString*)IOSRid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetPayKey:(NSString *)type Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//+(void)AddUsers2:

#pragma 判断是否在游客模式
+ (void)OnOffTravel:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)LoadPic:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetIsLoginId:(NSString*)userLoginID Token:(NSString*)Token complete:(HttpCompleteBlock)block;

@end
