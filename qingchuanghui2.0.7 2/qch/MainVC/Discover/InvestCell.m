//
//  InvestCell.m
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestCell.h"

@implementation InvestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateFrame:(NSDictionary*)dict{
    
    CGFloat width=(SCREEN_WIDTH-40*SCREEN_WSCALE)/3;

    NSMutableArray *ParterWantArray=(NSMutableArray*)[dict objectForKey:@"InvestArea"];
    
    if ([ParterWantArray count]>0) {
        
        NSInteger count=0;
        
        if([ParterWantArray count]%3==0){
            count=[ParterWantArray count]/3;
        }else{
            count=[ParterWantArray count]/3+1;
        }
        
        _fristView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30+40*count)];
        [self addSubview:_fristView];
        
        UILabel *investFrist=[self createLabelFrame:CGRectMake(14*SCREEN_WSCALE, 10, 120*SCREEN_WSCALE, 20) color:[UIColor blackColor] font:Font(14) text:@"投资领域"];
        [_fristView addSubview:investFrist];
        
        for (int i=0; i<[ParterWantArray count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10*SCREEN_WSCALE+(i%3)*(width+10*SCREEN_WSCALE), investFrist.bottom+10+(i/3)*40, width, 30*PMBWIDTH);
            NSDictionary *dict=[ParterWantArray objectAtIndex:i];
            [button setTitle:[dict objectForKey:@"InvestAreaName"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            
            [_fristView addSubview:button];
        }
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(investFrist.left, investFrist.bottom+40*count+10*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1)];
        line.backgroundColor=[UIColor themeGrayColor];
        [_fristView addSubview:line];
    }
    
    
    NSMutableArray *ParterWant=(NSMutableArray*)[dict objectForKey:@"InvestPhase"];
    if ([ParterWant count]>0) {
        
        NSInteger cout=0;
        
        if([ParterWant count]%3==0){
            cout=[ParterWant count]/3;
        }else{
            cout=[ParterWant count]/3+1;
        }
        
        _secordView=[[UIView alloc]initWithFrame:CGRectMake(0, _fristView.bottom, SCREEN_WIDTH, 30+40*cout)];
        [self addSubview:_secordView];
        
        UILabel *investSecord=[self createLabelFrame:CGRectMake(14*SCREEN_WSCALE, 20, 120*SCREEN_WSCALE, 20) color:[UIColor blackColor] font:Font(14) text:@"投资阶段"];
        [_secordView addSubview:investSecord];
        
        for (int i=0; i<[ParterWant count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(10*SCREEN_WSCALE+(i%3)*(width+10*SCREEN_WSCALE), investSecord.bottom+10+(i/3)*40, width, 30*PMBWIDTH);
            NSDictionary *dict=[ParterWant objectAtIndex:i];
            [button setTitle:[dict objectForKey:@"InvestPhaseName"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;
            
            [_secordView addSubview:button];
        }
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(investSecord.left, investSecord.bottom+40*cout+10*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 1)];
        line2.backgroundColor=[UIColor themeGrayColor];
        [_secordView addSubview:line2];

    }
    
    _thridView=[[UIView alloc]initWithFrame:CGRectMake(0, _secordView.bottom, SCREEN_WIDTH, 90)];
    [self addSubview:_thridView];
    
    UILabel *investThrid=[self createLabelFrame:CGRectMake(14*SCREEN_WSCALE, 30, 120*SCREEN_WSCALE, 20) color:[UIColor blackColor] font:Font(14) text:@"投资金额"];
    [_thridView addSubview:investThrid];
    
    UILabel *contentLabel=[self createLabelFrame:CGRectMake(investThrid.left, investThrid.bottom+10, SCREEN_WIDTH-15*SCREEN_WSCALE, investThrid.height) color:[UIColor grayColor] font:Font(13) text:@""];
    [_thridView addSubview:contentLabel];
    
    if (_type==1) {
        contentLabel.text=[dict objectForKey:@"t_InvestPlace_Money"];
    }else{
        contentLabel.text=[dict objectForKey:@"t_User_InvestMoney"];
    }
}

- (void)setFrameHeight:(NSDictionary *)dict{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //计算出自适应的高度
    frame.size.height = _fristView.height+_secordView.height+_thridView.height;
    
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
