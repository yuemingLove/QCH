//
//  CommitAlertView.m
//  qch
//
//  Created by 苏宾 on 16/3/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CommitAlertView.h"

@implementation CommitAlertView

-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles textViewPlaceholder:(NSString *)placeHolder {

    self=[super init];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        UIView *view=[[UIView alloc]init];
//        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.8;
            [self addSubview:view];
            
            [self creatView:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles  textViewPlaceholder:placeHolder ];
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            CATransition *applicationLoadViewIn =[CATransition animation];
//            [applicationLoadViewIn setDuration:0.5];
//            [applicationLoadViewIn setType:kCATransitionFromBottom];
//            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//            [[self layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];

//        } completion:^(BOOL finished) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
            //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
            tapGestureRecognizer.cancelsTouchesInView = NO;
            //将触摸事件添加到当前view
            [self addGestureRecognizer:tapGestureRecognizer];
//        }];
        
    }
    
    return self;
}

-(void)creatView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  textViewPlaceholder:(NSString *)placeHolder {
    
    bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor themeGrayColor];
    
    bgView.frame = CGRectMake(10*SCREEN_WSCALE, (SCREEN_HEIGHT-(260+64)*SCREEN_WSCALE)/2, SCREEN_WIDTH-20*SCREEN_WSCALE, 160*SCREEN_WSCALE);
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
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(5*SCREEN_WSCALE, 30*SCREEN_WSCALE, bgView.frame.size.width-10*SCREEN_WSCALE, 125*SCREEN_WSCALE) textContainer:NSTextAlignmentLeft];
    [_textView becomeFirstResponder];
    _textView.delegate=self;
    _textView.font=Font(14);
    if (placeHolder) {
        _textView.text = [NSString stringWithFormat:@"%@", placeHolder];
    }
    [bgView addSubview:_textView];
    
    _placeholder=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, _textView.width, 20)];
    _placeholder.textColor=[UIColor lightGrayColor];
    [_textView addSubview:_placeholder];
    
