//
//  ActivityPayVC.h
//  qch
//
//  Created by 苏宾 on 16/2/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface ActivityPayVCN : QchBaseViewController

@property (nonatomic, strong) NSDictionary *orderDic;
@property (nonatomic,strong) NSString *titlestr;
@property (nonatomic,assign) float price;
@property (nonatomic,strong) NSString *orderNum;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy)void (^dealBlock)();

@end
