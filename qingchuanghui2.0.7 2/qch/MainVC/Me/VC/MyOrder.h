//
//  MyOrder.h
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrder : NSObject


@property (nonatomic,strong) NSString *Guid;
@property (nonatomic,strong) NSString *t_Activity_CityName;
@property (nonatomic,strong) NSString *t_Activity_Fee;
@property (nonatomic,strong) NSString *t_Activity_Holder;
@property (nonatomic,strong) NSString *t_Activity_Street;
@property (nonatomic,strong) NSString *t_Activity_Tel;
@property (nonatomic,strong) NSString *t_Activity_Title;
@property (nonatomic,strong) NSString *t_Activity_eDate;
@property (nonatomic,strong) NSString *t_Activity_sDate;
@property (nonatomic,strong) NSString *t_Associate_Guid;
@property (nonatomic,strong) NSString *t_Order_Date;
@property (nonatomic,strong) NSString *t_Order_Money;
@property (nonatomic,strong) NSString *t_Order_Name;
@property (nonatomic,strong) NSString *t_Order_No;
@property (nonatomic,assign) NSInteger t_Order_OrderType;
@property (nonatomic,strong) NSString *t_Order_PayType;
@property (nonatomic,strong) NSString *t_Order_Remark;
@property (nonatomic,assign) NSInteger t_Order_State;
@property (nonatomic,strong) NSString *t_User_Guid;
@property (nonatomic,strong) NSString *t_User_LoginId;
@property (nonatomic,strong) NSString *t_User_RealName;



//是否展示全部
@property (nonatomic,assign) BOOL isShowMoreText;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
