//
//  MyOrderCell.m
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgkView.layer.masksToBounds=YES;
    _bgkView.layer.cornerRadius=2;
    // Initialization code
}


-(void)updateDate:(NSDictionary*)dict{

    _numberLabel.text=[dict objectForKey:@"t_Order_No"];
    
    NSInteger orderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
    
    if (orderType==1) {
        _nameLabel.text=@"充值";
    } else if (orderType==2) {
        _nameLabel.text=@"活动";
    }else if (orderType==3) {
        _nameLabel.text=@"众筹课程";
    }else if (orderType==4) {
        _nameLabel.text=@"课程";
    }
    
    if (state==0) {
        _statusLabel.text=@"未支付";
    } else {
        _statusLabel.text=@"已支付";
    }
    
    _priceLabel.text=[NSString stringWithFormat:@"¥%@",[dict objectForKey:@"t_Order_Money"]];
    _timeLabel.text=[dict objectForKey:@"t_Order_Date"];
    _orderName.text=[dict objectForKey:@"t_Order_Name"];
}
 

@end
