//
//  MyOrderFirstCell.m
//  qch
//
//  Created by W.兵 on 16/6/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyOrderSecondCell.h"

@implementation MyOrderSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.orderButton.layer.cornerRadius = self.orderButton.height /  2;
    self.orderButton.layer.masksToBounds = YES;
    self.orderButton.layer.borderWidth = 1;
    self.orderButton.layer.borderColor = [UIColor themeBlueColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateDate:(NSDictionary*)dict{
    
    NSInteger orderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
    NSDictionary *temDic = [[dict objectForKey:@"assoctiate"] firstObject];
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[temDic objectForKey:@"pic"]];
    [self.publicProgramsIcon sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    self.titleLabel.text = [temDic objectForKey:@"title"];
    
    if (orderType==1) {
        self.publicProgramsLabel.text=@"充值";
        self.publicProgramsImage.image = [UIImage imageNamed:@"order_recharge"];
    } else if (orderType==2) {
        self.publicProgramsLabel.text=@"活动";
        self.publicProgramsImage.image = [UIImage imageNamed:@"order_activity"];
    }else if (orderType==3) {
        self.publicProgramsLabel.text=@"众筹课程";
        self.publicProgramsImage.image = [UIImage imageNamed:@"order_public_programs"];
    }else if (orderType==4) {
        self.publicProgramsLabel.text=@"课程";
        self.publicProgramsImage.image = [UIImage imageNamed:@"order_public_programs"];
    }else if (orderType==5){
        self.publicProgramsLabel.text = @"空间";
        self.publicProgramsImage.image = [UIImage imageNamed:@"order_room"];
    }
    
    if (state==0) {
        self.stateLabel.text=@"未支付";
    } else {
        self.stateLabel.text=@"已支付";
    }
    
    self.moneyLabel.text=[NSString stringWithFormat:@"¥%@",[dict objectForKey:@"t_Order_Money"]];
    self.orderNumberLabel.text=[NSString stringWithFormat:@"订单编号: %@",[dict objectForKey:@"t_Order_No"]];
    self.orderDateLabel.text=[NSString stringWithFormat:@"订单时间: %@",[dict objectForKey:@"t_Order_Date"]];
}

- (IBAction)orderAction:(UIButton *)sender {
    // 去支付
    if (self.orderBlock) {
        self.orderBlock();
    }
}

@end
