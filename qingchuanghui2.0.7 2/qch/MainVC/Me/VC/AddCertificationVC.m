//
//  AddCertificationVC.m
//  qch
//
//  Created by 青创汇 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AddCertificationVC.h"
#import "WJAdsView.h"
@interface AddCertificationVC ()<UITextFieldDelegate,WJAdsViewDelegate,UIScrollViewDelegate>
{
    UIImageView *Iconimg;
    UILabel *Namelab;
    UILabel *userNOlab;
    UITextField *userNofield;
    UITextField *userNamefield;
    UITextField *codefield;
    UIButton *Submitbtn;
    UIButton *authCodeButton;
    NSString *code;
    NSDictionary *userdic;
    UIView *backview;
    UILabel *Money;
    UILabel *Moneylab;
    NSString *Newcode;
    UIScrollView *scrollView;

}

@end

@implementation AddCertificationVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor themeGrayColor];
    [self GetUserBank];
    [self GetVoiceCode];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)GetVoiceCode{
    [HttpUserBankAction GetVoiceCode:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            if (![self isBlankString:[dict objectForKey:@"result"]]) {
                Newcode = [dict objectForKey:@"result"];
            }
        }
    }];
}


- (void)creatCertification

{
    UIView *heaerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200*PMBWIDTH)];
    heaerView.backgroundColor = TSEColor(110, 151, 245);
    [self.view addSubview:heaerView];
    
    Iconimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*PMBWIDTH, 60*PMBWIDTH)];
    Iconimg.center = CGPointMake(ScreenWidth/2, 55*PMBWIDTH);
    Iconimg.layer.cornerRadius = Iconimg.height/2;
    Iconimg.layer.masksToBounds = YES;
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    [Iconimg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    [heaerView addSubview:Iconimg];
    
    Namelab = [[UILabel alloc]initWithFrame:CGRectMake(0, Iconimg.bottom+15*PMBWIDTH, ScreenWidth, 16*PMBWIDTH)];
    Namelab.font = Font(15);
    Namelab.textAlignment = NSTextAlignmentCenter;
    Namelab.textColor = [UIColor whiteColor];
    Namelab.text = [userdic objectForKey:@"t_Bank_OpenUser"];
    [heaerView addSubview:Namelab];
    
    userNOlab = [[UILabel alloc]initWithFrame:CGRectMake(0, Namelab.bottom+15*PMBWIDTH, ScreenWidth, 16*PMBWIDTH)];
    userNOlab.textColor = [UIColor whiteColor];
    userNOlab.font = Font(15);
    userNOlab.textAlignment = NSTextAlignmentCenter;
    
    NSMutableString *number = [NSMutableString stringWithFormat:@"%@",[userdic objectForKey:@"t_Bank_OpenUserNo"]];
    [number replaceCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    userNOlab.text = number;
    [heaerView addSubview:userNOlab];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70*PMBWIDTH, 20*PMBWIDTH)];
    img.center = CGPointMake(ScreenWidth/2, userNOlab.bottom+25*PMBWIDTH);
    img.image = [UIImage imageNamed:@"my_new.yirenzheng"];
    [heaerView addSubview:img];
    
}


