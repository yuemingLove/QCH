//
//  WithdrawalsViewController.m
//  qch
//
//  Created by W.兵 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "WithdrawalsViewController.h"

@interface WithdrawalsViewController ()<UITextFieldDelegate>
{
    UITextField *moneyTF;
    float account;
}
@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现";
    self.view.backgroundColor = [UIColor themeGrayColor];
    [self GetAccount];
    [self bindBankCard];
    
}

- (void)GetAccount{
    [HttpAlipayAction GetAccount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            account = [(NSNumber*)[dict objectForKey:@"result"] floatValue];
            NSString *money = [NSString stringWithFormat:@"当前余额:%.2f",account];
            moneyTF.placeholder = money;
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            account=0.00;
        }
    }];
}
// 绑定银行卡
- (void)bindBankCard {
    UIView *bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, 8*PMBHEIGHT, ScreenWidth, 200*PMBHEIGHT)];
    bgkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgkView];
    NSString *bankname = [NSString stringWithFormat:@"收款银行:%@",_t_Bank_Name];
    UILabel *bandLabel = [self createLabelFrame:CGRectMake(27*PMBWIDTH, 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor lightGrayColor] font:Font(15) text:bankname];
    [bgkView addSubview:bandLabel];
    
    NSMutableString *bankno = [NSMutableString stringWithFormat:@"%@",_t_Bank_NO];
    [bankno replaceCharactersInRange:NSMakeRange(6, bankno.length-10) withString:@"*****"];
    NSString *banknum = [NSString stringWithFormat:@"卡号:%@",bankno];
    UILabel *cardNum = [self createLabelFrame:CGRectMake(27*PMBWIDTH, bandLabel.bottom + 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor lightGrayColor] font:Font(15) text:banknum];
    [bgkView addSubview:cardNum];
    NSString *name =[NSString stringWithFormat:@"姓名:%@",_t_Bank_OpenUser];
    UILabel *accountLabel = [self createLabelFrame:CGRectMake(27*PMBWIDTH,cardNum.bottom + 8*PMBHEIGHT, ScreenWidth - 30*PMBWIDTH, 30) color:[UIColor lightGrayColor] font:Font(15) text:name];
    [bgkView addSubview:accountLabel];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, accountLabel.bottom+8*PMBHEIGHT, ScreenWidth, 8*PMBHEIGHT)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [bgkView addSubview:line1];
    
    UILabel *moneyLabel = [self createLabelFrame:CGRectMake(27*PMBWIDTH, line1.bottom + 27*PMBHEIGHT, 30, 30) color:[UIColor blackColor] font:Font(15) text:@"金额"];
    [bgkView addSubview:moneyLabel];
    
    
    moneyTF = [self createTextFieldFrame:CGRectMake(moneyLabel.right+ 8*PMBWIDTH, moneyLabel.top, ScreenWidth - moneyLabel.right - 30*PMBWIDTH, 35) font:Font(15) placeholder:@""];
    moneyTF.layer.cornerRadius = moneyTF.height/2;
    moneyTF.layer.masksToBounds = YES;
    moneyTF.layer.borderWidth = 0.6;
    moneyTF.layer.borderColor = TSEColor(230, 230, 230).CGColor;
    moneyTF.textColor = [UIColor blackColor];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10*PMBWIDTH, 0)];
    moneyTF.leftView = paddingView2;
    moneyTF.delegate = self;
    moneyTF.leftViewMode = UITextFieldViewModeAlways;
    [bgkView addSubview:moneyTF];

    UIButton *sureBut = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBut.frame = CGRectMake(ScreenWidth/4, bgkView.bottom+50*PMBHEIGHT, ScreenWidth/2, 35);
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    sureBut.backgroundColor = TSEColor(110, 151, 245);
    [sureBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBut.layer.cornerRadius = sureBut.height/2;
    sureBut.layer.masksToBounds = YES;
    [sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBut];
}
- (void)sureAction {
    
    [moneyTF resignFirstResponder];
    if ([self isBlankString:moneyTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写提款金额" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    if ([moneyTF.text floatValue]<100.00) {
        [SVProgressHUD showErrorWithStatus:@"提现额度不能小于100" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([moneyTF.text floatValue]>account) {
        [SVProgressHUD showErrorWithStatus:@"提现额度不能大于金额" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [HttpUserBankAction AddWithdrawal:UserDefaultEntity.uuid money:moneyTF.text remark:@"" bankGuid:_guid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict =result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        
        _isHaveDian = NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
                    //                    [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                
            }
            if (single=='.')
            {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian=YES;
                    return YES;
                }else{
 
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt = range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        return NO;
                    }
                }
                else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }else{
        return YES;
    }

}

@end
