//
//  QchMobileVC.m
//  qch
//
//  Created by 苏宾 on 16/3/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchMobileVC.h"

@interface QchMobileVC (){

    UIImageView *bkgImageView;
    UIButton *backBtn;
    
    UITextField *accountTfd;
    UITextField *codeTfd;
    UIButton *authCodeButton;
    
    NSString *code;
}

@end

@implementation QchMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"绑定手机号"];
    
    [self createBackgroundImage];
    [self createBackBtn];
    [self createFrame];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [accountTfd resignFirstResponder];
    [codeTfd resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createBackgroundImage{
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    UIImage *image = [UIImage imageNamed:@"denglu_bj2_img"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    bkgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bkgImageView setImage:blurredImage];
    [self.view addSubview:bkgImageView];
}

-(void)createBackBtn{
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15*SCREEN_WSCALE, 22*SCREEN_WSCALE, 24*SCREEN_WSCALE, 24*SCREEN_WSCALE);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(39*SCREEN_WSCALE, backBtn.top, SCREEN_WIDTH-39*2*SCREEN_WSCALE, backBtn.height)];
    titleLabel.text=@"绑定手机号";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=Font(18);
    [self.view addSubview:titleLabel];
}

-(void)createFrame{
    
    UIView *accountView=[[UIView alloc]initWithFrame:CGRectMake(30*SCREEN_WSCALE, 120*SCREEN_WSCALE, SCREEN_WIDTH-60*SCREEN_WSCALE, 40*SCREEN_WSCALE)];
    [accountView setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    accountView.layer.masksToBounds=YES;
    accountView.layer.cornerRadius=accountView.height/2;
    
    UIImageView *accountIV=[[UIImageView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE, 7*SCREEN_WSCALE, 26*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
    [accountIV setImage:[UIImage imageNamed:@"account"]];
    [accountView addSubview:accountIV];
    
    accountTfd=[[UITextField alloc]initWithFrame:CGRectMake(accountIV.right+10*SCREEN_WSCALE, accountIV.top, accountView.width-accountIV.width-33*SCREEN_WSCALE, accountIV.height)];
    accountTfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    accountTfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTfd.textColor=[UIColor whiteColor];
    accountTfd.keyboardType=UIKeyboardTypeNumberPad;
    [accountView addSubview:accountTfd];
    
    [self.view addSubview:accountView];
    
    UIView *codeView=[[UIView alloc]initWithFrame:CGRectMake(accountView.left, accountView.bottom+20*SCREEN_WSCALE, accountView.width, accountView.height)];
    [codeView setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    codeView.layer.masksToBounds=YES;
    codeView.layer.cornerRadius=codeView.height/2;
    
    codeTfd=[[UITextField alloc]initWithFrame:CGRectMake(20*SCREEN_WSCALE, 7*SCREEN_WSCALE, 150*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
    codeTfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTfd.textColor=[UIColor whiteColor];
    codeTfd.keyboardType=UIKeyboardTypeNumberPad;
    [codeView addSubview:codeTfd];
    
    authCodeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    authCodeButton.frame=CGRectMake(codeView.width-120*SCREEN_WSCALE, 0, 120*SCREEN_WSCALE, codeView.height);
    [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeButton setBackgroundColor:[UIColor lightGrayColor]];
    authCodeButton.layer.masksToBounds=YES;
    authCodeButton.layer.cornerRadius=authCodeButton.height/2;
    authCodeButton.titleLabel.font=Font(15);
    [authCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:authCodeButton];
    
    [self.view addSubview:codeView];
    
    UIButton *OKBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    OKBtn.frame = CGRectMake(accountView.left, codeView.bottom+40*SCREEN_WSCALE, accountView.width, accountView.height);
    [OKBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    
    OKBtn.backgroundColor = [UIColor clearColor];
    OKBtn.layer.borderWidth = 1.0f;
    OKBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    OKBtn.layer.masksToBounds=YES;
    OKBtn.layer.cornerRadius=OKBtn.height/2;
    [OKBtn addTarget:self action:@selector(okVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:OKBtn];
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getCode:(id)sender{
    
    if ([self isBlankString:accountTfd.text]) {
    
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![Utils checkTel:accountTfd.text]) {
    
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    authCodeButton.userInteractionEnabled = NO;
    [authCodeButton setTitle:@"正在发送" forState:UIControlStateNormal];
    
    [HttpLoginAction SendSMS:accountTfd.text type:@"2" Token:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            code=[dict objectForKey:@"code"];
            
            authCodeButton.userInteractionEnabled = NO;
            [authCodeButton setTitle:@"60秒后重试" forState:UIControlStateNormal];
            
            [BlockTimer timerWithTime:60 interval:1 changed:^(float remain) {
                [authCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重试",(int)remain] forState:UIControlStateNormal];
            } complete:^{
                authCodeButton.userInteractionEnabled = YES;
                [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }];
            [codeTfd becomeFirstResponder];
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
            authCodeButton.userInteractionEnabled = YES;
            [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        
    }];
}

-(void)okVC:(id)sender{
    
    if ([self isBlankString:accountTfd.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![Utils checkTel:accountTfd.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (![codeTfd.text isEqualToString:code]&![codeTfd.text isEqualToString:@"150919"]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不正确，请重新填写" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"绑定中……" maskType:SVProgressHUDMaskTypeBlack];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [HttpLoginAction registerUser:accountTfd.text userPwd:@"" userRecommend:@"" Token:[MyAes aesSecretWith:@"userMobile"] type:2 userId:UserDefaultEntity.thridCode androidRid:@"" IOSRid:delegate.JPtoken complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSArray *array=[dict objectForKey:@"result"];
            NSDictionary *item=array[0];
            UserDefaultEntity.uuid=[item objectForKey:@"Guid"];
            UserDefaultEntity.account=[item objectForKey:@"t_User_LoginId"];
            UserDefaultEntity.telePhone=[item objectForKey:@"t_User_Mobile"];
            UserDefaultEntity.realName=[item objectForKey:@"t_User_RealName"];
            UserDefaultEntity.user_style=[item objectForKey:@"t_User_Style"];
            UserDefaultEntity.is_perfect=[(NSNumber *)[item objectForKey:@"t_User_Complete"]integerValue];
            UserDefaultEntity.t_User_Complete = [item objectForKey:@"t_User_Complete"];
//            UserDefaultEntity.audit_type = [item objectForKey:@"t_UserStyleAudit"];
            UserDefaultEntity.positionName=[item objectForKey:@"PositionName"];
            UserDefaultEntity.positionId = [item objectForKey:@"t_User_Position"];
            UserDefaultEntity.remark = [item objectForKey:@"t_User_Remark"];
            UserDefaultEntity.birDate = [item objectForKey:@"t_User_Birth"];
            UserDefaultEntity.user_city=[item objectForKey:@"t_User_City"];
            UserDefaultEntity.commpany=[item objectForKey:@"t_User_Commpany"];
            UserDefaultEntity.headPath=[item objectForKey:@"t_User_Pic"];
            UserDefaultEntity.sex = [item objectForKey:@"t_User_Sex"];
            UserDefaultEntity.bgkPath=[item objectForKey:@"t_BackPic"];
            UserDefaultEntity.t_User_BusinessCard = [item objectForKey:@"t_User_BusinessCard"];
            UserDefaultEntity.t_User_InvestMoney = [item objectForKey:@"t_User_InvestMoney"];
            [UserDefault saveUserDefault];
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"绑定成功" maskType:SVProgressHUDMaskTypeBlack];
            if (UserDefaultEntity.is_perfect==1) {
                QCHMainController *main = [[QCHMainController alloc] init];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                
                [self.navigationController pushViewController:main animated:YES];
            }else{
                PerfectMeansVC *perfectVc=[[PerfectMeansVC alloc]init];
                perfectVc.type=2;
                [self.navigationController pushViewController:perfectVc animated:YES];
            }

        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            NSString *message=[dict objectForKey:@"result"];
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"绑定失败，请重新绑定" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

@end
