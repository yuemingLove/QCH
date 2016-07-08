//
//  PActivityModel.h
//  qch
//
//  Created by 苏宾 on 16/1/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PActivityModel : NSObject

@property (nonatomic,strong) NSString *ApplyCount;
@property (nonatomic,strong) NSString *Guid;
@property (nonatomic,strong) NSString *ifPraise;
@property (nonatomic,strong) NSString *t_Activity_CityName;
@property (nonatomic,strong) NSString *t_Activity_CoverPic;
@property (nonatomic,strong) NSString *t_Activity_Fee;
@property (nonatomic,strong) NSString *t_Activity_FeeType;
@property (nonatomic,strong) NSString *t_Activity_Latitude;
@property (nonatomic,strong) NSString *t_Activity_LimitPerson;
@property (nonatomic,strong) NSString *t_Activity_Longitude;
@property (nonatomic,strong) NSString *t_Activity_Street;
@property (nonatomic,strong) NSString *t_Activity_Tel;
@property (nonatomic,strong) NSString *t_Activity_Title;
@property (nonatomic,strong) NSString *t_Activity_eDate;
@property (nonatomic,strong) NSString *t_Activity_sDate;
@property (nonatomic,strong) NSString *t_AddDate;
@property (nonatomic,strong) NSString *t_User_Guid;
@property (nonatomic,strong) NSString *t_User_LoginId;
@property (nonatomic,strong) NSString *t_User_Pic;
@property (nonatomic,strong) NSString *t_User_RealName;
@property (nonatomic,strong) NSString *t_Activity_Holder;
@property (nonatomic,strong) NSString *OneWord;
@property (nonatomic,strong) NSString *t_Activity_Audit;

@property (nonatomic,strong) NSString *t_User_Position;
@property (nonatomic,strong) NSString *t_User_Commpany;
@property (nonatomic,strong) NSString *ifApply;
@property (nonatomic,strong) NSString *ifOver;
@property (nonatomic,strong) NSString *PositionName;
@property (nonatomic,strong) NSString *ApplyUsers;

@end
