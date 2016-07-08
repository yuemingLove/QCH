//
//  PartnViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartnViewController.h"
#import "ProjectCell.h"
#import "ParntDetailVC.h"

@interface PartnViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectCellDelegate>{
    NSString *IsInvestor;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation PartnViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetIsInvestor];
    [self setTitle:@"投资人"];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    if (![UserDefaultEntity.user_style isEqualToString:@"2"] && ![UserDefaultEntity.user_style isEqualToString:@"3"]) {
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"认证" style:UIBarButtonItemStylePlain target:self action:@selector(VCAction:)];
        self.navigationItem.rightBarButtonItem = right;
        
    }else if ([UserDefaultEntity.user_style isEqualToString:@"2"]&&[IsInvestor isEqualToString:@"0"]){
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"认证" style:UIBarButtonItemStylePlain target:self action:@selector(VCAction:)];
        self.navigationItem.rightBarButtonItem = right;
    }
    [self createTableView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
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

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpPartnerAction GetUserList2:@"2" userGuid:UserDefaultEntity.uuid best:@"" foucs:@"" city:@"" key:@"" page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _funlist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });

        }else{
            _funlist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            UILabel *tixinglab = [[UILabel alloc]initWithFrame:CGRectMake(0, empty.bottom+5*PMBWIDTH, ScreenWidth, 20*PMBWIDTH)];
            tixinglab.text = @"加载失败，触屏重新加载";
            tixinglab.textColor = [UIColor lightGrayColor];
            tixinglab.font = Font(15);
            tixinglab.textAlignment = NSTextAlignmentCenter;
            [emptyView addSubview:tixinglab];
            [emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)]];
            self.tableView.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
        if ([_funlist count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

-(void)footerFreshing{
    
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
            
        [HttpPartnerAction GetUserList2:@"2" userGuid:UserDefaultEntity.uuid best:@""foucs:@"" city:@"" key:@"" page:[_funlist count]/PAGESIZE + 1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                _funlist=[[NSMutableArray alloc]init];
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                
            }else{
                _funlist=[[NSMutableArray alloc]init];
            }
            
            [_tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    
    ProjectCell *cell = (ProjectCell*)[tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ProjectCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[ProjectCell class]]) {
                cell = (ProjectCell *)oneObject;
                cell.projectDelegate=self;
            }
        }
    }
    cell.tag = indexPath.row;
    cell.label.text=@"投资领域:";
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    cell.themeLabel.text=[dict objectForKey:@"t_User_RealName"];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@  %@",[dict objectForKey:@"PositionName"],[dict objectForKey:@"t_User_Commpany"]];
    cell.contentLabel.text=[dict objectForKey:@"t_User_Remark"];
    cell.numLabel.text=[dict objectForKey:@"FCount"];
    
    NSArray *itemArray=(NSArray*)[dict objectForKey:@"InvestPhase"];
    if ([itemArray count]>0) {
        NSDictionary *item=itemArray[0];
        cell.statusLabel.text=[item objectForKey:@"InvestPhaseName"];
    }
    
    
    NSInteger ifPraise=[(NSNumber*)[dict objectForKey:@"ifFoucs"]integerValue];
    if (ifPraise==0) {
        [cell.careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];
    }else{
        [cell.careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];
    }
    
    NSMutableArray *array=(NSMutableArray*)[dict objectForKey:@"InvestArea"];
    NSString *string=@"";
    for (NSDictionary *item2 in array) {
        //InvestAreaName
        if ([self isBlankString:string]) {
            string=[item2 objectForKey:@"InvestAreaName"];
        } else {
            string=[string stringByAppendingFormat:@" / %@",[item2 objectForKey:@"InvestAreaName"]];
        }
    }
    cell.projectLabel.text=string;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    ParntDetailVC *parntDetailVC=[[ParntDetailVC alloc]init];
    parntDetailVC.Guid=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:parntDetailVC animated:YES];
}


-(void)VCAction:(id)sender{
    if ([UserDefaultEntity.user_style isEqualToString:@"2"]&&[IsInvestor isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"您申请投资人正在审核中……" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        
        InvestorsInformationVC *information = [[InvestorsInformationVC alloc]init];
        information.IforNo=YES;
        information.hidesBottomBarWhenPushed = YES;
        information.title = @"投资人认证";
        [self.navigationController pushViewController:information animated:YES];
}
}

@end
