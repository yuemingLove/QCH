//
//  HttpCollegeAction.h
//  qch
//
//  Created by 青创汇 on 16/4/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpCollegeAction : NSObject

+(void)GetLecturer:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+(void)GetLiveMedia:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+(void)GetCrowdfundlist:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+(void)GetFundCourseView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetRecommendFundCourse:(NSInteger)top userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetCourse:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;

+ (void)GetCourseView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

+ (void)GetLecturerView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//推荐导师列表
+ (void)GetRecommendLecturer:(NSInteger)top userGuid:(NSString*)userGuid lecturerGuid:(NSString*)lecturerGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//推荐课程列表
+ (void)GetRecommendCourse:(NSInteger)top userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block;

//系列课程列表
+ (void)GetGroupCourseList:(NSString *)groupguid userguid:(NSString *)userguid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block;


@end
