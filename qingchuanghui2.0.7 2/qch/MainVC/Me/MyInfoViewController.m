//
//  MyInfoViewController.m
//  qch
//
//  Created by 苏宾 on 16/3/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyInfoViewController.h"
#import "CarePersonListVC.h"
#import "MyProjectVC.h"
#import "MyActivityVC.h"
#import "MyCollectVC.h"
#import "MyDynamicVC.h"
#import "PersonInfomationVC.h"
#import "SetAppVC.h"
#import "MyInvestVC.h"
#import "MyAppointVC.h"
#import "ParntDetailVC.h"
#import "QchpartnerVC.h"
#import "MakersVC.h"
#import "MoneyVC.h"
#import "CertificationVC.h"
#import "MyOrderListVC.h"
#import "CertificateViewController.h"
#import "InviteVC.h"
#import "MyIntegralVC.h"
#import "MyCouponVC.h"
@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,XHImageViewerDelegate>{
    //身份区别
    NSInteger style;
    NSInteger status;
    
    NSString *fcount;
    NSString *scount;
    NSString *integral;
    NSString *IsInvestor;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *bgkImageView;

@property (nonatomic,strong) UIImageView *mImgaeView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detalLabel;
@property (nonatomic,strong) UILabel *dyCount;
@property (nonatomic,strong) UILabel *careCount;
@property (nonatomic,strong) UILabel *fensiCount;

@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, strong) NSDictionary *titles;


@property (nonatomic,strong) NSDictionary *Countdict;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *fanslist;


@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_fanslist!=nil) {
        _fanslist = [[NSMutableArray alloc]init];
    }
        
    [self setNeedsStatusBarAppearanceUpdate];
    [self createTabelView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self GetIsInvestor];
    [self ifAuditStatus];
    [self updateFrame];
    [self updateMenu];
    [self getData];
    [self GetPraiseUser];
    [self GetUserFuns];
    [self GetInviteUser];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

-(void)ifAuditStatus{
    [HttpLoginAction OnOffTravel:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
           status=[(NSNumber*)[dict objectForKey:@"result"]integerValue];
            [self updateMenu];
        }
    }];
}


-(void)updateFrame{
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    [_mImgaeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    _nameLabel.text=UserDefaultEntity.realName;
    _detalLabel.text=UserDefaultEntity.remark;
}

-(void)createTabelView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    
    [self cleanTableView:_tableView];
    
    [self createHeadView];
}

