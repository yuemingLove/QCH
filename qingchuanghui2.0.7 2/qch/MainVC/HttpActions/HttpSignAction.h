//
//  HttpSignAction.h
//  qch
//
//  Created by W.兵 on 16/7/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSignAction : NSObject

// 获取已经签到
+ (void)getGetSignInWithUserGuid:(NSString *)userGuid Token:(NSString *)Token  complete:(HttpCompleteBlock)block;
// 签到
+ (void)getSignInWithUserGuid:(NSString *)userGuid Token:(NSString *)Token  complete:(HttpCompleteBlock)block;

@end
