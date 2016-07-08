//
//  UtilsIsTrue.h
//  qch
//
//  Created by 苏宾 on 16/3/11.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsIsTrue : NSObject

//判断手机号
/**
 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
 * 联通：130,131,132,152,155,156,185,186
 * 电信：133,1349,153,180,189,181(增加)
 */
+ (BOOL)checkTel:(NSString *)mobileNumbel;

//判断邮箱
+ (BOOL)validateEmail:(NSString *)email;

//判断身份证号
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;


@end
