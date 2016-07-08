//
//  HttpBaseAction.h
//  qch
//
//  Created by 苏宾 on 16/1/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpCompleteBlock)(id result,NSError *error);

@interface HttpBaseAction : NSObject


+ (void)postMDRequest:(NSMutableDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block;

+(void)postDRequest:(NSDictionary *)parameters url:(NSString *)url complete:(HttpCompleteBlock)block;


+(void)getRequest:(NSString*)str complete:(HttpCompleteBlock)block;


+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail;

+ (void)alipayData:(NSString*)orderStr complete:(HttpCompleteBlock)block;

@end
