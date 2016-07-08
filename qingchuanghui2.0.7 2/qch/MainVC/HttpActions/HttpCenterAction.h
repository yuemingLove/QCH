//
//  HttpCenterAction.h
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpCenterAction : NSObject

//我的动态列表
+(void)GetMyTopic:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//动态 粉丝 关注 个数
+(void)GetUserCenterCount:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我的项目
+(void)GetMyProject:(NSString *)userGuid ifAudit:(NSInteger)ifAudit page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我的活动
+(void)GetMyActivity:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我关注的项目
+(void)GetPraiseProject:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我关注的活动
+(void)GetPraiseActivity:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我报名的活动
+(void)GetMyApplyActivity:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我关注的人
+(void)GetPraiseUser:(NSString *)userGuid  type:(NSInteger)type  Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我的粉丝
+(void)GetUserFuns:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//我的空间预约
+ (void)GetMyOrderPlace:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;
//解除绑定
+ (void)DelThree:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//获取邀请好友
+ (void)GetInviteUser:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//获取邀请好友列表

+(void)GetInviteUserList:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//获取邀请好友明细

+ (void)GetInviteUserView:(NSString*)guid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//我的优惠券

+(void)GetMyVoucher:(NSString*)userGuid type:(NSString*)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//获取剩余积分

+(void)GetIntegral:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//获取优惠券

+(void)GetVoucher:(NSString*)Token complete:(HttpCompleteBlock)block;

//兑换优惠券
+(void)AddUserVoucher:(NSString*)userGuid voucherGuid:(NSString*)voucherGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//根据健值获取优惠券
+(void)GetVoucherByKey:(NSString *)userGuid key:(NSString*)key Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//积分列表
+(void)IntegralList:(NSString*)userGuid type:(NSString*)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//每日分享增加积分
+(void)ShareIntegral:(NSString *)userGuid type:(NSString *)type Token:(NSString*)Token complete:(HttpCompleteBlock)block;

@end
