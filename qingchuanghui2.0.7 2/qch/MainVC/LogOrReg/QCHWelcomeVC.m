//
//  QCHWelcomeVC.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHWelcomeVC.h"
#import "QchLoginVC.h"
#import "QCHRegisterVC.h"
#import "QCHMainController.h"
#import "QchMobileVC.h"

@interface QCHWelcomeVC (){
    NSTimer     *timer;            //计时器
    BOOL        isleft;
    UIImageView *bkgImageView;
    
    UIImageView *loginimg;
    UIButton *loginBtn;
    UIButton *WXBtn;
    UIButton *WbBtn;
    NSInteger if_audit;
    
}

@property (nonatomic,strong) AppDelegate *appDelegate;

@end

@implementation QCHWelcomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createView];
    [self ifAuditStatus];
    bkgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, SCREEN_HEIGHT)];
    isleft = YES;
    [bkgImageView setImage:[UIImage imageNamed:@"denglu_bj1_img@2x.jpg"]];
    [self.view addSubview:bkgImageView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)ifAuditStatus{
    [HttpLoginAction OnOffTravel:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            if_audit=[(NSNumber*)[dict objectForKey:@"result"]integerValue];
            if (if_audit==0) {
                UIButton *ykBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                if (SCREEN_HEIGHT>480) {
                    ykBtn.frame=CGRectMake(loginBtn.left, WbBtn.bottom+20*SCREEN_WSCALE, loginBtn.width, loginBtn.height);
                }else{
                    ykBtn.frame=CGRectMake(loginBtn.left, WbBtn.bottom+20, loginBtn.width, loginBtn.height);
                }
                [ykBtn setTitle:@"游客模式登录" forState:UIControlStateNormal];
                ykBtn.backgroundColor = [UIColor clearColor];
                ykBtn.layer.borderWidth = 1.0f;
                ykBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
                ykBtn.layer.masksToBounds=YES;
                ykBtn.layer.cornerRadius=loginBtn.height/2;
                [ykBtn addTarget:self action:@selector(ykmsLogin:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:ykBtn];
            }
            
        }
    }];
}

