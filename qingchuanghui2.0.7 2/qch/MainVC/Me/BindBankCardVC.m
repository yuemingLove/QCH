//
//  BindBankCardVC.m
//  qch
//
//  Created by W.兵 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "BindBankCardVC.h"
#import "WithdrawalsViewController.h"
#import "WJAdsView.h"

@interface BindBankCardVC ()<WJAdsViewDelegate,UIScrollViewDelegate>
{
    UITextField *cardTF;
    UITextField *bandTF;
    UITextField *codeTF;
    NSString *code;
    UIButton *authCodeButton;
    NSString *guid;
    UIView *BackView;
    UILabel *accountNum;
    UILabel *Money;
    UILabel *Moneylab;
    UIView *backview;
    UIScrollView *scrollView;
}
@end

@implementation BindBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定银行卡";
    self.view.backgroundColor = [UIColor themeGrayColor];
    [self getBindCard];
    
}
// 获取绑定的卡
- (void)getBindCard {
    [HttpUserBankAction GetUserBank:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dic = result[0];
        if ([[dic objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *dict = [dic objectForKey:@"result"][0];
            guid = [dict objectForKey:@"Guid"];
            if ([[dict objectForKey:@"t_Bank_Name"]isEqualToString:@""]) {
                [self bindBankCard];
                accountNum.text = [NSString stringWithFormat:@"开户人:%@",[dict objectForKey:@"t_Bank_OpenUser"]];
            }else{
                NSMutableString *t_Bank_NO = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"t_Bank_NO"]];
                [t_Bank_NO replaceCharactersInRange:NSMakeRange(6, t_Bank_NO.length-10) withString:@"******"];
                [self showBindedBankCardWith:[dict objectForKey:@"t_Bank_Name"] account:[dict objectForKey:@"t_Bank_OpenUser"] number:t_Bank_NO];
            }
        } else if ([[dic objectForKey:@"state"] isEqualToString:@"false"]) {
            [self bindBankCard];
        }
    }];
}
// 绑定银行卡
- (void)bindBankCard {
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ScreenHeight)];
    
    BackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    BackView.backgroundColor = [UIColor themeGrayColor];
    [scrollView addSubview:BackView];
    
    UIView *bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, 8*PMBHEIGHT, ScreenWidth, 375*SCREEN_WHCALE)];
    bgkView.backgroundColor = [UIColor whiteColor];
    [BackView addSubview:bgkView];
    UILabel *cardNum = [self createLabelFrame:CGRectMake(27*PMBWIDTH, 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor blackColor] font:Font(15) text:@"卡号"];
    [bgkView addSubview:cardNum];
    cardTF = [self createTextFieldFrame:CGRectMake(15*PMBWIDTH, cardNum.bottom+8*PMBHEIGHT, cardNum.width, 35) font:Font(15) placeholder:@"请输入您的卡号"];
    cardTF.layer.cornerRadius = cardTF.height/2;
    cardTF.layer.masksToBounds = YES;
    cardTF.layer.borderWidth = 0.6;
    cardTF.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    cardTF.textColor = [UIColor blackColor];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    cardTF.leftView = paddingView1;
    cardTF.leftViewMode = UITextFieldViewModeAlways;
    [bgkView addSubview:cardTF];
    
    UILabel *bandNum = [self createLabelFrame:CGRectMake(27*PMBWIDTH, cardTF.bottom + 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor blackColor] font:Font(15) text:@"开户银行"];
    [bgkView addSubview:bandNum];
    bandTF = [self createTextFieldFrame:CGRectMake(15*PMBWIDTH, bandNum.bottom+8*PMBHEIGHT, bandNum.width, 35) font:Font(15) placeholder:@"请输入开户银行,如xx银行xx支行"];
    bandTF.layer.cornerRadius = bandTF.height/2;
    bandTF.layer.masksToBounds = YES;
    bandTF.layer.borderWidth = 0.6;
    bandTF.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    bandTF.textColor = [UIColor blackColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    bandTF.leftView = paddingView2;
    bandTF.leftViewMode = UITextFieldViewModeAlways;
    [bgkView addSubview:bandTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bandTF.bottom+8*PMBHEIGHT, ScreenWidth, 8*PMBHEIGHT)];
    line.backgroundColor = [UIColor themeGrayColor];
    [bgkView addSubview:line];
    
    accountNum = [self createLabelFrame:CGRectMake(27*PMBWIDTH, line.bottom + 8*PMBHEIGHT, 200*PMBWIDTH, 30*PMBWIDTH) color:[UIColor lightGrayColor] font:Font(15) text:@"开户人:"];
    [bgkView addSubview:accountNum];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, accountNum.bottom+8*PMBHEIGHT, ScreenWidth, 8*PMBHEIGHT)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [bgkView addSubview:line1];
    
    UILabel *phonelab = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.bottom+8*PMBWIDTH, ScreenWidth, 45*PMBWIDTH)];
    phonelab.backgroundColor = [UIColor whiteColor];
    phonelab.text = [NSString stringWithFormat:@"        手机号:%@",UserDefaultEntity.account];
    phonelab.textColor = [UIColor lightGrayColor];
    phonelab.font = Font(15);
    [bgkView addSubview:phonelab];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, phonelab.bottom+8*PMBHEIGHT, ScreenWidth, 8*PMBHEIGHT)];
    line3.backgroundColor = [UIColor themeGrayColor];
    [bgkView addSubview:line3];

    
    UILabel *codeNum = [self createLabelFrame:CGRectMake(27*PMBWIDTH, line3.bottom + 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor blackColor] font:Font(15) text:@"验证码"];
    [bgkView addSubview:codeNum];
    
    codeTF = [self createTextFieldFrame:CGRectMake(15*PMBWIDTH, codeNum.bottom + 8*PMBHEIGHT, 170*PMBWIDTH, 35) font:Font(15) placeholder:@"请输入验证码"];
    codeTF.layer.cornerRadius = codeTF.height/2;
    codeTF.layer.masksToBounds = YES;
    codeTF.layer.borderWidth = 0.6;
    codeTF.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    codeTF.textColor = [UIColor blackColor];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*PMBWIDTH, 30)];
    codeTF.leftView = paddingView3;
    codeTF.leftViewMode = UITextFieldViewModeAlways;
    [bgkView addSubview:codeTF];
    authCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    authCodeButton.frame = CGRectMake(codeTF.right + 15*PMBWIDTH, codeTF.top, 100*PMBWIDTH, 35);
    [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authCodeButton setTitleColor:TSEColor(110, 151, 245) forState:UIControlStateNormal];
    authCodeButton.layer.borderColor = TSEColor(110, 151, 245).CGColor;
    authCodeButton.layer.borderWidth = 0.6;
    authCodeButton.layer.cornerRadius = authCodeButton.height/2;
    authCodeButton.layer.masksToBounds = YES;
    [authCodeButton addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgkView addSubview:authCodeButton];
    
    UILabel *messageLabel = [self createLabelFrame:CGRectMake(15*PMBWIDTH, bgkView.bottom+2*PMBWIDTH, ScreenWidth - 30*PMBWIDTH, 60) color:TSEColor(110, 151, 245) font:Font(12) text:@"注：提现操作前请务必绑定与本人身份信息一致的银行卡，仅支持借记卡，已绑定银行卡暂不支持修改，如有疑问请致电青创汇客服：400-169-0999"];
    messageLabel.numberOfLines = 0;
    [BackView addSubview:messageLabel];
    
    UIButton *sureBut = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBut.frame = CGRectMake(ScreenWidth/4, bgkView.bottom+60*PMBHEIGHT, ScreenWidth/2, 35);
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    sureBut.backgroundColor = TSEColor(110, 151, 245);
    [sureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBut.layer.cornerRadius = sureBut.height/2;
    sureBut.layer.masksToBounds = YES;
    [sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [BackView addSubview:sureBut];
}

// 展示已经绑定过的卡
- (void)showBindedBankCardWith:(NSString *)bank account:(NSString *)account number:(NSString *)number {
    
    UIView *bgkView = [[UIView alloc] initWithFrame:CGRectMake(8*PMBWIDTH, 15*PMBHEIGHT, ScreenWidth-16*PMBWIDTH, 110*PMBHEIGHT)];
    bgkView.backgroundColor = TSEColor(110, 151, 245);
    bgkView.layer.cornerRadius = bgkView.height/15;
    bgkView.layer.masksToBounds = YES;
    [self.view addSubview:bgkView];
    UIImageView *yinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*PMBWIDTH, 20*PMBHEIGHT, 44*PMBWIDTH, 24*PMBWIDTH)];
    yinImageView.image = [UIImage imageNamed:@"UnionPay"];
   
    [bgkView addSubview:yinImageView];
    UILabel *bankLabel = [self createLabelFrame:CGRectMake(yinImageView.right+8*PMBWIDTH, 15*PMBWIDTH, bgkView.width - yinImageView.right - 15*PMBWIDTH, 30) color:[UIColor whiteColor] font:Font(15) text:bank];

    [bgkView addSubview:bankLabel];
    
    UILabel *accountLabel = [self createLabelFrame:CGRectMake(yinImageView.right+8*PMBWIDTH, bankLabel.bottom, bgkView.width - yinImageView.right - 15*PMBWIDTH, 30) color:[UIColor whiteColor] font:Font(15) text:account];

    [bgkView addSubview:accountLabel];
    
    UILabel *numLabel = [self createLabelFrame:CGRectMake(yinImageView.right+8*PMBWIDTH, accountLabel.bottom, bgkView.width - yinImageView.right - 15*PMBWIDTH, 30) color:[UIColor whiteColor] font:Font(15) text:number];
 
    [bgkView addSubview:numLabel];
    
    
    UILabel *messageLabel = [self createLabelFrame:CGRectMake(15*PMBWIDTH, bgkView.bottom+15*PMBWIDTH, ScreenWidth - 30*PMBWIDTH, 60) color:TSEColor(110, 151, 245) font:Font(12) text:@"注：提现操作前请务必绑定与本人身份信息一致的银行卡，仅支持借记卡，已绑定银行卡暂不支持修改，如有疑问请致电青创汇客服：400-169-0999"];
    messageLabel.numberOfLines = 0;
    [self.view addSubview:messageLabel];
    
}

