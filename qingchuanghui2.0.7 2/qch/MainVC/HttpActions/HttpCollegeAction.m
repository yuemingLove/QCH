//
//  HttpCollegeAction.m
//  qch
//
//  Created by 青创汇 on 16/4/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "HttpCollegeAction.h"

@implementation HttpCollegeAction

+(void)GetLecturer:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"key=%@&userGuid=%@&page=%ld&pagesize=%ld&token=%@",key,userGuid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@Lecturer_WebService.asmx/GetLecturer?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetLiveMedia:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"page=%ld&pagesize=%ld&token=%@",page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@LiveMedia_WebService.asmx/GetLiveMedia?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetCrowdfundlist:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize :(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"key=%@&userGuid=%@&page=%ld&pagesize=%ld&Token=%@",key,userGuid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@FundCourse_WebService.asmx/GetFundCourse?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetFundCourseView:(NSString *)guid userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&userGuid=%@&Token=%@",guid,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@FundCourse_WebService.asmx/GetFundCourseView?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
    
}

+(void)GetRecommendFundCourse:(NSInteger)top userGuid:(NSString *)userGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block
{
    NSString *mothed = [NSString stringWithFormat:@"top=%ld&userGuid=%@&Token=%@",top,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@FundCourse_WebService.asmx/GetRecommendFundCourse?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetCourse:(NSString *)key userGuid:(NSString *)userGuid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"key=%@&userGuid=%@&page=%ld&pagesize=%ld&Token=%@",key,userGuid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@Course_WebService.asmx/GetCourse?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetCourseView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&userGuid=%@&Token=%@",guid,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Course_WebService.asmx/GetCourseView?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetLecturerView:(NSString *)guid userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"guid=%@&userGuid=%@&Token=%@",guid,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Lecturer_WebService.asmx/GetLecturerView?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+(void)GetRecommendLecturer:(NSInteger)top userGuid:(NSString *)userGuid lecturerGuid:(NSString *)lecturerGuid Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"top=%ld&userGuid=%@&lecturerGuid=%@&Token=%@",top,userGuid,lecturerGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Course_WebService.asmx/GetLecturerCourse?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetRecommendCourse:(NSInteger)top userGuid:(NSString*)userGuid Token:(NSString*)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"top=%ld&userGuid=%@&Token=%@",top,userGuid,Token];
    NSString *path = [NSString stringWithFormat:@"%@Course_WebService.asmx/GetRecommendCourse?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}

+ (void)GetGroupCourseList:(NSString *)groupguid userguid:(NSString *)userguid page:(NSInteger)page pagesize:(NSInteger)pagesize Token:(NSString *)Token complete:(HttpCompleteBlock)block{
    
    NSString *mothed = [NSString stringWithFormat:@"groupguid=%@&userguid=%@&page=%ld&pagesize=%ld&Token=%@",groupguid,userguid,page,pagesize,Token];
    NSString *path = [NSString stringWithFormat:@"%@Course_WebService.asmx/GetGroupCourseList?",SERIVE_URL];
    NSString *url = [NSString stringWithFormat:@"%@%@",path,mothed];
    
    [HttpBaseAction getRequest:url complete:^(id result, NSError *error) {
        if (error == nil && result) {
            block(result,nil);
        }else{
            block(nil,error);
        }
    }];
}


@end