- (void)AddCertificationView
{
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backview.backgroundColor = [UIColor themeGrayColor];
    [scrollView addSubview:backview];
    
    UIView *InformationView = [[UIView alloc]initWithFrame:CGRectMake(0, 15*PMBWIDTH, ScreenWidth, 160*PMBWIDTH)];
    InformationView.backgroundColor = [UIColor whiteColor];
    [backview addSubview:InformationView];
    
    UILabel *Nolab = [[UILabel alloc]initWithFrame:CGRectMake(20*PMBWIDTH, 15*PMBWIDTH, ScreenWidth-24*PMBWIDTH, 14*PMBWIDTH)];
    Nolab.text = @"身份证号码";
    Nolab.textColor = [UIColor blackColor];
    Nolab.font = Font(14);
    [InformationView addSubview:Nolab];
    
    
    
    userNofield = [[UITextField alloc]initWithFrame:CGRectMake(12*PMBWIDTH, Nolab.bottom+15*PMBWIDTH, ScreenWidth-24*PMBWIDTH, 30*PMBWIDTH)];
    userNofield.layer.cornerRadius = userNofield.height/2;
    userNofield.layer.masksToBounds = YES;
    userNofield.layer.borderWidth = 1.0f;
    userNofield.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    userNofield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的身份证号码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    userNofield.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNofield.font = Font(14);
    userNamefield.textColor = [UIColor blackColor];
    userNofield.keyboardType = UIKeyboardTypeASCIICapable;
    [InformationView addSubview:userNofield];
    
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    leftview.backgroundColor = [UIColor whiteColor];
    userNofield.leftView = leftview;
    userNofield.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(Nolab.left, userNofield.bottom+15*PMBWIDTH, Nolab.width, Nolab.height)];
    namelab.textColor = [UIColor blackColor];
    namelab.font = Font(14);
    namelab.text = @"姓名";
    [InformationView addSubview:namelab];
    
    userNamefield = [[UITextField alloc]initWithFrame:CGRectMake(userNofield.left, namelab.bottom+15*PMBWIDTH, userNofield.width, userNofield.height)];
    userNamefield.layer.cornerRadius = userNamefield.height/2;
    userNamefield.layer.masksToBounds = YES;
    userNamefield.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    userNamefield.layer.borderWidth = 1.0f;
    userNamefield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的姓名" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    userNamefield.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNamefield.font = Font(14);
    userNamefield.textColor = [UIColor blackColor];
    userNamefield.delegate = self;
    [InformationView addSubview:userNamefield];
    
    UIView *leftview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    leftview1.backgroundColor = [UIColor whiteColor];
    userNamefield.leftView = leftview1;
    userNamefield.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(0, InformationView.bottom+10*PMBWIDTH, ScreenWidth, 45*PMBWIDTH)];
    phonelab.backgroundColor = [UIColor whiteColor];
    phonelab.text = [NSString stringWithFormat:@"      手机号:%@",UserDefaultEntity.account];
    phonelab.textColor = [UIColor lightGrayColor];
    phonelab.font = Font(15);
    [backview addSubview:phonelab];
    
    UIView *codeView = [[UIView alloc]initWithFrame:CGRectMake(0, phonelab.bottom+10*PMBWIDTH, ScreenWidth, 90*PMBWIDTH)];
    codeView.backgroundColor = [UIColor whiteColor];
    [backview addSubview:codeView];
    
    UILabel *codelab = [[UILabel alloc]initWithFrame:CGRectMake(Nolab.left, 10*PMBWIDTH, 50*PMBWIDTH, 14*PMBWIDTH)];
    codelab.text = @"验证码";
    codelab.textColor = [UIColor blackColor];
    codelab.font = Font(14);
    [codeView addSubview:codelab];
    
    codefield = [[UITextField alloc]initWithFrame:CGRectMake(userNofield.left, codelab.bottom+15*PMBWIDTH, ScreenWidth/2-12*PMBWIDTH, userNofield.height)];
    codefield.layer.cornerRadius = codefield.height/2;
    codefield.layer.masksToBounds = YES;
    codefield.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    codefield.layer.borderWidth = 1.0f;
    codefield.font = Font(14);
    codefield.textColor = [UIColor blackColor];
    codefield.keyboardType = UIKeyboardTypeNumberPad;
    [codeView addSubview:codefield];
    
    UIView *leftview2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    leftview2.backgroundColor = [UIColor whiteColor];
    codefield.leftView = leftview2;
    codefield.leftViewMode = UITextFieldViewModeAlways;
    
    
    authCodeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    authCodeButton.frame=CGRectMake(codeView.width-130*SCREEN_WSCALE, codefield.top, 120*SCREEN_WSCALE, codefield.height);
    [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeButton setTitleColor:TSEColor(110, 151, 245) forState:UIControlStateNormal];
    [authCodeButton setBackgroundColor:[UIColor whiteColor]];
    authCodeButton.layer.masksToBounds=YES;
    authCodeButton.layer.cornerRadius=authCodeButton.height/2;
    authCodeButton.layer.borderWidth = 1.0f;
    authCodeButton.layer.borderColor = TSEColor(110, 151, 245).CGColor;
    authCodeButton.titleLabel.font=Font(14);
    [authCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:authCodeButton];
    

    
    UILabel *remarklab = [[UILabel alloc]initWithFrame:CGRectMake(20*PMBWIDTH, codeView.bottom+8*PMBWIDTH, ScreenWidth-30*PMBWIDTH, 30*PMBWIDTH)];
    remarklab.text = @"注：提现操作前请务必进行实名认证，实名认证成功后暂无法修改，请仔细核对填写。";
    remarklab.textColor = TSEColor(110, 151, 245);
    remarklab.numberOfLines = 0;
    remarklab.font = Font(13);
    [backview addSubview:remarklab];
    
    
    Submitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Submitbtn.frame = CGRectMake(0, 0, 150*PMBWIDTH, 30*PMBWIDTH);
    Submitbtn.center = CGPointMake(ScreenWidth/2, codeView.bottom+80*PMBWIDTH);
    Submitbtn.layer.cornerRadius = Submitbtn.height/2;
    Submitbtn.layer.masksToBounds = YES;
    Submitbtn.backgroundColor = TSEColor(110, 151, 245);
    [Submitbtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [Submitbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Submitbtn.titleLabel.font = Font(14);
    [Submitbtn addTarget:self action:@selector(SubmitbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:Submitbtn];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ScreenHeight)];
}


