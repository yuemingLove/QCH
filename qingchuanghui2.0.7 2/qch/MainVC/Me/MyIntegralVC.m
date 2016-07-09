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
    NSString *jifen;
}

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *modules;
@property (nonatomic,strong) UIView *menuView;


@end

@implementation MyIntegralVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.0*SCREEN_WSCALE)];
    NSString *integral = [NSString stringWithFormat:@"%@ 积分",_Integral];
    NSArray *menuArray=@[@"签到",integral,@"兑换记录",@"积分规则"];
    CGFloat width=(self.menuView.frame.size.width-30*SCREEN_WSCALE)/4.0;
    for (int i=0; i<[menuArray count]; i++) {
        
        NSString *name=[menuArray objectAtIndex:i];
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];
        btnView.tag = 300+i;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"jifen_%d",i]] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(productListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:button];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+5, btnView.width, 16*SCREEN_WSCALE)];
        
        nameLabel.text=name;
        nameLabel.font=Font(15);
        nameLabel.tag = 200+i;
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [btnView addSubview:nameLabel];
        if (nameLabel.tag == 201) {
            nameLabel.textColor=TSEColor(110, 151, 245);
        }
        [self.menuView addSubview:btnView];
    }
    [headerView addSubview:_menuView];
    
    
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
        weakQchWeb.theme=@"积分兑换";
        weakQchWeb.type=2;
        weakQchWeb.url = [NSString stringWithFormat:@"http://www.cn-qch.com/wx/mall.html?UserGuid=%@&Sign=%@",UserDefaultEntity.uuid, [MyMD5 md5:[NSString stringWithFormat:@"%@150919",UserDefaultEntity.uuid]]];
        [self.navigationController pushViewController:weakQchWeb animated:YES];
    }
    
}

- (void)SelectAction
{
    CreditsLogVC *creditslogvc = [[CreditsLogVC alloc]init];
    creditslogvc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:creditslogvc animated:YES];
}

-(void)ruleAction
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
            _Integral = [dict objectForKey:@"result"];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _Integral = @"0";

        }
        for (int i = 0; i < self.menuView.subviews.count; i++) {
            if ([(UIView *)[self.menuView.subviews objectAtIndex:i] tag] == 301) {
                for (int j = 0; j < [(UIView *)[self.menuView.subviews objectAtIndex:i] subviews].count; j++) {
                    if ([[(UIView *)[self.menuView.subviews objectAtIndex:i] subviews][j] isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)[(UIView *)[self.menuView.subviews objectAtIndex:i] subviews][j];
                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 积分",_Integral]];
                        
                        [AttributedStr addAttribute:NSForegroundColorAttributeName
                                              value:[UIColor blackColor]
                                              range:NSMakeRange(_Integral.length, 3)];
                        
                        label.attributedText = AttributedStr;

                    }
                }
            }
        }
    }];
}

- (void)productListButtonClicked:(UIButton*)sender
{
    UIButton *button=(UIButton*)sender;
    button.highlighted=NO;
    NSInteger listed=button.tag;
    
    if (listed==100) {
        [self signButtonAction];
    }else if (listed==101){
        [self SelectAction];
    }else if (listed==102){
        QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
        qchWeb.theme = @"兑换记录";
        qchWeb.type=2;
        qchWeb.url = [NSString stringWithFormat:@"http://www.cn-qch.com/wx/converRecord.html?Guid=%@",UserDefaultEntity.uuid];
        [self.navigationController pushViewController:qchWeb animated:YES];
    }else if (listed==103){
        [self ruleAction];
    }
}
@end
