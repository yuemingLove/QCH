//
//  OrderDetailVC.h
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface OrderDetailVC : QchBaseViewController

@property (nonatomic,strong) NSString *Guid;
@property (nonatomic, assign) BOOL orderType;// 支付类型: 充值0, 课程1

@end
