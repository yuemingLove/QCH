//
//  BestAndDocell.m
//  qch
//
//  Created by 青创汇 on 16/3/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PreferencesCell.h"

@implementation PreferencesCell
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

-(void)updataFrame:(NSDictionary *)dict

{

    CGFloat width=(SCREEN_WIDTH-40*SCREEN_WSCALE)/3;
    NSArray *array3 = [dict objectForKey:@"Intention"];
    
    if ([array3 count]>0) {
        NSInteger count = 0;
        if ([array3 count]%3==0) {
            count = [array3 count]/3;
        }else{
            count = [array3 count]/3+1;
        }
        _thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*PMBWIDTH, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
        [self addSubview:_thirdView];
    }
    if (!intention) {
        intention = [self createLabelFrame:CGRectMake(12*PMBWIDTH, 10*PMBWIDTH, 120*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"创业意向"];
        [_thirdView addSubview:intention];
    }
    
    for (int i = 0; i<[array3 count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*PMBWIDTH+(i%3)*(width+10*PMBWIDTH), intention.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
        NSDictionary *dic = [array3 objectAtIndex:i];
        [button setTitle:[dic objectForKey:@"IntentionName"] forState:UIControlStateNormal];
        button.titleLabel.font = Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        button.layer.borderWidth=1;
        [_thirdView addSubview:button];
    }
    
    NSArray *array = [dict objectForKey:@"Best"];
    
    if ([array count]>0) {
        NSInteger count = 0;
        if ([array count]%3==0) {
            count = [array count]/3;
        }else{
            count = [array count]/3+1;
        }
            
        _fristView = [[UIView alloc]initWithFrame:CGRectMake(0, _thirdView.bottom, ScreenWidth, 30*PMBWIDTH+40*PMBWIDTH*count)];
        [self addSubview:_fristView];

        if (!investFrist) {
            investFrist=[self createLabelFrame:CGRectMake(12*SCREEN_WSCALE, 10*PMBWIDTH, 120*SCREEN_WSCALE, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"我最擅长"];
            [_fristView addSubview:investFrist];
        }
        
        for (int i = 0; i<[array count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10*SCREEN_WSCALE+(i%3)*(width+10*SCREEN_WSCALE), investFrist.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
            NSDictionary *dic = [array objectAtIndex:i];
            [button setTitle:[dic objectForKey:@"BestName"] forState:UIControlStateNormal];
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
    
    NSArray *array1 = [dict objectForKey:@"FoucsArea"];
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
            NSDictionary *dic = [array1 objectAtIndex:i];
            [button setTitle:[dic objectForKey:@"FoucsName"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            [_secordView addSubview:button];
        }
    }
    
    NSArray *array4 = [dict objectForKey:@"NowNeed"];
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
            NSDictionary *dic = [array4 objectAtIndex:i];
            [button setTitle:[dic objectForKey:@"NowNeedName"] forState:UIControlStateNormal];
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
    frame.size.height = _fristView.height+_secordView.height+15*PMBWIDTH+_thirdView.height+_fourView.height;
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
