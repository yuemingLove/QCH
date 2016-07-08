//
//  MyAccountDetailsCell.m
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyAccountDetailsCell.h"

@implementation MyAccountDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currencyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8*PMBWIDTH, 5*PMBHEIGHT, 80, 15)];
    if (ScreenWidth > 380) {
        [self.currencyNumberLabel setFrame:CGRectMake(10*PMBWIDTH, 6*PMBHEIGHT, 80, 15)];
    } else if (ScreenWidth < 380 && ScreenWidth > 330) {
        [self.currencyNumberLabel setFrame:CGRectMake(7*PMBWIDTH, 5*PMBHEIGHT, 80, 15)];
    } else if(ScreenWidth < 330) {
        [self.currencyNumberLabel setFrame:CGRectMake(3*PMBWIDTH, 4*PMBHEIGHT, 80, 15)];
    }
    self.currencyNumberLabel.font = Font(13);
    self.currencyNumberLabel.text = @"5000";
    //self.currencyNumberLabel.backgroundColor = [UIColor cyanColor];
    self.currencyNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.currencyNumberLabel.textColor = TSEColor(85, 187, 214);
    [self.currencyImageView addSubview:_currencyNumberLabel];
    
    self.couponNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(21*PMBWIDTH, 5*PMBHEIGHT, 45, 15)];
    if (ScreenWidth > 380) {
        [self.couponNumberLabel setFrame:CGRectMake(21*PMBWIDTH, 6*PMBHEIGHT, 45, 15)];
    } else if(ScreenWidth < 330) {
        [self.couponNumberLabel setFrame:CGRectMake(20*PMBWIDTH, 5*PMBHEIGHT, 45, 15)];
    }
    self.couponNumberLabel.font = Font(13);
    self.couponNumberLabel.text = @"5000";
    self.couponNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.couponNumberLabel.textColor = TSEColor(143, 209, 255);
    [self.couponImageView addSubview:_couponNumberLabel];
    
    self.integralNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8*PMBWIDTH, 5*PMBHEIGHT, 80, 15)];
    if (ScreenWidth > 380) {
        [self.integralNumberLabel setFrame:CGRectMake(10*PMBWIDTH, 6*PMBHEIGHT, 80, 15)];
    } else if (ScreenWidth < 380 && ScreenWidth > 330) {
        [self.integralNumberLabel setFrame:CGRectMake(7*PMBWIDTH, 5*PMBHEIGHT, 80, 15)];
    } else if(ScreenWidth < 330) {
        [self.integralNumberLabel setFrame:CGRectMake(3*PMBWIDTH, 4*PMBHEIGHT, 80, 15)];
    }
    self.integralNumberLabel.font = Font(13);
    self.integralNumberLabel.text = @"5000";
    self.integralNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.integralNumberLabel.textColor = TSEColor(110, 151, 245);
    [self.integraImageView addSubview:_integralNumberLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickButtonAction:(UIButton *)sender {
    Liu_DBG(@"%ld", sender.tag);
    if ([self.delegate respondsToSelector:@selector(clickTheAccountButton:)]) {
        [self.delegate clickTheAccountButton:sender.tag];
    }
}

@end
