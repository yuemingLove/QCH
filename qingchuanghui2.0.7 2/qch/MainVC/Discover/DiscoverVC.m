//
//  DiscoverVC.m
//  qch
//
//  Created by W.兵 on 16/4/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DiscoverVC.h"
#import "PoineerConsultVC.h"
#import "ActivityListViewController.h"
#import "ProjectViewController.h"
#import "PartnViewController.h"
#import "RoomViewController.h"
#import "PrivateVC.h"
#import "InvestmentVC.h"
#import "CourseDetailVC.h"
#import "DiscoverModel.h"
#import "CollegeVC.h"
@interface DiscoverVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View
@property (strong, nonatomic) NSArray *adsArray;

@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) NSMutableArray *fristMenulist;
@property (nonatomic,strong) NSMutableArray *secordMenulist;

@end

@implementation DiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"发现"];
    
    if (_fristMenulist !=nil) {
        _fristMenulist=[[NSMutableArray alloc]init];
    }
    
    if (_secordMenulist !=nil) {
        _secordMenulist=[[NSMutableArray alloc]init];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
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
    [self loadData];
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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=[UIColor themeGrayColor];
    
    //广告：定时器广告图片切换
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300*SCREEN_WSCALE)];
    _headerView.backgroundColor=[UIColor whiteColor];
    {
        __weak DiscoverVC *weakSelf=self;
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
    
    //服务菜单
    {
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, _adsView.frame.size.height, SCREEN_WIDTH, 100.0*SCREEN_WSCALE)];
        
        CGFloat width=(self.menuView.frame.size.width-30*SCREEN_WSCALE)/4.0;
        for (int i=0; i<[_fristMenulist count]; i++) {
            
            DiscoverModel *model=[_fristMenulist objectAtIndex:i];
            
            NSString *name=model.Title;
            
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10*SCREEN_WSCALE, 15*SCREEN_WHCALE, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
            
            NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_Discovery,model.Pic];
            [button sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_1"]];
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
        [_headerView addSubview:self.menuView];
    }
    
    _tableView.tableHeaderView=_headerView;
    
}

-(void)createItemView{
    
    self.footerView=[[UIView alloc]initWithFrame:CGRectMake(0, _headerView.bottom+10, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    [self.footerView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat width=SCREEN_WIDTH/2.0;
    for (int i=0; i<[_secordMenulist count]; i++) {
        DiscoverModel *model=[_secordMenulist objectAtIndex:i];
        NSString *name=model.Title;
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake((i % 2) * width, (i / 2) * 80*SCREEN_WSCALE , width, 80*SCREEN_WSCALE)];
        [self.footerView addSubview:btnView];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btnView.frame;
        
        button.tag = i;
        [button addTarget:self action:@selector(communityClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(width-55*SCREEN_WSCALE, 17*SCREEN_WSCALE, 45*SCREEN_WSCALE, 45*SCREEN_WSCALE)];

        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_Discovery,model.Pic];
        [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
        [btnView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, imageView.top, width-55*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
        nameLabel.text=name;
        nameLabel.font=[UIFont systemFontOfSize:15];
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentLeft;
        [btnView addSubview:nameLabel];
        
        NSString *message=model.Remark;

        
        UILabel *contentLabel=[self createLabelFrame:CGRectMake(nameLabel.left, nameLabel.bottom+10, nameLabel.width, 14*SCREEN_WSCALE) color:[UIColor grayColor] font:Font(13) text:message];
        [btnView addSubview:contentLabel];
    }
    
    for (int i = 1; i < [_secordMenulist count] / 2; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 80 * SCREEN_WSCALE, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor themeGrayColor];
        [self.footerView addSubview:lineView];
    }
    for (int i = 1; i < 2; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, 1, 160 * SCREEN_WSCALE)];
        lineView.backgroundColor = [UIColor themeGrayColor];
        [self.footerView addSubview:lineView];
    }
    
    _tableView.tableFooterView=_footerView;

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
            [self createTableView];
            [self createItemView];
        }else{
            _fristMenulist=[[NSMutableArray alloc]init];
            _secordMenulist=[[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
    
    [HttpDiscoverAction GetData:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        NSArray *array=[NSArray new];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            array =[dict objectForKey:@"result"];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            array=[NSArray new];
        }
        self.adsArray=array;
        [_adsView setTotalPagesCount:^NSInteger{
            return [array count];
        }];
    }];

}

-(void)communityClicked:(UIButton*)sender{
    
    NSInteger index=[sender tag];
    if (index==0) {
        PoineerConsultVC *pointConsult=[[PoineerConsultVC alloc]init];
        pointConsult.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pointConsult animated:NO];
    }else if (index==1){
        InvestmentVC *invest = [[InvestmentVC alloc]init];
        invest.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:invest animated:NO];
    }else if (index==2){
        CollegeVC *college = [[CollegeVC alloc]init];
        college.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:college animated:YES];
    }else if (index==3){
        PrivateVC *private=[[PrivateVC alloc]init];
        private.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:private animated:NO];
    }
}


-(IBAction)productListButtonClicked:(id)sender{
    
    UIButton *button=(UIButton*)sender;
    button.highlighted=NO;
    NSInteger listed=button.tag;
    
    if (listed==0) {
        ActivityListViewController *activityList=[[ActivityListViewController alloc]init];
        activityList.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:activityList animated:NO];
    }else if (listed==1) {
        ProjectViewController *projectVC=[[ProjectViewController alloc]init];
        projectVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:projectVC animated:NO];
    }else if (listed==2) {
        PartnViewController *partnVC=[[PartnViewController alloc]init];
        partnVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:partnVC animated:NO];
    }else if (listed==3) {
        RoomViewController *roomVC=[[RoomViewController alloc]init];
        roomVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:roomVC animated:NO];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.backgroundColor=[UIColor themeGrayColor];
    return cell;
}


@end
