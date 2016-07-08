//
//  TeachersCell.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TeachersCell.h"

@implementation TeachersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    _IconImg.layer.cornerRadius = _IconImg.height/2;
    _IconImg.backgroundColor = [UIColor lightGrayColor];
    _IconImg.layer.masksToBounds = YES;
    _Remarklab.numberOfLines = 0;
    _Remarklab.text = @"看见多哈客户端双卡双待开始疯狂就会收到捐款繁花似锦的客户飞机上的不废江河是大部分绝对是抱佛脚还是大部分金黄色的不废江河";

}


@end
