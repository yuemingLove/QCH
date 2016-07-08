//
//  DiscoverViewController.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "NewDiscoverViewController.h"
#import "PoineerConsultVC.h"
#import "ActivityListViewController.h"
#import "ProjectViewController.h"
#import "PartnViewController.h"
#import "RoomViewController.h"
#import "PrivateVC.h"
#import "InvestmentVC.h"
#import "CollegeVC.h"
#import "PartPresonViewController.h"
#import "PartnerList.h"
#import "DiscoverModel.h"
#import "DiscoverCell.h"
@interface NewDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View
@property (strong, nonatomic) NSArray *adsArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;
@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, strong) NSDictionary *titles;
@property (nonatomic, strong) NSArray *detail;
@property (nonatomic,strong) NSMutableArray *fristMenulist;
@property (nonatomic,strong) NSMutableArray *secordMenulist;

@end

@implementation NewDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"发现"];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self loadData];
    [self createTableView];
    [self creatmenu];
    if (_fristMenulist !=nil) {
        _fristMenulist=[[NSMutableArray alloc]init];
    }
    
    if (_secordMenulist !=nil) {
        _secordMenulist=[[NSMutableArray alloc]init];
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
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
    self.navigationController.navigationBarHidden=NO;
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = TSEAColor(245, 245, 245, 0.5);
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
    
    //广告：定时器广告图片切换
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300*SCREEN_WSCALE)];
    _headerView.backgroundColor=[UIColor whiteColor];
    {
        __weak NewDiscoverViewController *weakSelf=self;
        self.adsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0*SCREEN_WSCALE ) animationDuration:3];
        
        [_adsView setFetchContentViewAtIndex:^UIView *(NSInteger pageIndex){
            if (pageIndex < [weakSelf.adsArray count]) {

                NSDictionary *model = [weakSelf.adsArray objectAtIndex:pageIndex];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  200.0 * SCREEN_WSCALE)];
                NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[model objectForKey:@"t_Ad_Pic"]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
                
                return imageView;
                
            }
            return [[UIView alloc] initWithFrame:CGRectZero];
        }];
        
        [_adsView setTapActionBlock:^(NSInteger pageIndex){
            if (pageIndex <[weakSelf.adsArray count]) {
                
                NSDictionary *dict=weakSelf.adsArray[pageIndex];
                
                QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
                qchWeb.theme=[NSString stringWithFormat:@"%@详情",[dict objectForKey:@"t_Ad_Title"]];
                qchWeb.type=2;
                qchWeb.url=[NSString stringWithFormat:@"%@AdView.html?Guid=%@",SERIVE_HTML,[dict objectForKey:@"Guid"]];
                qchWeb.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:qchWeb animated:NO];
            }
        }];
        [_headerView addSubview:_adsView];
        
    }

    _tableView.tableHeaderView = _headerView;
}

//服务菜单
- (void)creatmenu{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, _adsView.frame.size.height, SCREEN_WIDTH, 100.0*SCREEN_WSCALE)];
    
    //NSArray *menuArray=@[@"空间",@"资讯",@"活动",@"双创学院"];
    
    CGFloat width=(self.menuView.frame.size.width-30*SCREEN_WSCALE)/4.0;
    for (int i=0; i<[_fristMenulist count]; i++) {
        
        DiscoverModel *model=[_fristMenulist objectAtIndex:i];
        NSString *name=model.Title;
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
        
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_Discovery,model.Pic];
        [button sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"dis_00%d",i]]];
        
        button.tag = i;
        [button addTarget:self action:@selector(productListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:button];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+5, btnView.width, 16*SCREEN_WSCALE)];
        
        nameLabel.text=name;
        nameLabel.font=Font(15);
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [btnView addSubview:nameLabel];
        
        [self.menuView addSubview:btnView];
    }
    [_headerView addSubview:_menuView];
}




-(void)cleanTableView:(UITableView*)tableView{
    
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    _tableView.tableFooterView=view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_secordMenulist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverModel *model=[_secordMenulist objectAtIndex:indexPath.section];
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_Discovery,model.Pic];
    NSString *title=model.Title;
    NSString *remark = model.Remark;
    DiscoverCell *cell = (DiscoverCell*)[tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DiscoverCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[DiscoverCell class]]) {
                cell = (DiscoverCell *)oneObject;
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.Icon sd_setImageWithURL:[NSURL URLWithString:path]placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"dis_0%lu",indexPath.section]]];
    cell.Title.text = title;
    cell.Subtitle.text = remark;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoverModel *model=[_secordMenulist objectAtIndex:indexPath.section];
    NSInteger ID = model.Id;
    if (ID==5) {
        PartnerList *partner = [[PartnerList alloc]init];
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:NO];

    }else if (ID==6){
        ProjectViewController *projectVC=[[ProjectViewController alloc]init];
        projectVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:projectVC animated:NO];
    }else if (ID==7){
        InvestmentVC *invest = [[InvestmentVC alloc]init];
        invest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:invest animated:NO];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10*PMBWIDTH;
    }else{
        return 1*PMBWIDTH;
    }
    
}

-(void)loadData{
    
    [HttpDiscoverAction Discovery:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSMutableArray *menulist=[[NSMutableArray alloc]init];
            menulist=[[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[DiscoverModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
            NSMutableArray *fristMenu=[[NSMutableArray alloc]init];
            NSMutableArray *secordMenu=[[NSMutableArray alloc]init];
            for (DiscoverModel *model in menulist) {
                if (model.type==0) {
                    [fristMenu addObject:model];
                }else{
                    [secordMenu addObject:model];
                }
            }
            _fristMenulist=fristMenu;
            _secordMenulist=secordMenu;
            [self creatmenu];
            [self.tableView reloadData];
        }
    }];
    
    [HttpDiscoverAction GetData:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        NSArray *array=[NSArray new];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            array =[dict objectForKey:@"result"];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            array=[NSArray new];
        
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"数据问题，请重新请求" maskType:SVProgressHUDMaskTypeBlack];
        }
        [self.tableView reloadData];
        self.adsArray=array;
        [_adsView setTotalPagesCount:^NSInteger{
            return [array count];
        }];
    }];
}

-(void)productListButtonClicked:(UIButton *)sender{
    
    UIButton *button=(UIButton*)sender;
    button.highlighted=NO;
    NSInteger listed=button.tag;
    
    if (listed==0) {
        RoomViewController *roomVC=[[RoomViewController alloc]init];
        roomVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:roomVC animated:NO];
    }else if (listed==1) {
        PoineerConsultVC *pointConsult=[[PoineerConsultVC alloc]init];
        pointConsult.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pointConsult animated:NO];
    }else if (listed==2) {
        ActivityListViewController *activityList=[[ActivityListViewController alloc]init];
        activityList.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:activityList animated:NO];
    }else if (listed==3) {
        CollegeVC *college = [[CollegeVC alloc]init];
        college.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:college animated:YES];
    }
}

@end
