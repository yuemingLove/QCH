//
//  MyOrder.m
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyOrder.h"

@implementation MyOrder

- (instancetype)initWithDict:(NSDictionary*)dict{

    self=[super init];
    if (self) {
        
        self.Guid=[dict objectForKey:@"Guid"];
        self.t_Activity_CityName=[dict objectForKey:@"t_Activity_CityName"];
        self.t_Activity_Fee=[dict objectForKey:@"t_Activity_Fee"];
        self.t_Activity_Holder=[dict objectForKey:@"t_Activity_Holder"];
        self.t_Activity_Street=[dict objectForKey:@"t_Activity_Street"];
        self.t_Activity_Tel=[dict objectForKey:@"t_Activity_Tel"];
        self.t_Activity_Title=[dict objectForKey:@"t_Activity_Title"];
        self.t_Activity_eDate=[dict objectForKey:@"t_Activity_eDate"];
        self.t_Activity_sDate=[dict objectForKey:@"t_Activity_sDate"];
        self.t_Associate_Guid=[dict objectForKey:@"t_Associate_Guid"];
        self.t_Order_Date=[dict objectForKey:@"t_Order_Date"];
        self.t_Order_Money=[dict objectForKey:@"t_Order_Money"];
        self.t_Order_Name=[dict objectForKey:@"t_Order_Name"];
        self.t_Order_No=[dict objectForKey:@"t_Order_No"];
        self.t_Order_OrderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];
        self.t_Order_PayType=[dict objectForKey:@"t_Order_PayType"];
        self.t_Order_Remark=[dict objectForKey:@"t_Order_Remark"];
        self.t_Order_State=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
        self.t_User_Guid=[dict objectForKey:@"t_User_Guid"];
        self.t_User_LoginId=[dict objectForKey:@"t_User_LoginId"];
        self.t_User_RealName=[dict objectForKey:@"t_User_RealName"];
        
        self.isShowMoreText = NO;
    }
    return self;

}

@end
