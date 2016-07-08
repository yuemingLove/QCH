//
//  ProjectDetCell.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectDetCell.h"

@implementation ProjectDetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
    
}

- (void)_initView{
    
    
    UIView *hline=[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    hline.backgroundColor=[UIColor themeGrayColor];
    [self addSubview:hline];
    
    
    UILabel *cityName=[self createLabelFrame:CGRectMake(10, 10*SCREEN_WSCALE, 70, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"所在城市:"];
    [self addSubview:cityName];
    
    _cityStr=[self createLabelFrame:CGRectMake(cityName.right+10, cityName.top, SCREEN_WIDTH-cityName.width-30, cityName.height) color:[UIColor blackColor] font:Font(14) text:@"郑州"];
    [self addSubview:_cityStr];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(cityName.left, cityName.bottom+10, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line];
    
    UILabel *fieldName=[self createLabelFrame:CGRectMake(10, line.bottom+10, 70, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"项目领域:"];
    [self addSubview:fieldName];
    
    _fieldStr=[self createLabelFrame:CGRectMake(fieldName.right+10, fieldName.top, SCREEN_WIDTH-fieldName.width-30, cityName.height) color:[UIColor blackColor] font:Font(14) text:@"餐饮"];
    [self addSubview:_fieldStr];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(cityName.left, fieldName.bottom+10, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line1 setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line1];
    
    UILabel *pStatusLabel=[self createLabelFrame:CGRectMake(10, line1.bottom+10, 70, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"项目阶段:"];
    [self addSubview:pStatusLabel];
    
    _pStatusStr=[self createLabelFrame:CGRectMake(pStatusLabel.right+10, pStatusLabel.top, SCREEN_WIDTH-pStatusLabel.width-30, cityName.height) color:[UIColor blackColor] font:Font(14) text:@"已盈利"];
    [self addSubview:_pStatusStr];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, pStatusLabel.bottom+10, SCREEN_WIDTH, 5*PMBWIDTH)];
    [line2 setBackgroundColor:[UIColor themeGrayColor]];
    [self addSubview:line2];
    
}

-(UILabel *)createLabelFrame:(CGRect)frame color:(UIColor*)color font:(UIFont *)font text:(NSString *)text{
    
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.font=font;
    label.textColor=color;
    label.textAlignment=NSTextAlignmentLeft;
    label.text=text;
    
    return label;
}

@end
