//
//  InvestorsInformationVC.h
//  qch
//
//  Created by 青创汇 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface InvestorsInformationVC : QchBaseViewController

@property (nonatomic,strong) NSMutableArray *InvestArray;
@property (nonatomic,strong)NSString *DomainIDstr;
@property (nonatomic,strong)NSString *StateIDstr;
@property (nonatomic,strong)NSString *DomainStr;
@property (nonatomic,strong)NSString *StateStr;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *purpose;
@property (nonatomic,strong)NSString *purposeID;
@property (nonatomic,strong)NSString *Best;
@property (nonatomic,strong)NSString *Bestid;
@property (nonatomic,strong)NSString *Attentionstr;
@property (nonatomic,strong)NSString *Attentionid;
@property (nonatomic,strong)NSString *NowneedStr;
@property (nonatomic,strong)NSString *NowneedID;
@property (nonatomic,assign)BOOL IforNo;
@end
