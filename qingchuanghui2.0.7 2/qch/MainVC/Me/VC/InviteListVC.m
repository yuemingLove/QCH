//
//  InviteListVC.m
//  qch
//
//  Created by 青创汇 on 16/5/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InviteListVC.h"
#import "InviteCell.h"
#import "InviteDetailsVC.h"
@interface InviteListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableListView;

@property (nonatomic,strong) NSMutableArray *funlist;

@end



@implementation InviteListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请列表";
    // Do any additional setup after loading the view.
    [self createMainView];
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(void)createMainView{
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40*PMBWIDTH, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableListView=tableView;
    self.tableListView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableListView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:tableView];
    [self refeleshController];
    [self setExtraCellLineHidden:self.tableListView];
    

    
    UILabel *yaoqinglab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 40*PMBWIDTH)];
    yaoqinglab.text = @"邀请的人";
    yaoqinglab.font = Font(14);
    yaoqinglab.textAlignment = NSTextAlignmentCenter;
    yaoqinglab.textColor = [UIColor blackColor];
    [self.view addSubview:yaoqinglab];
    
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, yaoqinglab.height)];
    timelab.textColor = [UIColor blackColor];
    timelab.text = @"注册时间";
    timelab.textAlignment = NSTextAlignmentCenter;
    timelab.font = Font(14);
    [self.view addSubview:timelab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:line];
    
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableListView.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableListView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableListView.mj_footer resetNoMoreData];
    }

    [HttpCenterAction GetInviteUserList:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
         NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableListView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableListView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });
            
        }else{
            _funlist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableListView.frame];
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
            self.tableListView.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
        if ([_funlist count]>0) {
            self.tableListView.tableHeaderView = nil;
        }
        [self.tableListView.mj_header endRefreshing];
        [self.tableListView reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

-(void)footerFreshing{
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        [HttpCenterAction GetInviteUserList:UserDefaultEntity.uuid page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }
            
            [self.tableListView reloadData];
            
            [self.tableListView.mj_footer endRefreshing];
        }];
    }else{
        [self.tableListView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    InviteCell *cell =  (InviteCell*)[tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"InviteCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[InviteCell class]]) {
                cell = (InviteCell *)oneObject;
            }
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.InviteLab.text = [dict objectForKey:@"t_User_LoginId"];
    cell.TimeLab.text = [dict objectForKey:@"t_User_Date"];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    InviteDetailsVC *invitedetails = [[InviteDetailsVC alloc]init];
    invitedetails.guid = [dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:invitedetails animated:YES];
}



@end
