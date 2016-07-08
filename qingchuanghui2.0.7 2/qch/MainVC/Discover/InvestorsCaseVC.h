//
//  InvestorsCaseVC.h
//  qch
//
//  Created by 青创汇 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

typedef void (^ReturnMutableArray)(NSMutableArray *InvestCase);


@interface InvestorsCaseVC : QchBaseViewController

@property (nonatomic,copy)ReturnMutableArray returnArrayblock;

- (void)returnArray:(ReturnMutableArray)block;
@end
