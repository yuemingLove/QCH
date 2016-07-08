//
//  DeductionVoucherCell.m
//  qch
//
//  Created by W.兵 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DeductionVoucherCell.h"

@implementation DeductionVoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor themeGrayColor];
    self.exchangeButton.layer.cornerRadius = _exchangeButton.height/2;
    self.exchangeButton.layer.masksToBounds = YES;
    self.exchangeButton.layer.borderWidth = 1;
    self.exchangeButton.layer.borderColor = [UIColor themeBlueColor].CGColor;
    _titleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updata:(NSDictionary *)dict
{
    
    NSString *money = [dict objectForKey:@"T_Voucher_Price"];
    _amountLabel.text = [money substringToIndex:money.length-3];
    if ([[dict objectForKey:@"T_Voucher_Type"]isEqualToString:@"1"]) {
        _typeLabel.text = @"抵扣券";
    }else if ([[dict objectForKey:@"T_Voucher_Type"]isEqualToString:@"2"]){
        _typeLabel.text = @"代用券";
    }else if ([[dict objectForKey:@"T_Voucher_Type"]isEqualToString:@"3"]){
        _typeLabel.text = @"随机折扣券";
    }
    _titleLabel.text = [dict objectForKey:@"T_Remark"];
    NSString *str = [NSString stringWithFormat:@"积分%@",[dict objectForKey:@"T_Voucher_Price"]];
    _integrationLabel.text =[str substringToIndex:str.length-3];
    
}
@end