-(void)updateMenu{

    style=[(NSNumber*)UserDefaultEntity.user_style integerValue];
    //0：审核中，1：已审核
    if (status==0) {
        if (style==2) {
            if ([IsInvestor isEqualToString:@"1"]) {
                self.modules = @[@[@"my_care"],@[@"my_tz",@"my_room",@"my_activity",@"my_proof"],@[@"my_line",@"my_phone",]];
                
                self.titles = @{
                                @"my_care":@"我的关注",
                                @"my_tz":@"投递项目",
                                @"my_room":@"我的预约",
                                @"my_activity":@"我的活动",
                                @"my_proof":@"我的凭证",
                                @"my_line":@"在线客服",
                                @"my_phone":@"电话服务"};
            } else if([IsInvestor isEqualToString:@"0"]){
                self.modules = @[@[@"my_care"],@[@"my_room",@"my_activity",@"my_proof"],@[@"my_line",@"my_phone",]];
                
                self.titles = @{
                                @"my_care":@"我的关注",
                                @"my_room":@"我的预约",
                                @"my_activity":@"我的活动",
                                @"my_proof":@"我的凭证",
                                @"my_line":@"在线客服",
                                @"my_phone":@"电话服务"};
            }
            
        }else if (style==3){
            
            self.modules = @[@[@"my_care"],@[@"my_project",@"my_room",@"my_activity",@"my_proof"],@[@"my_line",@"my_phone",]];
            
            self.titles = @{
                            @"my_care":@"我的关注",
                            @"my_project":@"我的项目",
                            @"my_room":@"我的预约",
                            @"my_activity":@"我的活动",
                            @"my_proof":@"我的凭证",
                            @"my_line":@"在线客服",
                            @"my_phone":@"电话服务"};
        } else {
            
            self.modules = @[@[@"my_VC"],@[@"my_care"],@[@"my_room",@"my_activity",@"my_proof"],@[@"my_line",@"my_phone",]];
            
            self.titles = @{@"my_VC":@"认证身份",
                            @"my_care":@"我的关注",
                            @"my_room":@"我的预约",
                            @"my_activity":@"我的活动",
                            @"my_proof":@"我的凭证",
                            @"my_line":@"在线客服",
                            @"my_phone":@"电话服务"};
        }
        
    } else {
        if (style==2) {
            
            if ([IsInvestor isEqualToString:@"1"]) {
                self.modules = @[@[@"my_buy",@"my_order",@"my_care"],@[@"my_tz",@"my_room",@"my_activity",@"my_proof",@"yqyj_img",],@[@"my_line",@"my_phone",]];
                
                self.titles = @{@"my_buy":@"我的钱包",
                                @"my_order":@"我的订单",
                                @"my_care":@"我的关注",
                                @"my_tz":@"投递项目",
                                @"my_room":@"我的预约",
                                @"my_activity":@"我的活动",
                                @"my_proof":@"我的凭证",
                                @"yqyj_img":@"邀请有奖",
                                @"my_line":@"在线客服",
                                @"my_phone":@"电话服务"};
                
            } else if([IsInvestor isEqualToString:@"0"]){
                self.modules = @[@[@"my_VC",@"my_buy",@"my_order",@"my_care"],@[@"my_room",@"my_activity",@"my_proof",@"yqyj_img",],@[@"my_line",@"my_phone",]];
                
                self.titles = @{@"my_VC":@"认证身份",
                                @"my_buy":@"我的钱包",
                                @"my_order":@"我的订单",
                                @"my_care":@"我的关注",
                                @"my_room":@"我的预约",
                                @"my_activity":@"我的活动",
                                @"my_proof":@"我的凭证",
                                @"yqyj_img":@"邀请有奖",
                                @"my_line":@"在线客服",
                                @"my_phone":@"电话服务"};
            }
            
        }else if (style==3){
            
            self.modules = @[@[@"my_buy",@"my_order",@"my_care"],@[@"my_project",@"my_room",@"my_activity",@"my_proof",@"yqyj_img"],@[@"my_line",@"my_phone",]];
            
            self.titles = @{
                            @"my_buy":@"我的钱包",
                            @"my_order":@"我的订单",
                            @"my_care":@"我的关注",
                            @"my_project":@"我的项目",
                            @"my_room":@"我的预约",
                            @"my_activity":@"我的活动",
                            @"my_proof":@"我的凭证",
                            @"yqyj_img":@"邀请有奖",
                            @"my_line":@"在线客服",
                            @"my_phone":@"电话服务"};
        } else {
            
            self.modules = @[@[@"my_VC"],@[@"my_buy",@"my_order",@"my_care"],@[@"my_room",@"my_activity",@"my_proof",@"yqyj_img"],@[@"my_line",@"my_phone",]];
            
            self.titles = @{@"my_VC":@"认证身份",
                            @"my_buy":@"我的钱包",
                            @"my_order":@"我的订单",
                            @"my_care":@"我的关注",
                            @"my_room":@"我的预约",
                            @"my_activity":@"我的活动",
                            @"my_proof":@"我的凭证",
                            @"yqyj_img":@"邀请有奖",
                            @"my_line":@"在线客服",
                            @"my_phone":@"电话服务"};
        }
    }
    [self.tableView reloadData];
}

-(void)cleanTableView:(UITableView*)tableView{
    
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    _tableView.tableFooterView=view;
}


