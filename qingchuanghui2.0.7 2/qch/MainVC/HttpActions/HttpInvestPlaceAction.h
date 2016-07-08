//
//  HttpInvestPlaceAction.h
//  qch
//
//  Created by 青创汇 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpInvestPlaceAction : NSObject

//投资机构列表
+(void)GetInvestPlaceList:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

// 投资机构详情
+(void)GetInvestPlaceView:(NSString*)guid Token:(NSString *)Token complete:(HttpCompleteBlock)block;


+ (void)AddInvestPlaceProject:(NSString*)projectGuid investplaceGuid:(NSString*)investplaceGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block;


@end
