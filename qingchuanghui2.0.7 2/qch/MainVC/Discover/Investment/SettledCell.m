//
//  SettledCell.m
//  qch
//
//  Created by 青创汇 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SettledCell.h"

@implementation SettledCell

- (void)awakeFromNib {
    // Initialization code
    _HeadImg.layer.cornerRadius = _HeadImg.height/2;
    _HeadImg.layer.masksToBounds = YES;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(_HeadImg.left, _HeadImg.bottom+5*PMBWIDTH, ScreenWidth-_HeadImg.left, 1)];
    line.backgroundColor = [UIColor themeGrayColor];
    [self addSubview:line];
}



@end