-(void)createHeadView{

    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*SCREEN_WSCALE)];
    _tableView.tableHeaderView=_headerView;
    
    _bgkImageView=[[UIImageView alloc]initWithFrame:_headerView.frame];

    [_bgkImageView setImage:[UIImage imageNamed:@"my_bg"]];
    [_headerView addSubview:_bgkImageView];
    
    UIButton *setButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-33*SCREEN_WSCALE, 20*SCREEN_WSCALE, 18*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
    [setButton setImage:[UIImage imageNamed:@"my_set"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(mySet:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:setButton];
    
    UIView *imageV=[[UIView alloc]initWithFrame:CGRectMake(13*SCREEN_WSCALE, 70*SCREEN_WSCALE, 62*SCREEN_WSCALE, 62*SCREEN_WSCALE)];
    [imageV setBackgroundColor:[UIColor whiteColor]];
    imageV.layer.cornerRadius=imageV.height/2;
    [_headerView addSubview:imageV];
    
    UIImageView *jrImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, 96*SCREEN_WSCALE, 12*SCREEN_WSCALE, 12*SCREEN_WSCALE)];
    [jrImageView setImage:[UIImage imageNamed:@"my_jr"]];
    [_headerView addSubview:jrImageView];

    _mImgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(1*SCREEN_WSCALE, 1*SCREEN_WSCALE, 60*SCREEN_WSCALE, 60*SCREEN_WSCALE)];
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    _mImgaeView.layer.masksToBounds=YES;
    _mImgaeView.layer.cornerRadius=_mImgaeView.height/2;
    [_mImgaeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    [imageV addSubview:_mImgaeView];
    
    _nameLabel=[self createLabelFrame:CGRectMake(imageV.right+10*SCREEN_WSCALE, 75*SCREEN_WSCALE, SCREEN_WIDTH-imageV.width-65*SCREEN_WSCALE, 16*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(16) text:UserDefaultEntity.realName];
    [_headerView addSubview:_nameLabel];
    
    _detalLabel=[self createLabelFrame:CGRectMake(_nameLabel.left, imageV.bottom-30*SCREEN_WSCALE, _nameLabel.width, 14*SCREEN_WSCALE) color:[UIColor grayColor] font:Font(12) text:UserDefaultEntity.remark];
    [_headerView addSubview:_detalLabel];
    
    UIButton *updateInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    updateInfo.frame=CGRectMake(imageV.right, imageV.top, SCREEN_WIDTH-30*SCREEN_WSCALE, imageV.height);
    [updateInfo addTarget:self action:@selector(updateMyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:updateInfo];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, imageV.bottom+15*SCREEN_WSCALE, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3;
    [_headerView addSubview:line];
    
    CGFloat width=(SCREEN_WIDTH-2)/3;
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(width, line.bottom+15*SCREEN_WSCALE, 1, 20*SCREEN_WSCALE)];
    line2.backgroundColor=[UIColor grayColor];
    line2.alpha=0.3;
    [_headerView addSubview:line2];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(width*2+1, line.bottom+15*SCREEN_WSCALE, 1, 20*SCREEN_WSCALE)];
    line3.backgroundColor=[UIColor grayColor];
    line3.alpha=0.3;
    [_headerView addSubview:line3];
    
    UIView *fristView=[[UIView alloc]initWithFrame:CGRectMake(0, line.bottom, width, _headerView.height-line.bottom)];
    [_headerView addSubview:fristView];
    
    _dyCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(13) text:[_Countdict objectForKey:@"TCount"]];
    _dyCount.textAlignment=NSTextAlignmentCenter;
    [fristView addSubview:_dyCount];
    
    UILabel *dyLabel=[self createLabelFrame:CGRectMake(0, _dyCount.bottom+5*SCREEN_WSCALE, _dyCount.width, _dyCount.height) color:[UIColor lightGrayColor] font:Font(13) text:@"动态"];
    dyLabel.textAlignment=NSTextAlignmentCenter;
    [fristView addSubview:dyLabel];
    
    UIButton *fristBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fristBtn.frame=fristView.frame;
    fristBtn.tag=1;
    [fristBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:fristBtn];
    
    UIView *secordView=[[UIView alloc]initWithFrame:CGRectMake(width+1, fristView.top, width, fristView.height)];
    [_headerView addSubview:secordView];
    
    _careCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(13) text:[_Countdict objectForKey:@"PCount"]];
    _careCount.textAlignment=NSTextAlignmentCenter;
    [secordView addSubview:_careCount];
    
    UILabel *careLabel=[self createLabelFrame:CGRectMake(0, _careCount.bottom+5*SCREEN_WSCALE, _careCount.width, _careCount.height) color:[UIColor lightGrayColor] font:Font(13) text:@"关注"];
    careLabel.textAlignment=NSTextAlignmentCenter;
    [secordView addSubview:careLabel];
    
    UIButton *secordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    secordBtn.frame=secordView.frame;
    secordBtn.tag=2;
    [secordBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:secordBtn];
    
    UIView *thridView=[[UIView alloc]initWithFrame:CGRectMake((width+1)*2, fristView.top, width, fristView.height)];
    [_headerView addSubview:thridView];
    
    _fensiCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(14) text:[_Countdict objectForKey:@"FCount"]];
    _fensiCount.textAlignment=NSTextAlignmentCenter;
    [thridView addSubview:_fensiCount];
    
    UILabel *fensiLabel=[self createLabelFrame:CGRectMake(0, _fensiCount.bottom+5*SCREEN_WSCALE, _fensiCount.width, _fensiCount.height) color:[UIColor lightGrayColor] font:Font(14) text:@"粉丝"];
    fensiLabel.textAlignment=NSTextAlignmentCenter;
    [thridView addSubview:fensiLabel];
    
    UIButton *thridBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    thridBtn.frame=thridView.frame;
    thridBtn.tag=3;
    [thridBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:thridBtn];
}

