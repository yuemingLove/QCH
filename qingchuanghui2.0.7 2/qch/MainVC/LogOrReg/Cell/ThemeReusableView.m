//
//  ThemeReusableView.m
//  Jpbbo
//
//  Created by jpbbo on 15/8/29.
//  Copyright (c) 2015年 河南金马电子商务股份有限公司. All rights reserved.
//

#import "ThemeReusableView.h"

@implementation ThemeReusableView

- (void)awakeFromNib {
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line];
}

@end
