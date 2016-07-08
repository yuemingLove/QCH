//
//  BindBankCardVC2VC.h
//  qch
//
//  Created by W.兵 on 16/7/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@interface BindBankCardVC2VC : QchBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNOLabel;
@property (weak, nonatomic)  NSString *name;
@property (weak, nonatomic)  NSString *bank;
@property (weak, nonatomic)  NSString *bankNO;
@end
