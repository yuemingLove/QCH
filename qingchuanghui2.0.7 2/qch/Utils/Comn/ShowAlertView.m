//
//  ShowAlertView.m
//  qingchuanghui
//
//  Created by 苏宾 on 15/12/16.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//

#import "ShowAlertView.h"

@implementation ShowAlertView

-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    
    self=[super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        /**UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceButtonClcik)];
        [view addGestureRecognizer:tap];**/
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        self.alpha = 1;
        [self creatView:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_textView resignFirstResponder];
}


-(void)creatView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{

    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor themeGrayColor];
    
    bgView.frame = CGRectMake(30*SCREEN_WSCALE, (SCREEN_HEIGHT-(320+64)*SCREEN_WSCALE)/2, SCREEN_WIDTH-60*SCREEN_WSCALE, 240*SCREEN_WSCALE);
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5*SCREEN_WSCALE, bgView.frame.size.width, 20*SCREEN_WSCALE)];
    titleLabel.text=title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=Font(15);
    titleLabel.textColor=[UIColor blackColor];
    [bgView addSubview:titleLabel];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 30*SCREEN_WSCALE, bgView.frame.size.width-20*SCREEN_WSCALE, 220*SCREEN_WSCALE) textContainer:NSTextAlignmentLeft];
    [_textView becomeFirstResponder];
    [bgView addSubview:_textView];
    
    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-40*SCREEN_WSCALE, bgView.width, 40*SCREEN_WSCALE)];
    btnView.backgroundColor=[UIColor themeGrayColor];
    [bgView addSubview:btnView];
    
    //确认按钮
    UIButton *fristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fristBtn.frame = CGRectMake(30, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);
    [fristBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [fristBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //sureButton.backgroundColor = [UIColor colorWithRed:0.420 green:1.000 blue:0.706 alpha:1.000];
    fristBtn.backgroundColor = [UIColor whiteColor];
    [fristBtn.layer setBorderWidth:1.0];
    fristBtn.layer.borderColor=[UIColor redColor].CGColor;
    fristBtn.layer.borderWidth=0.6;
    fristBtn.layer.cornerRadius=fristBtn.height/2;
    [fristBtn addTarget:self action:@selector(canceButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:fristBtn];
    
    UIButton *secordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
 
    secordBtn.frame = CGRectMake(bgView.width-120, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);
    [secordBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
    [secordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    secordBtn.backgroundColor = [UIColor whiteColor];
    [secordBtn.layer setBorderWidth:1.0];
    secordBtn.layer.borderColor=[UIColor blueColor].CGColor;
    secordBtn.layer.borderWidth=0.6;
    secordBtn.layer.cornerRadius=secordBtn.height/2;
    [secordBtn addTarget:self action:@selector(sureButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:secordBtn];

}

-(void)canceButtonClcik:(UIButton *)button{
    [self removeFromSuperview];
}

-(void)sureButtonClicik:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(updateTextViewData:)]) {
        [self.delegate updateTextViewData:_textView.text];
        [self removeFromSuperview];
    }
}


@end
