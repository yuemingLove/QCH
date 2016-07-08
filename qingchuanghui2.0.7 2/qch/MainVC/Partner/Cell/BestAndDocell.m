//
//  BestAndDocell.m
//  qch
//
//  Created by 青创汇 on 16/3/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "BestAndDocell.h"
#import "Intention.h"
#import "NowNeed.h"
@implementation BestAndDocell
{
        UILabel *investFrist;
        UILabel *investSecord;
        UILabel *intention;
        UILabel *nowneed;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateFrame:(PartnerResult *)model
{
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, 120*PMBWIDTH, 20*PMBWIDTH)];
    titlelab.text = @"创业偏好";
    titlelab.font = Font(14);
    [self addSubview:titlelab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(titlelab.left, titlelab.bottom+10*PMBWIDTH, ScreenWidth-10*PMBWIDTH, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [self addSubview:line];
    
    
    CGFloat width=(SCREEN_WIDTH-40*SCREEN_WSCALE)/3;
    NSArray *array3 = model.intention;
    
    if ([array3 count]>0) {
        NSInteger count = 0;
        if ([array3 count]%3==0) {
            count = [array3 count]/3;
        }else{
            count = [array3 count]/3+1;
        }
        _thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, line.bottom, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
        [self addSubview:_thirdView];
    }
    if (!intention) {
        intention = [self createLabelFrame:CGRectMake(12*PMBWIDTH, 10*PMBWIDTH, 120*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"创业意向"];
        [_thirdView addSubview:intention];
    }
    
    for (int i = 0; i<[array3 count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*PMBWIDTH+(i%3)*(width+10*PMBWIDTH), intention.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
        Intention *Intention = [array3 objectAtIndex:i];
        [button setTitle:Intention.intentionName forState:UIControlStateNormal];
        button.titleLabel.font = Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        button.layer.borderWidth=1;
        [_thirdView addSubview:button];
    }
    
    NSArray *array = model.best;
    
    if ([array count]>0) {
        NSInteger count = 0;
        if ([array count]%3==0) {
            count = [array count]/3;
        }else{
            count = [array count]/3+1;
        }
        if ([model.intention count]==0) {
            _fristView = [[UIView alloc]initWithFrame:CGRectMake(0, line.bottom, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
            [self addSubview:_fristView];
        }else{
            
            _fristView = [[UIView alloc]initWithFrame:CGRectMake(0, _thirdView.bottom, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
            [self addSubview:_fristView];
        }
        if (!investFrist) {
            investFrist=[self createLabelFrame:CGRectMake(12*SCREEN_WSCALE, 10*PMBWIDTH, 120*SCREEN_WSCALE, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"我最擅长"];
            [_fristView addSubview:investFrist];
        }
        
        for (int i = 0; i<[array count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10*SCREEN_WSCALE+(i%3)*(width+10*SCREEN_WSCALE), investFrist.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
            Best *best = [array objectAtIndex:i];
            [button setTitle:best.bestName forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            
            [_fristView addSubview:button];
        }
        
//        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(investFrist.left, investFrist.bottom+40*count+10*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*PMBWIDTH)];
//        line.backgroundColor=[UIColor themeGrayColor];
//        [_fristView addSubview:line];
    }
    
    NSArray *array1 = model.foucsArea;
    if ([array1 count]>0) {
        NSInteger cout = 0;
        if ([array1 count]%3==0) {
            cout = [array1 count]/3;
        }else{
            cout = [array1 count]/3+1;
        }
        _secordView=[[UIView alloc]initWithFrame:CGRectMake(0, _fristView.bottom, SCREEN_WIDTH, 30*PMBWIDTH+40*PMBWIDTH*cout)];
        [self addSubview:_secordView];
        if (!investSecord) {
            investSecord=[self createLabelFrame:CGRectMake(investFrist.left, 10*PMBWIDTH, investFrist.width, investFrist.height) color:[UIColor blackColor] font:Font(14) text:@"关注领域"];
            [_secordView addSubview:investSecord];
        }
        
        for (int i = 0; i<[array1 count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10*SCREEN_WSCALE+(i%3)*(width+10*SCREEN_WSCALE),investSecord.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
            FoucsArea *fouce = [array1 objectAtIndex:i];
            [button setTitle:fouce.foucsName forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            [_secordView addSubview:button];
        }
    }
    
    NSArray *array4 = model.nowNeed;
    if ([array4 count]>0) {
        NSInteger count = 0;
        if ([array4 count]%3==0) {
            count = [array4 count]/3;
        }else{
            count =[array4 count]/3+1;
        }
        _fourView = [[UIView alloc]initWithFrame:CGRectMake(0, _secordView.bottom, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
        [self addSubview:_fourView];
        
        if (!nowneed) {
            nowneed = [self createLabelFrame:CGRectMake(investSecord.left, 10*PMBWIDTH, investSecord.width, investSecord.height) color:[UIColor blackColor] font:Font(14) text:@"现阶段需求"];
            [_fourView addSubview:nowneed];
            
        }
        for (int i = 0; i <[array4 count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10*PMBWIDTH+(i%3)*(width+10*PMBWIDTH), intention.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
            NowNeed *need= [array4 objectAtIndex:i];
            [button setTitle:need.nowNeedName forState:UIControlStateNormal];
            button.titleLabel.font = Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            [_fourView addSubview:button];
        }
        [self addSubview:_fourView];
    }
    
    CGRect frame = [self frame];
    frame.size.height = _fristView.height+_secordView.height+50*PMBWIDTH+_thirdView.height+_fourView.height;
    self.frame = frame;
    
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
