//
//  OrderModel.h
//  qch
//
//  Created by 苏宾 on 16/3/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *contactRealName;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *orderPrice;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *orderStatusCode;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *playDate;
@property (nonatomic, copy) NSString *tcount;
@property (nonatomic, copy) NSString *nu;

- (id)initWithDictionary:(NSDictionary *)dic;


@end
