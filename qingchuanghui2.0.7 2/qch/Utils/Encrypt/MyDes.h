//
//  MyDes.h
//  IWant
//
//  Created by aa on 15/4/9.
//  Copyright (c) 2015年 aa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDes : NSObject

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

+ (NSString *)encryptWithText:(NSString *)sText theKey:(NSString *)aKey;
+ (NSString *)decryptWithText:(NSString *)sText theKey:(NSString *)aKey;

@end
