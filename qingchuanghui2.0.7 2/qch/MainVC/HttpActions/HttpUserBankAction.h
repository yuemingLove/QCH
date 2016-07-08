//
//  HttpUserBankAction.h
//  qch
//
//  Created by 青创汇 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUserBankAction : NSObject

+(void)AddBank:(NSString *)userGuid userName:(NSString*)userName userNO:(NSString*)userNO Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+(void)GetUserBank:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;


+ (void)SendVoiceSMS:(NSString *)userMobile Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+(void)CompleteBank:(NSString *)guid bankName:(NSString *)bankName bankNO:(NSString*)bankNO openAddress:(NSString *)openAddress Token:(NSString*)Token
 complete:(HttpCompleteBlock)block;

+ (void)AddWithdrawal:(NSString *)userGuid money:(NSString *)money remark:(NSString *)remark bankGuid:(NSString*)bankGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)EditOrderNO:(NSString *)orderNO Token:(NSString *)Token complete:(HttpCompleteBlock)block;
// 提现列表
+ (void)GetWithdrawalWithUserGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

@end
