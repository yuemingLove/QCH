//
//  PersonInfomationVC.h
//  qch
//
//  Created by 青创汇 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface PersonInfomationVC : QchBaseViewController

@property (nonatomic,strong)NSMutableArray *HistoryWorkArray;
@property (nonatomic,strong)NSString *BestIDstr;
@property (nonatomic,strong)NSString *DomainIDstr;
@property (nonatomic,strong)NSString *BestStr;
@property (nonatomic,strong)NSString *DomainStr;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *IntentionName;
@property (nonatomic,strong)NSString *IntentionIDStr;
@property (nonatomic,strong)NSString *NowNeedName;
@property (nonatomic,strong)NSString *NowNeedID;

@end
