//
//  CertificateViewController.m
//  qch
//
//  Created by 青创汇 on 16/4/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CertificateViewController.h"
#import "CertificateCell.h"
#import "CertificateDetailVC.h"
@interface CertificateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableListView;
@property (nonatomic,strong)NSMutableArray *ListArray;

@end

@implementation CertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名凭证列表";
    [self createTableView];
    if (_ListArray != nil) {
        _ListArray = [[NSMutableArray alloc]init];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //禁用
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)createTableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableListView=tableView;
    self.tableListView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableListView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:tableView];
    [self refeleshController];
    [self setExtraCellLineHidden:self.tableListView];

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
    [HttpActivityAction GetMyApplyList:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _ListArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _ListArray=[[NSMutableArray alloc]init];
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
            _ListArray=[[NSMutableArray alloc]init];
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
        if ([_ListArray count]>0) {
            self.tableListView.tableHeaderView = nil;
        }
        [self.tableListView.mj_header endRefreshing];
        [self.tableListView reloadData];
    }];
    
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

- (void)footerFreshing
{
    
    if ([_ListArray count] > 0 && [_ListArray count] % PAGESIZE == 0) {
    [HttpActivityAction GetMyApplyList:UserDefaultEntity.uuid page:[_ListArray count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
         NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [_ListArray addObjectsFromArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
         [self.tableListView reloadData];
         [self.tableListView.mj_footer endRefreshing];
    }];
    }else{
        [self.tableListView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_ListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateCell *cell = (CertificateCell*)[tableView dequeueReusableCellWithIdentifier:@"CertificateCell"];
    NSDictionary *dict = [_ListArray objectAtIndex:indexPath.row];
    if (cell==nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CertificateCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[CertificateCell class]]) {
                cell = (CertificateCell *)oneObject;
            }
        }
    }
    if ([[dict objectForKey:@"t_Activity_Fee"] floatValue]==0) {
        cell.Typelab.text = [dict objectForKey:@"t_Activity_FeeType"];
    }else{
        cell.Typelab.text = @"付费";
    }
    
    cell.TitleLab.text = [dict objectForKey:@"t_Activity_Title"];
    cell.OrganizerLab.text = [NSString stringWithFormat:@"主办方:%@",[dict objectForKey:@"t_Activity_Holder"]];
    NSDate *time = [DateFormatter stringToDateCustom:[dict objectForKey:@"t_Activity_sDate"] formatString:def_YearMonthDayHourMinuteSec_DF];
    NSString *date = [DateFormatter dateToStringCustom:time formatString:def_YearMonthDay_];
    cell.TimeLab.text =[NSString stringWithFormat:@"活动时间:%@",date];
    cell.AddressLab.text =[NSString stringWithFormat:@"活动地点:%@%@",[dict objectForKey:@"t_Activity_CityName"],[dict objectForKey:@"t_Activity_Street"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_ListArray objectAtIndex:indexPath.row];
    CertificateDetailVC *detail = [[CertificateDetailVC alloc]init];
    detail.ApplyGuid = [dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
