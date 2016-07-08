//
//  DiscoverCell.m
//  qch
//
//  Created by 青创汇 on 16/6/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DiscoverCell.h"

@implementation DiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _Icon.layer.cornerRadius=_Icon.height/2;
    _Icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