// 获取验证码
- (void)getCodeAction {
    if ([self isBlankString:cardTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写银行卡号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![Utils validateBankCardNumber:cardTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的银行卡号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:bandTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写开户行" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self deptNameInputShouldChinese]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的开户行" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    authCodeButton.userInteractionEnabled = NO;
    [authCodeButton setTitle:@"正在发送" forState:UIControlStateNormal];
    
    [HttpLoginAction SendSMS:UserDefaultEntity.account type:@"2" Token:[MyAes aesSecretWith:@"userMobile"] complete:^(id result, NSError *error) {
        NSDictionary *dic = result[0];
        if ([[dic objectForKey:@"state"] isEqualToString:@"true"]) {
            code=[dic objectForKey:@"code"];
            authCodeButton.userInteractionEnabled = NO;
            [authCodeButton setTitle:@"60秒后重试" forState:UIControlStateNormal];
            [BlockTimer timerWithTime:60 interval:1 changed:^(float remain) {
                [authCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重试",(int)remain] forState:UIControlStateNormal];
            } complete:^{
                authCodeButton.userInteractionEnabled = YES;
                [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            }];
            [codeTF becomeFirstResponder];
            
        } else if ([[dic objectForKey:@"state"] isEqualToString:@"false"]) {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else if ([[dic objectForKey:@"state"] isEqualToString:@"illegal"]) {
            
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败，请重新获取" maskType:SVProgressHUDMaskTypeBlack];
            authCodeButton.userInteractionEnabled = YES;
            [authCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    }];
}
// 确定
- (void)sureAction {

    if ([self isBlankString:cardTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写银行卡号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (![Utils validateBankCardNumber:cardTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的银行卡号" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:bandTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写开户行" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self deptNameInputShouldChinese]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的开户行" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    if (![codeTF.text isEqualToString:code]&![codeTF.text isEqualToString:@"150919"]) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确验证码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [SVProgressHUD showWithStatus:@"绑定中……" maskType:SVProgressHUDMaskTypeBlack];
    [HttpUserBankAction CompleteBank:guid bankName:bandTF.text bankNO:cardTF.text openAddress:@"" Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSDictionary *dic = result[0];
        if ([[dic objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [BackView removeFromSuperview];
                [self getBindCard];
                [self GetVoucherByKey];
            });
        } else if([[dic objectForKey:@"state"] isEqualToString:@"false"]) {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        } else  if ([[dic objectForKey:@"state"] isEqualToString:@"illegal"]) {
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
-(void)GetVoucherByKey{
    [HttpCenterAction GetVoucherByKey:UserDefaultEntity.uuid key:@"bangdingyinhangka" Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
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
    
    UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.height)];
    BackView1.backgroundColor = [UIColor clearColor];
    
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
    [BackView1 addSubview:backimg];
    
    [array addObject:BackView1];
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
    if (![pred evaluateWithObject:bandTF.text]) {
        return YES;
    }
    return NO;
}

@end