-(void)mySet:(id)sender{
    SetAppVC *setApp=[[SetAppVC alloc]init];
    setApp.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setApp animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modules.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[_modules objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentify = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:module];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [self.titles objectForKey:module];
    cell.selectionStyle=UITableViewCellAccessoryNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([module isEqualToString:@"my_VC"]) {
        if ([UserDefaultEntity.user_style isEqualToString:@"2"]) {
            if ([IsInvestor isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"投资人申请正在审核中……" maskType:SVProgressHUDMaskTypeBlack];
            }
        }
        else{
        CertificationVC *certifica = [[CertificationVC alloc]init];
        certifica.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certifica animated:YES];
        }
    }else if ([module isEqualToString:@"my_buy"]) {
        MoneyVC *money = [[MoneyVC alloc]init];
        money.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:money animated:YES];
    }else if ([module isEqualToString:@"my_care"]){
        MyCollectVC *collect = [[MyCollectVC alloc]init];
        collect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collect animated:YES];
    }else if ([module isEqualToString:@"my_tz"]){
        MyInvestVC *myInvest=[[MyInvestVC alloc]init];
        myInvest.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myInvest animated:YES];
    }else if ([module isEqualToString:@"my_project"]){
        MyProjectVC *project = [[MyProjectVC alloc]init];
        project.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:project animated:YES];
    }else if ([module isEqualToString:@"my_room"]){
        MyAppointVC *myappoint=[[MyAppointVC alloc]init];
        myappoint.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myappoint animated:YES];
    }else if ([module isEqualToString:@"my_activity"]){
        MyActivityVC *activity = [[MyActivityVC alloc]init];
        activity.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activity animated:YES];
    }else if ([module isEqualToString:@"my_proof"]){
        CertificateViewController *cer = [[CertificateViewController alloc]init];
        cer.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cer animated:YES];
        
    }else if ([module isEqualToString:@"yqyj_img"]){
        InviteVC *invite = [[InviteVC alloc]init];
        invite.hidesBottomBarWhenPushed = YES;
        invite.fcount = fcount;
        invite.scount = scount;
        invite.integral = integral;
        [self.navigationController pushViewController:invite animated:YES];
        
    }
    else if ([module isEqualToString:@"my_order"]){
        MyOrderListVC *orderList=[[MyOrderListVC alloc]init];
        orderList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderList animated:YES];
    }else if ([module isEqualToString:@"my_line"]){
        
        MyChatViewController *myChat=[[MyChatViewController alloc]init];
        myChat.conversationType=ConversationType_PRIVATE;
        myChat.targetId=@"30bad6c8-88ab-4d82-967c-1764a91acc9e";
        myChat.title = @"在线客服";
        myChat.type=1;
        myChat.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myChat animated:YES];

    }else if ([module isEqualToString:@"my_phone"]){
        [self callPhone];
    }
}


