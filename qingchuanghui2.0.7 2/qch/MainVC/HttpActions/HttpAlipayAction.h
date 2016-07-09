//
//  HttpAlipayAction.h
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpBaseAction.h"

@interface HttpAlipayAction : NSObject

+ (void)AddAccount:(NSString*)accountNo userGuid:(NSString*)userGuid addReward:(NSString *)addReward reduceReward:(NSString*)reduceReward remark:(NSString*)remark Token:(NSString*)Token complete:(HttpCompleteBlock)block;


+ (void)AccountList:(NSString*)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

//ordertype:1:充值；2:活动
+ (void)AddOrder:(NSString*)associateGuid userGuid:(NSString*)userGuid ordertype:(NSInteger)ordertype paytype:(NSString*)paytype money:(NSString*)money name:(NSString*)name remark:(NSString *)remark Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)OrderList:(NSString*)guid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)newOrderList:(NSString*)guid type:(NSString *)type page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

#pragma 获取余额总数
+ (void)GetAccount:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)OrderView:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block;
#pragma 添加代金券
+ (void)EditVouher:(NSString*)orderGuid voucherGuid:(NSString *)voucherGuid uservoucherGuid:(NSString *)uservoucherGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;
+ (void)EditOrderState:(NSString*)orderGuid userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

@end
