//
//  MyIntegralVC.m
//  
//
//  Created by 青创汇 on 16/6/1.
//
//

#import "MyIntegralVC.h"
#import "IntegralCell.h"
#import "CreditsLogVC.h"
#import "ExchangeVC.h"
#import "SignViewController.h"
#import "MyMD5.h"
@interface MyIntegralVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headerView;
    UIButton *integralbtn;
    UIButton *rulebtn;
    UILabel *integrallab;
    UILabel *rulelab;
}

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *modules;


@end

@implementation MyIntegralVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self getdata];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refeleshView" object:nil];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeGrayColor];
    self.title = @"我的积分";
    self.modules = @[@"zhuanpan",@"jifen",@"jifenhuikui"];
    [self createTableView];
    [self creatheaderview];
    
    UIButton *signButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60*SCREEN_WSCALE, 39)];
    [signButton setImage:[UIImage imageNamed:@"my_new_sign"] forState:UIControlStateNormal];
    [signButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    [signButton setTitle:@"签到" forState:UIControlStateNormal];
    signButton.titleLabel.font = Font(15);
    [signButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(signButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:signButton];
    self.navigationItem.rightBarButtonItem = customButItem;
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

- (void)signButtonAction {
    // 签到
    SignViewController *signVC = [[SignViewController alloc] init];
    signVC.hidesBottomBarWhenPushed = YES;
    signVC.title = @"签到";
    [self.navigationController pushViewController:signVC animated:YES];
    
}

- (void)creatheaderview{
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 104*PMBWIDTH)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15*PMBWIDTH)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [headerView addSubview:line1];
    
    integralbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    integralbtn.frame = CGRectMake(0, 0, 55*PMBWIDTH, 55*PMBWIDTH);
    integralbtn.center = CGPointMake(ScreenWidth/4, 50*PMBWIDTH);
    integralbtn.layer.cornerRadius = integralbtn.height/2;
    [integralbtn setImage:[UIImage imageNamed:@"my_jifen"] forState:UIControlStateNormal];
    [integralbtn addTarget:self action:@selector(SelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:integralbtn];
    
    integrallab = [[UILabel alloc]initWithFrame:CGRectMake(0, integralbtn.bottom+5*PMBWIDTH, ScreenWidth/4, 15*PMBWIDTH)];
    integrallab.textAlignment = NSTextAlignmentRight;
    integrallab.font = Font(14);
    integrallab.textColor = [UIColor themeBlueColor];
    [headerView addSubview:integrallab];
    
    UILabel *jifenlab = [[UILabel alloc]initWithFrame:CGRectMake(integrallab.right+2*PMBWIDTH, integrallab.top, 30*PMBWIDTH, 15*PMBWIDTH)];
    jifenlab.text = @"积分";
    jifenlab.font = Font(14);
    jifenlab.textColor = [UIColor blackColor];
    [headerView addSubview:jifenlab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, integralbtn.top+2*PMBWIDTH, 1*PMBWIDTH, 66*PMBWIDTH)];
    line.backgroundColor = TSEColor(230, 230, 230);
    [headerView addSubview:line];
    
    rulebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rulebtn.frame = CGRectMake(0, 0, 55*PMBWIDTH, 55*PMBWIDTH);
    rulebtn.center = CGPointMake(line.right+ScreenWidth/4, 50*PMBWIDTH);
    rulebtn.layer.cornerRadius = rulebtn.height/2;
    [rulebtn setImage:[UIImage imageNamed:@"my_jifenguize"] forState:UIControlStateNormal];
    [rulebtn addTarget:self action:@selector(ruleAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:rulebtn];
    
    rulelab = [[UILabel alloc]initWithFrame:CGRectMake(line.right, integrallab.top, ScreenWidth/2, 15*PMBWIDTH)];
    rulelab.textColor = [UIColor blackColor];
    rulelab.text = @"积分规则";
    rulelab.textAlignment = NSTextAlignmentCenter;
    rulelab.font = Font(14);
    [headerView addSubview:rulelab];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_modules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralCell *cell = (IntegralCell*)[tableView dequeueReusableCellWithIdentifier:@"IntegralCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[IntegralCell class]]) {
                cell = (IntegralCell *)oneObject;
        
            }
        }
    }
    NSString *module = [self.modules objectAtIndex:indexPath.row];
    cell.BlackImg.image =[UIImage imageNamed:module];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *module = [self.modules objectAtIndex:indexPath.row];
    if ([module isEqualToString:@"zhuanpan"]) {
        QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
        qchWeb.theme=@"幸运大转盘";
        qchWeb.type=2;
        [qchWeb setClickBlock:^{
            QCHWebViewController *weakQchWeb=[[QCHWebViewController alloc]init];
            weakQchWeb.theme=@"中奖纪录";
            weakQchWeb.type=2;
            weakQchWeb.url = [NSString stringWithFormat:@"%@lotteryRecord.html?UserGuid=%@",SHARE_HTML,UserDefaultEntity.uuid];
            [self.navigationController pushViewController:weakQchWeb animated:YES];
        }];
        qchWeb.url = [NSString stringWithFormat:@"%@lottery.html?UserGuid=%@",SHARE_HTML,UserDefaultEntity.uuid];
        [self.navigationController pushViewController:qchWeb animated:YES];
    }else if ([module isEqualToString:@"jifen"]){
        ExchangeVC *exchange = [[ExchangeVC alloc]init];
        exchange.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exchange animated:YES];
        
    }else if ([module isEqualToString:@"jifenhuikui"]){
        QCHWebViewController *weakQchWeb=[[QCHWebViewController alloc]init];
        weakQchWeb.theme=@"中奖纪录";
        weakQchWeb.type=2;
        weakQchWeb.url = [NSString stringWithFormat:@"http://www.cn-qch.com/wx/mall.html?UserGuid=%@&Sign=%@",UserDefaultEntity.uuid, [MyMD5 md5:[NSString stringWithFormat:@"%@150919",UserDefaultEntity.uuid]]];
        [self.navigationController pushViewController:weakQchWeb animated:YES];
        //[SVProgressHUD showErrorWithStatus:@"敬请期待" maskType:SVProgressHUDMaskTypeBlack];
    }
    
}

- (void)SelectAction:(UIButton *)sender
{
    CreditsLogVC *creditslogvc = [[CreditsLogVC alloc]init];
    creditslogvc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:creditslogvc animated:YES];
}

-(void)ruleAction:(UIButton *)sender
{
    QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
    qchWeb.theme = @"积分规则";
    qchWeb.type=2;
    qchWeb.url = [NSString stringWithFormat:@"%@integralRule.html",SHARE_HTML];
    [self.navigationController pushViewController:qchWeb animated:YES];
}

- (void)getdata{

    [HttpCenterAction GetIntegral:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            integrallab.text = [dict objectForKey:@"result"];

        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            integrallab.text = @"0";
     
        }
        
    }];
}
@end
