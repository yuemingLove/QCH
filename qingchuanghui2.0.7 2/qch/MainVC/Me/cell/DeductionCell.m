//
//  DeductionCell.m
//  qch
//
//  Created by 青创汇 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DeductionCell.h"

@implementation DeductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor themeGrayColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateData:(NSDictionary *)dict
{
    _DeductionLab.text = [NSString stringWithFormat:@"%@元现金代金券",[dict objectForKey:@"T_Voucher_Price"]];
    _Ramark.text = [dict objectForKey:@"T_Remark"];
    _TimeLab.text = [NSString stringWithFormat:@"有效期至%@",[dict objectForKey:@"edate"]];
    _Money.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"T_Voucher_Price"]];
    if ([[dict objectForKey:@"isvalid"]isEqualToString:@"0"]) {
        _LeftbackImg.image = [UIImage imageNamed:@"my_dikouquan"];
        _EffectImg.hidden= YES;
    }else if ([[dict objectForKey:@"isvalid"]isEqualToString:@"1"]){
        _LeftbackImg.image = [UIImage imageNamed:@"dikouquan guoqi"];
        _EffectImg.hidden = NO;
    }
    
}
@end