-(void)updateMyInfo:(id)sender{
    
    //投资人：2；合伙人3；
    if(style==2){
            ParntDetailVC *parnt = [[ParntDetailVC alloc]init];
            parnt.hidesBottomBarWhenPushed = YES;
            parnt.Guid = UserDefaultEntity.uuid;
            [self.navigationController pushViewController:parnt animated:YES];
    }else if(style==3){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.hidesBottomBarWhenPushed = YES;
        partner.Guid = UserDefaultEntity.uuid;
        [self.navigationController pushViewController:partner animated:YES];
    }else{
        MakersVC *maker = [[MakersVC alloc]init];
        maker.hidesBottomBarWhenPushed = YES;
        maker.Guid = UserDefaultEntity.uuid;
        [self.navigationController pushViewController:maker animated:YES];
    }
}

-(void)callPhone{
    
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"4001690999"];
    UIWebView *callWebview =[[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)selectBtn:(UIButton*)sender{
    
    UIButton *button=(UIButton*)sender;

    NSInteger index=button.tag;;
    
    if (index==1) {
        MyDynamicVC *dynamic = [[MyDynamicVC alloc]init];
        dynamic.hidesBottomBarWhenPushed=YES;
        dynamic.title = @"我的动态";
        [self.navigationController pushViewController:dynamic animated:YES];
    }else if (index==2){
        CarePersonListVC *care = [[CarePersonListVC alloc]init];
        care.type = 3;
        care.title = @"我的关注";
        care.model = _funlist;
        care.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:care animated:YES];
    }else if (index==3){
        CarePersonListVC *care = [[CarePersonListVC alloc]init];
        care.type = 4;
        care.title = @"我的粉丝";
        care.model = [_fanslist mutableCopy];
        care.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:care animated:YES];
    }

}
//判断是不是投资人
- (void)GetIsInvestor{
    [HttpProjectAction GetIsInvestor:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            IsInvestor = [dict objectForKey:@"result"];
        }
    }];
}

//查询我发布的动态
- (void)getData{
    
    [HttpCenterAction GetUserCenterCount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array = (NSArray*)[dict objectForKey:@"result"];
            if ([array count]>0) {
                _Countdict=[array objectAtIndex:0];
                _dyCount.text=[_Countdict objectForKey:@"TCount"];
                _careCount.text=[_Countdict objectForKey:@"PCount"];
                _fensiCount.text=[_Countdict objectForKey:@"FCount"];
            }
            
            [_tableView reloadData];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
        }
    }];
}

//查询我关注人数
- (void)GetPraiseUser{
    
    [HttpCenterAction GetPraiseUser:UserDefaultEntity.uuid type:-1 Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _funlist = [[NSMutableArray alloc]init];

        }else{
            _funlist = [[NSMutableArray alloc]init];
        }
    }];
}

//查询粉丝数
- (void)GetUserFuns{
    
    [HttpCenterAction GetUserFuns:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _fanslist = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _fanslist = [[NSMutableArray alloc]init];

        }else{
            _fanslist = [[NSMutableArray alloc]init];
        }
    }];
}
//获取邀请好友
- (void)GetInviteUser{
    [HttpCenterAction GetInviteUser:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            fcount = [dict objectForKey:@"fcount"];
            scount = [dict objectForKey:@"scount"];
            integral = [dict objectForKey:@"integral"];
        }
    }];
}

-(void)updateBgkImage:(id)sender{

    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            [self submit:image];
        }
    }];
}

-(void)submit:(UIImage*)image{
    
    NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(200, 200)];
    
    NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    
    [dic setObject:imageStr forKey:@"base64Pic"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    
    [HttpLoginAction EditBackPic:dic complete:^(id result, NSError *error) {
        if (error==nil) {
            if (![self isBlankString:result]) {
                UserDefaultEntity.bgkPath=result;
                [UserDefault saveUserDefault];
                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,result]];
                [_bgkImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"my_bg"]];
            }
        }
    }];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}

- (NSString*)encodeURL:(NSString *)string{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}


@end
