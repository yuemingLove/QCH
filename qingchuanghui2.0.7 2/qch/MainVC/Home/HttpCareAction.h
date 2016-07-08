//
//  HttpCareAction.h
//  qch
//
//  Created by W.兵 on 16/6/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpCareAction : NSObject
// 关注列表
+ (void)getCarelist:(NSString *)userGuid city:(NSString *)city page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

@end
