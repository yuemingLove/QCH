//
//  MyOrderFirstCell.m
//  qch
//
//  Created by W.兵 on 16/6/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyOrderFourCell.h"

@implementation MyOrderFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.payButton.layer.cornerRadius = self.payButton.height /  2;
    self.payButton.layer.masksToBounds = YES;
    self.payButton.layer.borderWidth = 1;
    self.payButton.layer.borderColor = [UIColor themeBlueColor].CGColor;

}
-(void)updateDate:(NSDictionary*)dict{
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
    
    if (state==0) {
        self.stateLabel.text=@"未支付";
    } else {
        self.stateLabel.text=@"已支付";
    }
    
    self.moneyLabel.text=[NSString stringWithFormat:@"¥%@",[dict objectForKey:@"t_Order_Money"]];
    self.orderNumberLabel.text=[NSString stringWithFormat:@"订单编号: %@",[dict objectForKey:@"t_Order_No"]];
    self.orderDateLabel.text=[NSString stringWithFormat:@"订单时间: %@",[dict objectForKey:@"t_Order_Date"]];
}
- (IBAction)payAction:(UIButton *)sender {
    // 去支付
    if (self.orderBlock) {
        self.orderBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