-(void)getCode:(id)sender{
    

    
    if ([self isBlankString:userNofield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写身份证号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNofield.text.length>18) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的身份证号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    if ([self isBlankString:userNamefield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNamefield.text.length>10) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNamefield.text.length<2) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self deptNameInputShouldChinese]) {
        [SVProgressHUD showErrorWithStatus:@"姓名只能输入中文" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    authCodeButton.userInteractionEnabled = NO;
    [authCodeButton setTitle:@"正在发送" forState:UIControlStateNormal];
    
    [HttpUserBankAction SendVoiceSMS:UserDefaultEntity.account Token:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {

        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            code=[dict objectForKey:@"code"];
            Liu_DBG(@"%@",code);
            authCodeButton.userInteractionEnabled = NO;
            [authCodeButton setTitle:@"60秒后重试" forState:UIControlStateNormal];
            [BlockTimer timerWithTime:60 interval:1 changed:^(float remain) {
                [authCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重试",(int)remain] forState:UIControlStateNormal];
            } complete:^{
                authCodeButton.userInteractionEnabled = YES;
                [authCodeButton setTitle:@"获取语言验证码" forState:UIControlStateNormal];
            }];
            [codefield becomeFirstResponder];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [authCodeButton setTitle:@"获取语言验证码" forState:UIControlStateNormal];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
            authCodeButton.userInteractionEnabled = YES;
            [authCodeButton setTitle:@"获取语言验证码" forState:UIControlStateNormal];
        }
        
    }];
}

- (void)GetUserBank{
    [HttpUserBankAction GetUserBank:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            userdic = [dict objectForKey:@"result"][0];
            [self creatCertification];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [self AddCertificationView];
        }
    }];
}

- (void)SubmitbtnAction{
    


    if ([self isBlankString:userNofield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写身份证号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNofield.text.length>18) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的身份证号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self isBlankString:userNamefield.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNamefield.text.length>10) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (userNamefield.text.length<2) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的姓名" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self deptNameInputShouldChinese]) {
        [SVProgressHUD showErrorWithStatus:@"姓名只能输入中文" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (![codefield.text isEqualToString:code]&![codefield.text isEqualToString:Newcode]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的验证码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [SVProgressHUD showWithStatus:@"认证中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpUserBankAction AddBank:UserDefaultEntity.uuid userName:userNamefield.text userNO:userNofield.text Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [backview removeFromSuperview];
                [self GetUserBank];
                [self GetVoucherByKey];
            });
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
-(void)GetVoucherByKey{
    [HttpCenterAction GetVoucherByKey:UserDefaultEntity.uuid key:@"shimingrenzheng" Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic =[dict objectForKey:@"result"][0];
            NSString*T_Voucher_Price = [[dic objectForKey:@"T_Voucher_Price"]stringByReplacingOccurrencesOfString:@".00" withString:@""];
            [self showViewWithMoney:T_Voucher_Price];
        }
    }];
}
- (void)showViewWithMoney:(NSString *)money{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.backgroundColor = [UIColor colorWithWhite:20
                                                           alpha:0.3];
    WJAdsView *adsView = [[WJAdsView alloc] initWithWindow:appDelegate.window];
    
    adsView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    adsView.delegate = self;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    UIView *BackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.height)];
    BackView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:CGRectMake(15*PMBWIDTH, 0, 222*PMBWIDTH, 208*PMBWIDTH)];
    backimg.image = [UIImage imageNamed:@"my_beijing2"];
    
    Money = [[UILabel alloc]initWithFrame:CGRectMake(80*PMBWIDTH, 100*PMBWIDTH, 90*PMBWIDTH, 20*PMBWIDTH)];
    Money.text = [NSString stringWithFormat:@"¥%@",money];
    Money.font = Font(20);
    Money.textAlignment = NSTextAlignmentCenter;
    Money.textColor = TSEColor(110, 151, 245);
    [backimg addSubview:Money];
    Moneylab = [[UILabel alloc]initWithFrame:CGRectMake(0, 170*PMBWIDTH, backimg.width, 15*PMBWIDTH)];
    Moneylab.text = [NSString stringWithFormat:@"恭喜！获得%@元代金券",money];
    Moneylab.font = Font(17);
    Moneylab.textAlignment = NSTextAlignmentCenter;
    Moneylab.textColor = [UIColor whiteColor];
    [backimg addSubview:Moneylab];
    [BackView addSubview:backimg];
    
    [array addObject:BackView];
    adsView.containerSubviews = array;
    [appDelegate.window addSubview:adsView];
    [adsView showAnimated:YES];
    
}



#pragma mark--
#pragma mark 输入中文
- (BOOL) deptNameInputShouldChinese
{
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:userNamefield.text]) {
        return YES;
    }
    return NO;
}

@end
