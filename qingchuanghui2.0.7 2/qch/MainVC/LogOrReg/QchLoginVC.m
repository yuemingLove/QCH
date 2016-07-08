//
//  QchLoginVC.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "QchLoginVC.h"
#import "QCHRegisterVC.h"
#import "QCHMainController.h"
#import "PerfectMeansVC.h"

@interface QchLoginVC ()<UITextFieldDelegate>{
    UIImageView *bkgImageView;
    
    UITextField *accountTfd;
    UITextField *passwordTfd;
    
    UIButton *backBtn;
}

@end

@implementation QchLoginVC

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createBackgroundImage{
    
    bkgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bkgImageView setImage:[UIImage imageNamed:@"denglu_bj2_img"]];
    [self.view addSubview:bkgImageView];
}

-(void)createBackBtn{
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15*SCREEN_WSCALE, 22*SCREEN_WSCALE, 24*SCREEN_WSCALE, 24*SCREEN_WSCALE);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(39*SCREEN_WSCALE, backBtn.top, SCREEN_WIDTH-39*2*SCREEN_WSCALE, backBtn.height)];
    titleLabel.text=@"登录";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=Font(18);
    [self.view addSubview:titleLabel];
}

-(void)createFrame{
    
    UIView *accountView=[[UIView alloc]initWithFrame:CGRectMake(30*SCREEN_WSCALE, 180*PMBWIDTH, SCREEN_WIDTH-60*SCREEN_WSCALE, 40*SCREEN_WSCALE)];
    [accountView setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    accountView.layer.masksToBounds=YES;
    accountView.layer.cornerRadius=accountView.height/2;
    
    UIImageView *accountIV=[[UIImageView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE, 7*SCREEN_WSCALE, 26*SCREEN_WSCALE, 26*SCREEN_WSCALE)];
    [accountIV setImage:[UIImage imageNamed:@"account"]];
    [accountView addSubview:accountIV];
    
    accountTfd=[[UITextField alloc]initWithFrame:CGRectMake(accountIV.right+10*SCREEN_WSCALE, accountIV.top, accountView.width-accountIV.width-33*SCREEN_WSCALE, accountIV.height)];
    accountTfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    accountTfd.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountTfd.font=Font(15);
    accountTfd.keyboardType=UIKeyboardTypeNumberPad;
    accountTfd.textColor=[UIColor whiteColor];
    accountTfd.delegate=self;
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
    passwordTfd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    passwordTfd.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordTfd.font=Font(15);
    passwordTfd.textColor=[UIColor whiteColor];
    passwordTfd.secureTextEntry=YES;
    [passwordView addSubview:passwordTfd];
    
    [self.view addSubview:passwordView];
    
    
    UIButton *registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(passwordView.left+14*SCREEN_WSCALE, passwordView.bottom+12*SCREEN_WSCALE, 80*SCREEN_WSCALE, 30*SCREEN_WSCALE)];
    [registerBtn setTitle:@"点击注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font=Font(14);
    [registerBtn addTarget:self action:@selector(registerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(passwordView.right-94*SCREEN_WSCALE, registerBtn.top, 80*SCREEN_WSCALE, 30*SCREEN_WSCALE)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=Font(14);
    [forgetBtn addTarget:self action:@selector(forgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
 
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(passwordView.left, registerBtn.bottom+20*SCREEN_WSCALE, passwordView.width, passwordView.height);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=loginBtn.height/2;
    [loginBtn addTarget:self action:@selector(loginVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == accountTfd)
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

-(void)loginVC:(id)sender{
    //如果完善过资料的跳转
    
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
    

    [SVProgressHUD showWithStatus:@"登录中……" maskType:SVProgressHUDMaskTypeBlack];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;//delegate.JPtoken
    NSString *token=[NSString stringWithFormat:@"%@",delegate.JPtoken];
    [HttpLoginAction loginWithAccount:[MyAes aesSecretWith:accountTfd.text] userPwd:[MyAes aesSecretWith:passwordTfd.text] androidRid:@"" IOSRid:token Token2:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array=[dict objectForKey:@"result"];
            NSDictionary *item=array[0];
            UserDefaultEntity.uuid=[item objectForKey:@"Guid"];
            UserDefaultEntity.account=[item objectForKey:@"t_User_LoginId"];
            UserDefaultEntity.telePhone=[item objectForKey:@"t_User_Mobile"];
            UserDefaultEntity.realName=[[item objectForKey:@"t_User_RealName"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.user_style=[item objectForKey:@"t_User_Style"];
            UserDefaultEntity.is_perfect=[(NSNumber *)[item objectForKey:@"t_User_Complete"]integerValue];
            UserDefaultEntity.t_User_Complete = [item objectForKey:@"t_User_Complete"];
            UserDefaultEntity.positionName=[item objectForKey:@"PositionName"];
            UserDefaultEntity.positionId = [item objectForKey:@"t_User_Position"];
            UserDefaultEntity.remark = [[item objectForKey:@"t_User_Remark"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.birDate = [item objectForKey:@"t_User_Birth"];
            UserDefaultEntity.user_city=[item objectForKey:@"t_User_City"];
            UserDefaultEntity.commpany=[[item objectForKey:@"t_User_Commpany"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
            UserDefaultEntity.headPath=[item objectForKey:@"t_User_Pic"];
            UserDefaultEntity.sex = [item objectForKey:@"t_User_Sex"];
            UserDefaultEntity.bgkPath=[item objectForKey:@"t_BackPic"];
            UserDefaultEntity.t_User_BusinessCard = [item objectForKey:@"t_User_BusinessCard"];
            UserDefaultEntity.t_User_InvestMoney = [item objectForKey:@"t_User_InvestMoney"];
            UserDefaultEntity.login_type = @"1";
            UserDefaultEntity.NowNeed = [NSString stringWithFormat:@"%lu",[[item objectForKey:@"NowNeed"]count]];
            
            [UserDefault saveUserDefault];
            
            NSArray *Ryarray=(NSArray*)[item objectForKey:@"t_RongCloud_Token"];
            
            if ([Ryarray count]>0) {
                NSDictionary *rongDict=Ryarray[0];
                UserDefaultEntity.userId=[rongDict objectForKey:@"userId"];
                UserDefaultEntity.token=[rongDict objectForKey:@"token"];
                [UserDefault saveUserDefault];
                
                [self linketoRongyun:UserDefaultEntity.token];
            }else{
                [self getRYToken:[item objectForKey:@"Guid"]];
            }

            if (UserDefaultEntity.is_perfect==1) {
                QCHMainController *main = [[QCHMainController alloc] init];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:SVProgressHUDMaskTypeBlack];
                    [self.navigationController pushViewController:main animated:YES];
            }else{
                PerfectMeansVC *perfect=[[PerfectMeansVC alloc]init];
                perfect.type=1;
                [SVProgressHUD dismiss];
                [self.navigationController pushViewController:perfect animated:YES];
            }
            
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"登录失败，请重新检测登录" maskType:SVProgressHUDMaskTypeBlack];
        }
        
    }];
}

-(void)registerBtn:(id)sender{
   
    QCHRegisterVC *registerVC=[[QCHRegisterVC alloc]init];
    registerVC.theme=@"注册";
    registerVC.type=1;
    [self.navigationController pushViewController:registerVC animated:YES];
}

-(void)forgetBtn:(id)sender{
    
    QCHRegisterVC *registerVC=[[QCHRegisterVC alloc]init];
    registerVC.theme=@"忘记密码";
    registerVC.type=3;
    [self.navigationController pushViewController:registerVC animated:YES];
}


@end
