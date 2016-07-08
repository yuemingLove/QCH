//
//  HttpMessageAction.h
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpMessageAction : NSObject

+ (void)GetHistoryPush:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)DelHistoryPush:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)GetMessageCount:(NSString*)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)EditReadPush:(NSString*)Guid type:(NSString *)type Token:(NSString *)Token complete:(HttpCompleteBlock)block;
@end
