//
//  CarePersonListViewController.h
//  qch
//
//  Created by 青创汇 on 16/1/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
#import "CarePersonCell.h"

@interface CarePersonListVC : QchBaseViewController

@property (nonatomic,strong) NSMutableArray *model;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) BOOL if_push;

@end
