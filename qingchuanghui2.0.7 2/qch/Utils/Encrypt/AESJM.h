//
//  AESJM.h
//  IWant
//
//  Created by aa on 15/4/18.
//  Copyright (c) 2015年 aa. All rights reserved.
//

//头文件
#import <Foundation/Foundation.h>

@interface NSData (AES)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end