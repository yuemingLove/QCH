//
//  MyAccountCell.m
//  qch
//
//  Created by 苏宾 on 16/3/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyAccountCell.h"

@implementation MyAccountCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgkView.layer.masksToBounds=YES;
    _bgkView.layer.cornerRadius=2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
