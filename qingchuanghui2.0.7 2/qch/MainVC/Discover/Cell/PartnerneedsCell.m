//
//  PartnerneedsCell.m
//  qch
//
//  Created by 青创汇 on 16/4/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartnerneedsCell.h"

@implementation PartnerneedsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateFrame:(NSDictionary*)dict{
    
    CGFloat width=(SCREEN_WIDTH-80*SCREEN_WSCALE)/3;
    NSMutableArray *ParterWantArray=[dict objectForKey:@"ParterWant"];
    if ([ParterWantArray count]>0) {
        
        NSInteger count=0;
        
        if([ParterWantArray count]%3==0){
            count=[ParterWantArray count]/3;
        }else{
            count=[ParterWantArray count]/3+1;
        }
        
        _fristView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40+40*count)];
        [self addSubview:_fristView];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        line.backgroundColor=[UIColor themeGrayColor];
        [_fristView addSubview:line];
        
        UILabel *investFrist=[self createLabelFrame:CGRectMake(14*SCREEN_WSCALE, 15, 120*SCREEN_WSCALE, 20) color:[UIColor lightGrayColor] font:Font(14) text:@"合伙人需求"];
        [_fristView addSubview:investFrist];
        
        for (int i=0; i<[ParterWantArray count]; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), investFrist.bottom+10+(i/3)*40, width, 30);
            NSDictionary *dict=[ParterWantArray objectAtIndex:i];
            [button setTitle:[dict objectForKey:@"ParterWant"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            button.layer.borderWidth=1;

            [_fristView addSubview:button];
        }
    }
}

- (void)setFrameHeight:(NSDictionary *)dict{
    
    //获得当前cell高度
    CGRect frame = [self frame];
    
    //计算出自适应的高度
    frame.size.height = _fristView.height;
    
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
