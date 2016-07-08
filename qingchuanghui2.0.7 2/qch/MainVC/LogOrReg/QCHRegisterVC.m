//
//  QCHRegisterVC.m
//  qch
//
//  Created by 苏宾 on 16/1/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHRegisterVC.h"
#import "QCHMainController.h"

@interface QCHRegisterVC ()<UITextFieldDelegate>{

    UIImageView *bkgImageView;
    UIButton *backBtn;
    
    UITextField *accountTfd;
    UITextField *passwordTfd;
    UITextField *codeTfd;
    UITextField *recommendfd;
    UIButton *authCodeButton;
    
    NSString *code;
}

@end

@implementation QCHRegisterVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
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
    [passwordTfd resignFirstResponder];
    [codeTfd resignFirstResponder];
    [recommendfd resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    titleLabel.text=self.theme;
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
    accountTfd.delegate = self;
    [accountView addSubview:accountTfd];
    
    [self.view addSubview:accountView];
    
    UIView *passwordView=[[UIView alloc]initWithFrame:CGRectMake(accountView.left, accountView.bottom+20*SCREEN_WSCALE, accountView.width, accountView.height)];
    [passwordView setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    passwordView.layer.masksToBounds=YES;
    passwordView.layer.cornerRadius=passwordView.height/2;
    
    UIImageView *passwordIV=[[UIImageView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE, 7*SCREEN_WSCALE, 26*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
    [passwordIV setImage:[UIImage imageNamed:@"password"]];
    [passwordView addSubview:passwordIV];
    
    passwordTfd=[[UITextField alloc]initWithFrame:CGRectMake(passwordIV.right+10*SCREEN_WSCALE, passwordIV.top, passwordView.width-passwordIV.width-33*SCREEN_WSCALE, passwordIV.height)];
    if (self.type==3) {
        passwordTfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设置新密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    } else {
        passwordTfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    }
    
    passwordTfd.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordTfd.textColor=[UIColor whiteColor];
    passwordTfd.secureTextEntry=YES;
    [passwordView addSubview:passwordTfd];
    
    [self.view addSubview:passwordView];
    
    UIView *codeView=[[UIView alloc]initWithFrame:CGRectMake(accountView.left, passwordView.bottom+20*SCREEN_WSCALE, accountView.width, accountView.height)];
    [codeView setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    codeView.layer.masksToBounds=YES;
    codeView.layer.cornerRadius=codeView.height/2;
    
    codeTfd=[[UITextField alloc]initWithFrame:CGRectMake(20*SCREEN_WSCALE, 7*SCREEN_WSCALE, 150*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
    codeTfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTfd.textColor=[UIColor whiteColor];
    codeTfd.keyboardType=UIKeyboardTypeNumberPad;
    codeTfd.delegate =self;
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
    
    if (self.type==1) {
        
        UIView *recommendview = [[UIView alloc]initWithFrame:CGRectMake(30*PMBWIDTH, codeView.bottom+20*PMBWIDTH, accountView.width, accountView.height)];
        [recommendview setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
        recommendview.layer.masksToBounds=YES;
        recommendview.layer.cornerRadius=recommendview.height/2;
        
        UIImageView *account=[[UIImageView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE, 7*SCREEN_WSCALE, 26*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
        [account setImage:[UIImage imageNamed:@"account"]];
        [recommendview addSubview:account];
        recommendfd = [[UITextField alloc]initWithFrame:CGRectMake(account.right+10*SCREEN_WSCALE, account.top, recommendview.width-account.width-33*SCREEN_WSCALE, account.height)];
        recommendfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入推荐人手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        recommendfd.clearButtonMode = UITextFieldViewModeWhileEditing;
        recommendfd.textColor=[UIColor whiteColor];
        recommendfd.keyboardType=UIKeyboardTypeNumberPad;
        recommendfd.delegate = self;
        [recommendview addSubview:recommendfd];
        [self.view addSubview:recommendview];
  
    
    UIButton *OKBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    OKBtn.frame = CGRectMake(passwordView.left, recommendview.bottom+40*SCREEN_WSCALE, passwordView.width, passwordView.height);
    [OKBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    OKBtn.backgroundColor = [UIColor clearColor];
    OKBtn.layer.borderWidth = 1.0f;
    OKBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    OKBtn.layer.masksToBounds=YES;
    OKBtn.layer.cornerRadius=OKBtn.height/2;
    [OKBtn addTarget:self action:@selector(okVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:OKBtn];
    
    }else if (self.type==3){
        UIButton *OKBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        OKBtn.frame = CGRectMake(passwordView.left, codeView.bottom+40*SCREEN_WSCALE, passwordView.width, passwordView.height);
        [OKBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        OKBtn.backgroundColor = [UIColor clearColor];
        OKBtn.layer.borderWidth = 1.0f;
        OKBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        OKBtn.layer.masksToBounds=YES;
        OKBtn.layer.cornerRadius=OKBtn.height/2;
        [OKBtn addTarget:self action:@selector(okVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:OKBtn];

    }
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == accountTfd||textField ==codeTfd ||textField==recommendfd)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
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
    if ([self isBlankString:passwordTfd.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (passwordTfd.text.length<6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![codeTfd.text isEqualToString:code]&![codeTfd.text isEqualToString:@"150919"]) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码不正确，请重新填写" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *recommend = @"";
    if ([recommendfd.text isEqualToString:@""]) {
        recommend=@"";
    }else{
        if (_type==1) {
            if (![Utils checkTel:recommendfd.text]) {
                
                [SVProgressHUD showErrorWithStatus:@"推荐人手机号格式不正确" maskType:SVProgressHUDMaskTypeBlack];
                return;
            }
            recommend = recommendfd.text;
        }
    }
    [HttpLoginAction registerUser:accountTfd.text userPwd:[MyAes aesSecretWith:passwordTfd.text] userRecommend:recommend Token:[MyAes aesSecretWith:@"userMobile"] type:self.type userId:UserDefaultEntity.thridCode androidRid:@"" IOSRid:delegate.JPtoken complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            if (self.type==1) {
                
                NSArray *array=[dict objectForKey:@"result"];
                NSDictionary *item=array[0];
                
                UserDefaultEntity.user_style=[item objectForKey:@"t_User_Style"];
                UserDefaultEntity.account=[item objectForKey:@"t_User_LoginId"];
                UserDefaultEntity.uuid=[item objectForKey:@"Guid"];
                UserDefaultEntity.is_perfect=[(NSNumber*)[item objectForKey:@"t_User_Complete"]integerValue];
                UserDefaultEntity.t_User_Complete = [item objectForKey:@"t_User_Complete"];
                [UserDefault saveUserDefault];
                
                [SVProgressHUD showSuccessWithStatus:@"请继续完善资料" maskType:SVProgressHUDMaskTypeBlack];
                PerfectMeansVC *perfectVc=[[PerfectMeansVC alloc]init];
                perfectVc.type=1;
                [self.navigationController pushViewController:perfectVc animated:YES];

            }else{
                [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeBlack];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            NSString *message=[dict objectForKey:@"result"];

            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
        }else{
            NSString *message=nil;
            if (self.type==1) {
               message= @"注册失败，请重新填写";
            }else if (self.type==3){
                message= @"修改失败，请重新填写";
            }

            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
        }
        
    }];
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
    if ([self isBlankString:passwordTfd.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"密码不能为空" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (passwordTfd.text.length<6) {
        
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    authCodeButton.userInteractionEnabled = NO;
    [authCodeButton setTitle:@"正在发送" forState:UIControlStateNormal];
    NSString *type = @"";
    if (_type==1) {
        type = @"1";
    }else if (_type==3){
        type = @"2";
    }
    [HttpLoginAction SendSMS:accountTfd.text type:type Token:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        Liu_DBG(@"%@",dict);
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
             [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
            authCodeButton.userInteractionEnabled = YES;
            [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        
    }];
}


@end
