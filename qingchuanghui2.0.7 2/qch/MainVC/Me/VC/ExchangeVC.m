//
//  ExchangeVC.m
//  qch
//
//  Created by 青创汇 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ExchangeVC.h"
#import "DeductionVoucherCell.h"
@interface ExchangeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *MoneyLab;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation ExchangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分兑换";
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    [self createTableView];
    [self creatheaderview];
    [self getMoey];
    [self getdata];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)creatheaderview{
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 128*PMBWIDTH)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *headerimg = [[UIImageView alloc]initWithFrame:headerView.frame];
    headerimg.image = [UIImage imageNamed:@"exchange"];
    headerimg.userInteractionEnabled=YES;
    [headerView addSubview:headerimg];
    
    
    UIButton *rulebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rulebtn.frame = CGRectMake(ScreenWidth-115*PMBWIDTH, 100*PMBWIDTH, 110*PMBWIDTH, 20*PMBWIDTH);
    [rulebtn setTitle:@"积分兑换规则" forState:UIControlStateNormal];
    [rulebtn setTitleColor:TSEColor(39, 94, 100) forState:UIControlStateNormal];
    rulebtn.titleLabel.font = Font(15);
    [rulebtn setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
    [rulebtn addTarget:self action:@selector(ruleAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerimg addSubview:rulebtn];
    
    
    UIImageView *jifenimg = [[UIImageView alloc]initWithFrame:CGRectMake(100*PMBWIDTH, 50*PMBWIDTH, 60*PMBWIDTH, 60*PMBWIDTH)];
    jifenimg.image = [UIImage imageNamed:@"keyongjifen"];
    [headerimg addSubview:jifenimg];
    
    UILabel *jifenlab = [[UILabel alloc]initWithFrame:CGRectMake(jifenimg.right+10*PMBWIDTH, jifenimg.top-5*PMBWIDTH, 60*PMBWIDTH, 15*PMBWIDTH)];
    jifenlab.textColor = TSEColor(39, 94, 100);
    jifenlab.text = @"可用积分";
    jifenlab.font = Font(15);
    [headerimg addSubview:jifenlab];
    
    MoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(jifenlab.left, jifenlab.bottom+5*PMBWIDTH, 150*PMBWIDTH, 30*PMBWIDTH)];
    MoneyLab.textAlignment = NSTextAlignmentLeft;
    MoneyLab.font = Font(30);
    MoneyLab.textColor = TSEColor(39, 94, 100);
    [headerimg addSubview:MoneyLab];
    _tableView.tableHeaderView = headerView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    DeductionVoucherCell *cell = (DeductionVoucherCell*)[tableView dequeueReusableCellWithIdentifier:@"DeductionVoucherCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DeductionVoucherCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[DeductionVoucherCell class]]) {
                cell = (DeductionVoucherCell *)oneObject;
                
            }
        }
    }
    [cell updata:dict];
    cell.exchangeButton.tag = indexPath.row;
    [cell.exchangeButton addTarget:self action:@selector(exchange:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}


-(void)ruleAction:(UIButton *)sender
{
    QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
    qchWeb.theme=@"积分兑换规则";
    qchWeb.type=2;
    qchWeb.url = [NSString stringWithFormat:@"%@couponRule.html",SHARE_HTML];
    [self.navigationController pushViewController:qchWeb animated:YES];
}

- (void)exchange:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSDictionary *dict = [_funlist objectAtIndex:index];
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeBlack];
    [HttpCenterAction AddUserVoucher:UserDefaultEntity.uuid voucherGuid:[dict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [self getMoey];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
    
}

- (void)getdata
{
    [HttpCenterAction GetVoucher:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
        [self.tableView reloadData];
    }];
}

- (void)getMoey
{
    [HttpCenterAction GetIntegral:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            MoneyLab.text = [dict objectForKey:@"result"];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            MoneyLab.text = @"0";
         
        }
        
    }];

}

@end
