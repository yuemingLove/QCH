//
//  WithdrawalsDetailCell.h
//  qch
//
//  Created by W.兵 on 16/7/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsDetailCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsNO;// 单号
@property (weak, nonatomic) IBOutlet UIImageView *withdrawalsStatus;// 状态
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsBank;// 提现银行
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsBankNO;// 提现银行卡号
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsMoney;// 提现金额
@property (weak, nonatomic) IBOutlet UILabel *applyDate;// 申请时间
@property (weak, nonatomic) IBOutlet UILabel *checkDate;// 审核时间
@property (weak, nonatomic) IBOutlet UILabel *failReason;// 审核失败原因

- (void)updateInfoWith:(NSDictionary *)dic;

@end
