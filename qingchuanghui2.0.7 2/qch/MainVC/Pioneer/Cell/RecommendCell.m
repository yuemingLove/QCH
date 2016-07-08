//
//  RecommendCell.m
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _Remark.numberOfLines = 0;
    _HeadImg.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
