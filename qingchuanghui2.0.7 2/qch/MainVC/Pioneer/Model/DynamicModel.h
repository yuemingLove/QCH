//
//  DynamicModel.h
//  qch
//
//  Created by 青创汇 on 16/1/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicModel : NSObject

@property (nonatomic, strong) NSString *Guid;
@property (nonatomic, strong) NSArray *Pic;
@property (nonatomic, strong) NSString *PraiseCount;
@property (nonatomic, strong) NSMutableArray *PraiseUsers;
@property (nonatomic, strong) NSString *t_Topic_Latitude;
@property (nonatomic, strong) NSString *t_Topic_Top;
@property (nonatomic, strong) NSString *t_Date;
@property (nonatomic, strong) NSString *t_User_RealName;
@property (nonatomic, strong) NSString *t_Topic_Longitude;
@property (nonatomic, strong) NSString *t_Topic_Address;
@property (nonatomic, strong) NSString *t_User_LoginId;
@property (nonatomic, strong) NSString *t_Topic_Contents;
@property (nonatomic, strong) NSString *t_User_Pic;
@property (nonatomic, strong) NSString *t_User_Guid;
@property (nonatomic, strong) NSString *t_Topic_City;
@property (nonatomic, strong) NSString *ifPraise;
@property (nonatomic, strong) NSString *t_User_Commpany;
@property (nonatomic, strong) NSString *t_User_Position;
@property (nonatomic, strong) NSString *PositionName;
@property (nonatomic, strong) NSString *t_User_Style;
@property (nonatomic, strong) NSString *t_UserStyleAudit;
@property (nonatomic, strong) NSArray *Best;
@property (nonatomic, strong) NSArray *NowNeed;
@property (nonatomic, strong) NSArray *Intention;
@property (nonatomic, strong) NSString *talkcount;

@end
