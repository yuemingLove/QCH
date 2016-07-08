//
//  ProjectDetailVC.h
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface ProjectDetailVC : QchBaseViewController

@property (nonatomic,strong) NSDictionary *projectDict;

@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *guId;
@property (nonatomic, strong) void(^updateNav)();

@end
