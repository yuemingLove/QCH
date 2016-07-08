//
//  HttpDiscoverAction.h
//  qch
//
//  Created by 苏宾 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpDiscoverAction : NSObject

+ (void)GetNewsList:(NSInteger)page pagesize:(NSInteger)pagesize style:(NSString*)style province:(NSString *)province Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)GetData:(NSString *)Token complete:(HttpCompleteBlock)block;


+ (void)AddPersonal:(NSDictionary *)dict complete:(HttpCompleteBlock)block;


+ (void)Discovery:(NSString *)Token complete:(HttpCompleteBlock)block;
@end
