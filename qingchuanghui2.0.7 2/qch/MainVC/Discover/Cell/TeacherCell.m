//
//  TeacherCell.m
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TeacherCell.h"

@implementation TeacherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _position.hidden=YES;
    _IconImg.layer.cornerRadius = _IconImg.height/2;
    _IconImg.layer.masksToBounds = YES;
    _IconImg.backgroundColor = [UIColor lightGrayColor];
    _Remark.numberOfLines = 0;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bottom-1*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
