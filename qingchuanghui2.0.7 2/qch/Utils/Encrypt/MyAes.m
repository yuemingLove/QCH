//
//  MyAes.m
//  IWant
//
//  Created by aa on 15/4/20.
//  Copyright (c) 2015年 aa. All rights reserved.
//

#import "MyAes.h"
#import "AESJM.h"

@implementation MyAes

+ (NSString *)aesSecretWith:(NSString *)content {
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSString *sss = [[data AES256EncryptWithKey:@"F0C93DCC7B24FBB4555242C9B0074FCY"] base64EncodedStringWithOptions:0];
    return sss;
}

@end
