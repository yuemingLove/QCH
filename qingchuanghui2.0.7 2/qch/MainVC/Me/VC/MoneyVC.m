//
//  MoneyVC.m
//  qch
//
//  Created by 青创汇 on 16/3/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MoneyVC.h"
#import "AccountPayVC.h"
#import "MyAccountListVC.h"
#import "BindBankCardVC.h"
#import "WithdrawalsViewController.h"
#import "AddCertificationVC.h"
#import "BindBankCardVC.h"
#import "WithdrawalsDetailVC.h"
@interface MoneyVC ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *Balancelab;
    BOOL flag;
    BOOL flag1;
    UILabel *detail;
    NSString *linked;
}

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation MoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    [self creattableview];
    [self creatHeaderImg];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(WithdrawalsAction)];
    [self getbank];
}

- (void)getbank
{
    [HttpUserBankAction GetUserBank:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSArray *array=(NSArray*)[dict objectForKey:@"result"];
             NSDictionary *dict=array[0];
            if (![self isBlankString:[dict objectForKey:@"t_Bank_NO"]]) {
                flag = YES;
            }
        }
        [self.tableview reloadData];
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getTotlePrice];
    
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

- (void)creattableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableview];
}

-(void)creatHeaderImg{
    
    UIView *HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*PMBWIDTH)];
    HeadView.backgroundColor = TSEColor(110, 151, 245);
    
    
    UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*PMBWIDTH, ScreenWidth, 16*PMBWIDTH)];
    moneylab.text = @"当前帐户余额";
    moneylab.textColor = [UIColor whiteColor];
    moneylab.font = Font(16);
    moneylab.textAlignment = NSTextAlignmentCenter;
    [HeadView addSubview:moneylab];
    
    Balancelab = [[UILabel alloc]initWithFrame:CGRectMake(0, moneylab.bottom+20*PMBWIDTH, ScreenWidth, 25*PMBWIDTH)];
    Balancelab.textAlignment = NSTextAlignmentCenter;
    Balancelab.font = Font(20);
    Balancelab.textColor = [UIColor whiteColor];
    [HeadView addSubview:Balancelab];
    self.tableview.tableHeaderView = HeadView;
}

-(void)getTotlePrice{
    
    [HttpAlipayAction GetAccount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            Balancelab.text=[NSString stringWithFormat:@"￥%@",[dict objectForKey:@"result"]];
        }else{
            Balancelab.text=[NSString stringWithFormat:@"￥%@",@"0.00"];
        }
        [self.tableview reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0*PMBWIDTH, 44*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [cell addSubview:line];
    cell.textLabel.font = Font(14);
    cell.textLabel.textColor = [UIColor blackColor];
//    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//    cell.detailTextLabel.font = Font(12);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.textLabel.text = @"交易明细";
        cell.imageView.image = [UIImage imageNamed:@"new_trade"];
    }else if (indexPath.row==1){
        cell.textLabel.text = @"提现明细";
        cell.imageView.image = [UIImage imageNamed:@"new_getMoney"];
    }else if (indexPath.row==2){
        cell.textLabel.text = @"账户充值";
        cell.imageView.image = [UIImage imageNamed:@"new_rechange"];
    }else if (indexPath.row==3){
        cell.textLabel.text = @"绑定银行卡";
        if (flag || ![self isBlankString:linked]) {
            if (detail == nil) {
                detail = [self createLabelFrame:CGRectMake(cell.right- 65*PMBWIDTH, 15*PMBHEIGHT, 40*PMBWIDTH, 21) color:[UIColor lightGrayColor] font:Font(12) text:@"已绑定"];
                [cell addSubview:detail];
            }
        }
        cell.imageView.image = [UIImage imageNamed:@"new_bind"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50*PMBWIDTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        // 交易明细
        MyAccountListVC *myAccount=[[MyAccountListVC alloc]init];
        [self.navigationController pushViewController:myAccount animated:YES];
    }else if (indexPath.row==1) {
        // 提现明细
        WithdrawalsDetailVC *withdrawalsVC = [[WithdrawalsDetailVC alloc] init];
        [self.navigationController pushViewController:withdrawalsVC animated:YES];
    }else if (indexPath.row==2){
        // 账户充值
        AccountPayVC *accountPay=[[AccountPayVC alloc]init];
        [self.navigationController pushViewController:accountPay animated:YES];
    }else if (indexPath.row==3){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.userInteractionEnabled=NO;
        // 绑定银行卡
        [HttpUserBankAction GetUserBank:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict = result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                cell.userInteractionEnabled= YES;
                BindBankCardVC *bindVC = [[BindBankCardVC alloc] init];
                [bindVC setValueBlock:^(NSString *value) {
                    linked = value;
                }];
                [self.navigationController pushViewController:bindVC animated:YES];
                
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                [SVProgressHUD showErrorWithStatus:@"您还没有实名认证,请先进行实名认证" maskType:SVProgressHUDMaskTypeBlack];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cell.userInteractionEnabled= YES;
                    AddCertificationVC *AddCertification = [[AddCertificationVC alloc]init];
                    [self.navigationController pushViewController:AddCertification animated:YES];
                });

            }else{
                cell.userInteractionEnabled= YES;
            }
        }];
    }
}
#pragma mark - 提现
- (void)WithdrawalsAction {
    if (flag1 == NO) {
        flag1 = YES;
        [HttpUserBankAction GetUserBank:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dic = result[0];
            if ([[dic objectForKey:@"state"]isEqualToString:@"true"]) {
                NSDictionary *dict = [dic objectForKey:@"result"][0];
                if ([self isBlankString:[dict objectForKey:@"t_Bank_Name"]]) {
                    [SVProgressHUD showErrorWithStatus:@"您还没有绑定银行卡,请先绑定银行卡" maskType:SVProgressHUDMaskTypeBlack];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        flag1 = NO;
                        BindBankCardVC *bind = [[BindBankCardVC alloc]init];
                        [self.navigationController pushViewController:bind animated:YES];
                    });
                }else{
                    WithdrawalsViewController *Withdrawals =[[WithdrawalsViewController alloc]init];
                    Withdrawals.t_Bank_NO = [dict objectForKey:@"t_Bank_NO"];
                    Withdrawals.t_Bank_Name = [dict objectForKey:@"t_Bank_Name"];
                    Withdrawals.guid = [dict objectForKey:@"Guid"];
                    Withdrawals.t_Bank_OpenUser = [dict objectForKey:@"t_Bank_OpenUser"];
                    Withdrawals.hidesBottomBarWhenPushed = YES;
                    flag1 = NO;
                    [self.navigationController pushViewController:Withdrawals animated:YES];
                }
            }else if ([[dic objectForKey:@"state"]isEqualToString:@"false"]){
                [SVProgressHUD showErrorWithStatus:@"您还没有实名认证,请先进行实名认证" maskType:SVProgressHUDMaskTypeBlack];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AddCertificationVC *AddCertification = [[AddCertificationVC alloc]init];
                    flag1 = NO;
                    [self.navigationController pushViewController:AddCertification animated:YES];
                });
            }else{
                flag1 = NO;
            }
        }];
        
    }
}
@end
