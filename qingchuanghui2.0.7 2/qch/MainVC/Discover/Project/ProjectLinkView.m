//
//  ProjectLinkView.m
//  qch
//
//  Created by 青创汇 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectLinkView.h"

@implementation ProjectLinkView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}
-(void)_initView {
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 5*PMBWIDTH, ScreenWidth, 5*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [self addSubview:line];
    
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, line.bottom+5*PMBWIDTH, ScreenWidth, 15*PMBWIDTH)];
    titlelab.text = @"项目链接（选填）";
    titlelab.textColor = [UIColor lightGrayColor];
    titlelab.font = Font(15);
    [self addSubview:titlelab];
    
    NSArray *menuArray = @[@"官网",@"客户端",@"微信公众号"];
    CGFloat width = (ScreenWidth-30*PMBWIDTH)/3;
    
    for (int i=0; i<[menuArray count]; i++) {
        NSString *name=[menuArray objectAtIndex:i];
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE+width*i, titlelab.bottom+10*PMBWIDTH, width, 100*PMBWIDTH)];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"wangzhi_btn%d",i]] forState:UIControlStateNormal];
        button.tag = i;
        if (button.tag == 0) {
            [self setButton1Block:^{
                [button setImage:[UIImage imageNamed:@"wangzhi_btn0_n"] forState:UIControlStateNormal];
            }];
        } else if(button.tag == 1) {
            [self setButton2Block:^{
                [button setImage:[UIImage imageNamed:@"wangzhi_btn1_n"] forState:UIControlStateNormal];
            }];
        } else {
            [self setButton3Block:^{
                [button setImage:[UIImage imageNamed:@"wangzhi_btn2_n"] forState:UIControlStateNormal];
            }];
        }
        [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+8*PMBWIDTH, btnView.width, 16*SCREEN_WSCALE)];
        
        nameLabel.text=name;
        nameLabel.font=Font(15);
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [btnView addSubview:nameLabel];
        [self addSubview:btnView];
    }
    
    _nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextbtn.frame = CGRectMake(0, 0, 180*PMBWIDTH, 30*PMBWIDTH);
    _nextbtn.center = CGPointMake(ScreenWidth/2, titlelab.bottom+160*PMBWIDTH);
    [_nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextbtn.backgroundColor = TSEColor(161, 201, 240);
    _nextbtn.titleLabel.font = Font(14);
    _nextbtn.layer.cornerRadius = _nextbtn.height/2;
    [self addSubview:_nextbtn];
    
}

- (void)ButtonClicked:(UIButton *)sender
{
    if ([self.linkdelegate respondsToSelector:@selector(selectClicked:index:)]) {
        [self.linkdelegate selectClicked:sender index:[sender tag]];
    }
}

@end
