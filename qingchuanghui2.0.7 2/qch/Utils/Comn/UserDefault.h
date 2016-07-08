//
//  UserDefault.h
//  Jyg
//
//  Created by 苏宾 on 15/12/24.
//  Copyright © 2015年 wubing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserDefaultEntity             [UserDefault currentDefault]

#define CityZoneCode                    ([[NSUserDefaults standardUserDefaults] objectForKey:@"zoneCode"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"zoneCode"]:@"4101")

#define CityZoneName                   ([[NSUserDefaults standardUserDefaults] objectForKey:@"CityName"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"CityName"]:@"郑州市")

@interface UserDefault : NSObject

@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *uuid;     //用户guid
@property(nonatomic,strong) NSString* account;  //用户t_User_LoginId
@property(nonatomic,strong) NSString* zoneCode;
@property(nonatomic,strong) NSString* realName; //用户真实姓名
@property(nonatomic,strong) NSString* nickName; //用户昵称
@property(nonatomic,strong) NSString* telePhone;// 用户电话

@property(nonatomic,strong) NSString *number;

@property(nonatomic,strong) NSString* mailAdd;
@property(nonatomic,strong) NSString* birDate;
@property(nonatomic,strong) NSString* sex;

@property(nonatomic,strong) NSString *user_style;
@property(nonatomic,strong) NSString *user_city;
@property(nonatomic,strong) NSString *commpany;
@property(nonatomic,strong) NSString *positionName;
@property(nonatomic,strong) NSString *positionId;
@property (nonatomic,strong) NSString *remark;
@property(nonatomic,strong)NSString *t_User_InvestMoney;
@property(nonatomic,strong)NSString *t_User_BusinessCard;
@property(nonatomic,strong)NSString *Coupon;


@property(nonatomic,strong) NSString* headPath;
@property(nonatomic,strong) NSString* splashPath;
@property (nonatomic,strong) NSString *bgkPath;
@property (nonatomic,strong) NSString *login_type;
@property(nonatomic,strong) NSString *NowNeed;



//第三方授权码
@property(nonatomic,strong) NSString *thridCode;

//是否完善个人资料
@property(nonatomic,assign) NSInteger is_perfect;
@property(nonatomic,strong) NSString * t_User_Complete;

//融云信息
@property (nonatomic, strong) NSArray *cardPic;
@property (nonatomic, strong) NSArray *rongCloudToken;

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *token;

//当前用户的位置result.addressDetail.province,result.addressDetail.city,result.addressDetail.district
@property (nonatomic,assign) float longitude;
@property (nonatomic,assign) float latitude;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,strong) NSArray *poilist;
//@property (nonatomic,strong) NSString *userName;
//@property (nonatomic,strong) NSString *IDnumber;
//@property (nonatomic,strong) NSString *t_Bank_Name;
//@property (nonatomic,strong) NSString *t_Bank_NO;
//@property (nonatomic,strong) NSString *t_Bank_OpenUser;
//@property (nonatomic,strong) NSString *bankGuid;

//投资人审核状态：0:审核中；1:审核成功；2：审核失败
@property (nonatomic,strong) NSString *audit_type;


+(UserDefault *)currentDefault;
+(void)saveUserDefault;
//将类objcet存到userDefault里面，对应的key值为strKey
+(BOOL)saveObject:(id)object key:(NSString *)strKey;
//根据key为strKey获取存入的类
+(id)getObject:(NSString *)strKey;

@end
