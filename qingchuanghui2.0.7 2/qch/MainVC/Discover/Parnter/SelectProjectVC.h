//
//  SelectProjectVC.h
//  qch
//
//  Created by 苏宾 on 16/3/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol SelectProjectVCDelegate <NSObject>

-(void)selectProject:(NSString *)projectGuid;

@end

@interface SelectProjectVC : QchBaseViewController

@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,assign) id<SelectProjectVCDelegate>spDelegate;

@end
