//
//  MyInvestCell.m
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyInvestCell.h"

@implementation MyInvestCell

- (void)awakeFromNib {
    // Initialization code
    _pImageView.layer.masksToBounds=YES;
    _pImageView.layer.cornerRadius=_pImageView.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
