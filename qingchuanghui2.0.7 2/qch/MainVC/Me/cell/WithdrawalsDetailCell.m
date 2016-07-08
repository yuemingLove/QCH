//
//  WithdrawalsDetailCell.m
//  qch
//
//  Created by W.兵 on 16/7/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "WithdrawalsDetailCell.h"

@implementation WithdrawalsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateInfoWith:(NSDictionary *)dic {
    NSInteger state=[(NSNumber*)[dic objectForKey:@"t_Withdrawal_State"]integerValue];
    switch (state) {//0 待审核 1已审核 2 已拒绝
        case 0:
        {
            [self.withdrawalsStatus setImage:[UIImage imageNamed:@"new_check_in"]];
        }
            break;
        case 1:
        {
            [self.withdrawalsStatus setImage:[UIImage imageNamed:@"new_check_s"]];
        }
            break;
        case 2:
        {
            [self.withdrawalsStatus setImage:[UIImage imageNamed:@"new_check_f"]];
        }
            break;
        default:
            break;
    }
    self.withdrawalsNO.text = [NSString stringWithFormat:@"单号: %@", [dic objectForKey:@"t_Withdrawal_NO"]];
    self.withdrawalsBank.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"t_Bank_Name"]];
    self.withdrawalsBankNO.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"t_Bank_NO"]];
    self.withdrawalsMoney.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"t_Withdrawal_Money"]];
    self.applyDate.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"t_AddDate"]];
    self.checkDate.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"t_StateDate"]];

}

@end