//    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-40*SCREEN_WSCALE, bgView.width, 40*SCREEN_WSCALE)];
//    btnView.backgroundColor=[UIColor themeGrayColor];
//    [bgView addSubview:btnView];
    
    //确认按钮
    UIButton *fristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //fristBtn.frame = CGRectMake(30, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);
    fristBtn.frame = CGRectMake(5, 0*SCREEN_WSCALE, 50*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    [fristBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    fristBtn.titleLabel.font = Font(14);
    //[fristBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fristBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //sureButton.backgroundColor = [UIColor colorWithRed:0.420 green:1.000 blue:0.706 alpha:1.000];
    //fristBtn.backgroundColor = [UIColor redColor];
    //[fristBtn.layer setBorderWidth:1.0];
    //fristBtn.layer.borderColor=[UIColor colorWithRed:224. / 255 green:224. / 255 blue:224. / 255 alpha:1.000].CGColor;
    //fristBtn.layer.borderWidth=0.6;
    //fristBtn.layer.cornerRadius=fristBtn.height/2;
    [fristBtn addTarget:self action:@selector(canceButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:fristBtn];
    // 取消按钮
    UIButton *secordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    //secordBtn.frame = CGRectMake(bgView.width-120, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);(SCREEN_HEIGHT-(320+64)*SCREEN_WSCALE)/2
    secordBtn.frame = CGRectMake(bgView.width-55*SCREEN_WSCALE, 0*SCREEN_WSCALE, 50*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    [secordBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
    [secordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    secordBtn.titleLabel.font = Font(14);
    //secordBtn.backgroundColor = [UIColor redColor];
    //[secordBtn.layer setBorderWidth:1.0];
    //secordBtn.layer.borderColor=[UIColor colorWithRed:162. / 255 green:201. / 255 blue:240. / 255 alpha:1.000].CGColor;
    //secordBtn.layer.borderWidth=0.6;
    //secordBtn.layer.cornerRadius=secordBtn.height/2;
    [secordBtn addTarget:self action:@selector(sureButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:secordBtn];
    
}
-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    self=[super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *view=[[UIView alloc]init];
        //        [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.8;
        [self addSubview:view];
        
        [self creatView:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //            CATransition *applicationLoadViewIn =[CATransition animation];
        //            [applicationLoadViewIn setDuration:0.5];
        //            [applicationLoadViewIn setType:kCATransitionFromBottom];
        //            [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        //            [[self layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        
        //        } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self addGestureRecognizer:tapGestureRecognizer];
        //        }];
        
    }
    
    return self;
}

-(void)creatView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    
    bgView = [[UIView alloc] init];
    bgView.alpha = 1;
    bgView.backgroundColor = [UIColor themeGrayColor];
    
    bgView.frame = CGRectMake(10*SCREEN_WSCALE, (SCREEN_HEIGHT-(260+64)*SCREEN_WSCALE)/2, SCREEN_WIDTH-20*SCREEN_WSCALE, 160*SCREEN_WSCALE);
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
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(5*SCREEN_WSCALE, 30*SCREEN_WSCALE, bgView.frame.size.width-10*SCREEN_WSCALE, 125*SCREEN_WSCALE) textContainer:NSTextAlignmentLeft];
    [_textView becomeFirstResponder];
    _textView.delegate=self;
    _textView.font=Font(14);
    [bgView addSubview:_textView];
    
    _placeholder=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, _textView.width, 20)];
    _placeholder.textColor=[UIColor lightGrayColor];
    [_textView addSubview:_placeholder];
    
    //    UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-40*SCREEN_WSCALE, bgView.width, 40*SCREEN_WSCALE)];
    //    btnView.backgroundColor=[UIColor themeGrayColor];
    //    [bgView addSubview:btnView];
    
    //确认按钮
    UIButton *fristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //fristBtn.frame = CGRectMake(30, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);
    fristBtn.frame = CGRectMake(5, 0*SCREEN_WSCALE, 50*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    [fristBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    fristBtn.titleLabel.font = Font(14);
    //[fristBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fristBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //sureButton.backgroundColor = [UIColor colorWithRed:0.420 green:1.000 blue:0.706 alpha:1.000];
    //fristBtn.backgroundColor = [UIColor redColor];
    //[fristBtn.layer setBorderWidth:1.0];
    //fristBtn.layer.borderColor=[UIColor colorWithRed:224. / 255 green:224. / 255 blue:224. / 255 alpha:1.000].CGColor;
    //fristBtn.layer.borderWidth=0.6;
    //fristBtn.layer.cornerRadius=fristBtn.height/2;
    [fristBtn addTarget:self action:@selector(canceButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:fristBtn];
    // 取消按钮
    UIButton *secordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    //secordBtn.frame = CGRectMake(bgView.width-120, bgView.frame.size.height-40*SCREEN_WSCALE, 80, 30);(SCREEN_HEIGHT-(320+64)*SCREEN_WSCALE)/2
    secordBtn.frame = CGRectMake(bgView.width-55*SCREEN_WSCALE, 0*SCREEN_WSCALE, 50*SCREEN_WSCALE, 30*SCREEN_WSCALE);
    [secordBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
    [secordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    secordBtn.titleLabel.font = Font(14);
    //secordBtn.backgroundColor = [UIColor redColor];
    //[secordBtn.layer setBorderWidth:1.0];
    //secordBtn.layer.borderColor=[UIColor colorWithRed:162. / 255 green:201. / 255 blue:240. / 255 alpha:1.000].CGColor;
    //secordBtn.layer.borderWidth=0.6;
    //secordBtn.layer.cornerRadius=secordBtn.height/2;
    [secordBtn addTarget:self action:@selector(sureButtonClicik:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:secordBtn];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap {
    [_textView resignFirstResponder];
//    [UIView animateWithDuration:0.3 animations:^{
//        bgView.frame = CGRectMake(10*SCREEN_WSCALE, SCREEN_HEIGHT-150*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, 160*SCREEN_WSCALE);
//    }];
}

-(void)canceButtonClcik:(UIButton *)button{

    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"取消功",@"textOne", nil];
    /*
     *  创建通知
     *  通过通知中心发送通知
     */
    NSNotification *notifiction = [NSNotification notificationWithName:@"quxiao" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notifiction];
    
    [self removeFromSuperview];
        
}

-(void)sureButtonClicik:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(updateTextViewData:)]) {
        [self.delegate updateTextViewData:_textView.text];
        [self removeFromSuperview];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        _placeholder.hidden=YES;
    }else{
        _placeholder.hidden=NO;
    }
}

@end