-(void)createView{
    
    if (SCREEN_HEIGHT>480) {
        loginimg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -81*SCREEN_WSCALE)/2, 50*SCREEN_WSCALE, 81*SCREEN_WSCALE, 116*SCREEN_WSCALE)];
    }else{
        loginimg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -80)/2, 50, 81, 116)];
    }
    
    [loginimg setImage:[UIImage imageNamed:@"login_logo"]];
    [self.view addSubview:loginimg];
    
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (SCREEN_HEIGHT>480) {
        loginBtn.frame = CGRectMake(30*SCREEN_WSCALE, loginimg.bottom+80*SCREEN_WSCALE,SCREEN_WIDTH-60*SCREEN_WSCALE, 40*SCREEN_WSCALE);
    }else{
        loginBtn.frame = CGRectMake(30, SCREEN_HEIGHT-280,SCREEN_WIDTH-60, 40);
    }
    
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=loginBtn.height/2;
    [loginBtn addTarget:self action:@selector(loginVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    
    //微信登陆
    WXBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (SCREEN_HEIGHT>480) {
        WXBtn.frame=CGRectMake(loginBtn.left, loginBtn.bottom+20*SCREEN_WSCALE, loginBtn.width, loginBtn.height);
    } else {
        WXBtn.frame=CGRectMake(loginBtn.left, loginBtn.bottom+15, loginBtn.width, loginBtn.height);
    }
    
    [WXBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [WXBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    [WXBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [WXBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    WXBtn.backgroundColor = [UIColor clearColor];
    WXBtn.layer.borderWidth = 1.0f;
    WXBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    WXBtn.layer.masksToBounds=YES;
    WXBtn.layer.cornerRadius=loginBtn.height/2;
    [WXBtn addTarget:self action:@selector(WXloginVC:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:WXBtn];

    WbBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (SCREEN_HEIGHT>480) {
        WbBtn.frame=CGRectMake(loginBtn.left, WXBtn.bottom+20*SCREEN_WSCALE, loginBtn.width, loginBtn.height);
    }else{
        WbBtn.frame=CGRectMake(loginBtn.left, WXBtn.bottom+20, loginBtn.width, loginBtn.height);
    }
    
    [WbBtn setImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
    [WbBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    [WbBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    [WbBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    WbBtn.backgroundColor = [UIColor clearColor];
    WbBtn.layer.borderWidth = 1.0f;
    WbBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    WbBtn.layer.masksToBounds=YES;
    WbBtn.layer.cornerRadius=loginBtn.height/2;
    [WbBtn addTarget:self action:@selector(WbloginVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WbBtn];
    
    
    
    UITapGestureRecognizer *readbook=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readBook:)];
    [readbook setNumberOfTapsRequired:1];
    UILabel *AgreeLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-240*SCREEN_WSCALE)/2, SCREEN_HEIGHT-40*SCREEN_WSCALE, 240*SCREEN_WSCALE, 40*SCREEN_WSCALE)];
    [AgreeLabel setFont:[UIFont systemFontOfSize:13]];
    [AgreeLabel setText:@"注册即表示同意《青创汇》用户协议"];
    [AgreeLabel setTextColor:[UIColor whiteColor]];
    AgreeLabel.textAlignment=NSTextAlignmentCenter;
    [AgreeLabel setUserInteractionEnabled:YES];
    [AgreeLabel addGestureRecognizer:readbook];
    [self.view addSubview:AgreeLabel];
    
}

-(void)changeImage{

    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:15];
    if (isleft) {
        bkgImageView.left = -self.view.width;
    }else{
        bkgImageView.left = 0;
    }
    isleft = !isleft;
    //动画的内容
    //动画结束
    [UIView commitAnimations];
}

-(void)loginVC:(id)sender{
    QchLoginVC *loginVC=[[QchLoginVC alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)WXloginVC:(id)sender{
    
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (![self isBlankString:user.uid]) {
            SSDKCredential *credential=user.credential;
            
            UserDefaultEntity.nickName=user.nickname;
            UserDefaultEntity.uid=user.uid;
            UserDefaultEntity.splashPath=user.icon;
            UserDefaultEntity.thridCode=[NSString stringWithFormat:@"%@",credential.uid];
            UserDefaultEntity.login_type =@"2";
            
            [UserDefault saveUserDefault];
            [self isPerfect];
        }
    }];
}

-(void)WbloginVC:(id)sender{

    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (![self isBlankString:user.uid]) {
            SSDKCredential *credential=user.credential;
            
            UserDefaultEntity.nickName=user.nickname;
            UserDefaultEntity.uid=user.uid;
            UserDefaultEntity.splashPath=user.icon;
            UserDefaultEntity.thridCode=[NSString stringWithFormat:@"%@",credential.uid];
            UserDefaultEntity.login_type = @"2";
            
            [UserDefault saveUserDefault];
            [self isPerfect];
        }
    }];
}

-(void)isPerfect{
    
    [HttpLoginAction IfThreeLogin:UserDefaultEntity.thridCode androidRid:@"" IOSRid:_appDelegate.JPtoken Token:[MyAes aesSecretWith:@"userId"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        Liu_DBG(@"%@",dict);
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array=[dict objectForKey:@"result"];
            NSDictionary *item=array[0];
            
            NSInteger is_perfect=[(NSNumber *)[item objectForKey:@"t_User_Complete"]integerValue];
            if (is_perfect==1) {
                
                UserDefaultEntity.uuid=[item objectForKey:@"Guid"];
                UserDefaultEntity.account=[item objectForKey:@"t_User_LoginId"];
                UserDefaultEntity.telePhone=[item objectForKey:@"t_User_Mobile"];
                UserDefaultEntity.realName=[[item objectForKey:@"t_User_RealName"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.user_style=[item objectForKey:@"t_User_Style"];
                UserDefaultEntity.is_perfect=[(NSNumber *)[item objectForKey:@"t_User_Complete"]integerValue];
                //                UserDefaultEntity.audit_type = [item objectForKey:@"t_UserStyleAudit"];
                UserDefaultEntity.t_User_Complete = [item objectForKey:@"t_User_Complete"];
                UserDefaultEntity.positionName=[item objectForKey:@"PositionName"];
                UserDefaultEntity.positionId = [item objectForKey:@"t_User_Position"];
                UserDefaultEntity.remark = [[item objectForKey:@"t_User_Remark"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.birDate = [item objectForKey:@"t_User_Birth"];
                UserDefaultEntity.user_city=[item objectForKey:@"t_User_City"];
                UserDefaultEntity.commpany=[[item objectForKey:@"t_User_Commpany"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                UserDefaultEntity.headPath=[item objectForKey:@"t_User_Pic"];
                UserDefaultEntity.sex = [item objectForKey:@"t_User_Sex"];
                UserDefaultEntity.bgkPath=[item objectForKey:@"t_BackPic"];
                UserDefaultEntity.t_User_BusinessCard = [item objectForKey:@"t_User_BusinessCard"];
                UserDefaultEntity.t_User_InvestMoney = [item objectForKey:@"t_User_InvestMoney"];
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
                
                QCHMainController *main = [[QCHMainController alloc] init];
                [self.navigationController pushViewController:main animated:YES];
            }else{
                UserDefaultEntity.uuid=[item objectForKey:@"Guid"];
                UserDefaultEntity.is_perfect=is_perfect;
                [UserDefault saveUserDefault];
                
                PerfectMeansVC *perfectVc=[[PerfectMeansVC alloc]init];
                perfectVc.type=2;
                [self.navigationController pushViewController:perfectVc animated:YES];
            }
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            
            [self fristLogin];
            [Utils hideLoadingView];
        }else{
            
            [Utils hideLoadingView];
        }
        
    }];
}

//首次第三方登陆
-(void)fristLogin{

    QchMobileVC *mobileVC=[[QchMobileVC alloc]init];
    
    [self.navigationController pushViewController:mobileVC animated:YES];
}



-(void)readBook:(id)sender{

    QCHWebViewController *qchWebVC=[[QCHWebViewController alloc]init];
    qchWebVC.theme=@"用户协议";
    qchWebVC.type=1;
    qchWebVC.url=@"Agreement.html";
    [self.navigationController pushViewController:qchWebVC animated:YES];
}

-(void)ykmsLogin:(id)sender{

    NSString *token=[NSString stringWithFormat:@"%@",_appDelegate.JPtoken];
    [HttpLoginAction loginWithAccount:[MyAes aesSecretWith:@"15838226036"] userPwd:[MyAes aesSecretWith:@"123456"] androidRid:@"" IOSRid:token Token2:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {
        
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
            UserDefaultEntity.positionName=[item objectForKey:@"PositionName"];
            UserDefaultEntity.positionId = [item objectForKey:@"t_User_Position"];
            UserDefaultEntity.remark = [item objectForKey:@"t_User_Remark"];
            UserDefaultEntity.birDate = [item objectForKey:@"t_User_Birth"];
            UserDefaultEntity.user_city=[item objectForKey:@"t_User_City"];
            UserDefaultEntity.commpany=[item objectForKey:@"t_User_Commpany"];
            UserDefaultEntity.headPath=[item objectForKey:@"t_User_Pic"];
            UserDefaultEntity.sex = [item objectForKey:@"t_User_Sex"];
            UserDefaultEntity.bgkPath=[item objectForKey:@"t_BackPic"];
            UserDefaultEntity.NowNeed = [NSString stringWithFormat:@"%lu",[[item objectForKey:@"NowNeed"]count]];
            NSArray *Ryarray=(NSArray*)[item objectForKey:@"t_RongCloud_Token"];
            
            if ([Ryarray count]>0) {
                NSDictionary *rongDict=Ryarray[0];
                UserDefaultEntity.userId=[rongDict objectForKey:@"userId"];
                UserDefaultEntity.token=[rongDict objectForKey:@"token"];
                
                [self linketoRongyun:UserDefaultEntity.token];
            }else{
                [self getRYToken:[item objectForKey:@"Guid"]];
            }
            
            [UserDefault saveUserDefault];
            
            QCHMainController *main = [[QCHMainController alloc] init];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            [self.navigationController pushViewController:main animated:YES];

        }else{
            
        }
    }];
}

@end
