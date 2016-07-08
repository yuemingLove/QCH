//
//  CourseViewController.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CrowdfundinglistVC.h"
#import "CrowdfundingCell.h"
#import "CrowdDetailsVC.h"
#import "ActivityPayVC.h"
#import "ApliaySelectVC.h"
@interface CrowdfundinglistVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSString *key;
}

@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation CrowdfundinglistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"众筹列表";
    key = @"";
    [self createSearchBar];
    [self creatTableview];
    if (_listArray!=nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refeleshController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createSearchBar{
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-10, 5, SCREEN_WIDTH+20, 30)];
    searchBar.barStyle = UISearchBarStyleDefault;
    searchBar.tintColor = [UIColor clearColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入导师、课程标题搜索";
    [searchBar setContentMode:UIViewContentModeLeft];
    [self.view addSubview:searchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    key=searchBar.text;
    [searchBar resignFirstResponder];
    [self headerFreshing];
}

- (void)creatTableview
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableviewlist = tableView;
    self.tableviewlist.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableviewlist.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    [self.view addSubview:tableView];
    [self setExtraCellLineHidden:self.tableviewlist];
    
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableviewlist.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableviewlist.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableviewlist.mj_footer resetNoMoreData];
    }

    [HttpCollegeAction GetCrowdfundlist:key userGuid:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"key"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _listArray = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _listArray = [[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableviewlist.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.tableviewlist.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });
        } else {
            _listArray = [[NSMutableArray alloc]init];

            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableviewlist.frame];
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
            self.tableviewlist.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
        if ([_listArray count]>0) {
            self.tableviewlist.tableHeaderView = nil;
        }
        [self.tableviewlist.mj_header endRefreshing];
        [self.tableviewlist reloadData];
    }];
    
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}
- (void)footerFreshing{
    
    if ([_listArray count]>0 && [_listArray count] % PAGESIZE == 0) {
        
        [HttpCollegeAction GetCrowdfundlist:@"" userGuid:UserDefaultEntity.uuid page:[_listArray count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"key"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict = result[0];
            
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                [_listArray addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
            }
            [self.tableviewlist reloadData];
            [self.tableviewlist.mj_footer endRefreshing];
        }];
    }else{
        [self.tableviewlist.mj_footer endRefreshingWithNoMoreData];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listArray count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    CrowdfundingCell *cell = (CrowdfundingCell*)[tableView dequeueReusableCellWithIdentifier:@"CrowdfundingCell"];
    if (cell==nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"CrowdfundingCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[CrowdfundingCell class]]) {
                cell = (CrowdfundingCell *)oneObject;
            }
        }
    }
    if ([[dict objectForKey:@"T_FundCourse_Pic"]isEqualToString:@""]) {
        
    }else{
        NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"T_FundCourse_Pic"]]];
        [cell.LogoImg sd_setImageWithURL:path placeholderImage:[UIImage imageNamed:@"loading_1"]];
    }
    cell.Supportbtn.tag = indexPath.row;
    if ([(NSNumber *)[dict objectForKey:@"isApply"]integerValue]==1) {
        [cell.Supportbtn setTitle:@"已支持" forState:UIControlStateNormal];
        [cell.Supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
        [cell.Supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    }else if ([(NSNumber*)[dict objectForKey:@"isApply"]integerValue]==2){
        [cell.Supportbtn setTitle:@"已完结" forState:UIControlStateNormal];
        [cell.Supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
        [cell.Supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [cell.Supportbtn setTitle:@"支持一下" forState:UIControlStateNormal];
        [cell.Supportbtn addTarget:self action:@selector(supportAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 5.0f);
    cell.Progress.transform = transform;
    [cell updataframe:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    CrowdDetailsVC *crow = [[CrowdDetailsVC alloc]init];
    crow.guid = [dict objectForKey:@"Guid"];
    crow.LiveURL = [NSString stringWithFormat:@"%@%@",SERIVE_LIVE,[dict objectForKey:@""]];
    [self.navigationController pushViewController:crow animated:YES];
    
}

- (void)noAction{
    
}

- (void)supportAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSDictionary *FundCoursedic = [_listArray objectAtIndex:index];
    ApliaySelectVC *Apliay = [[ApliaySelectVC alloc]init];
    Apliay.hidesBottomBarWhenPushed = YES;
    if ([[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Online"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Online"]]) {
        Apliay.onlinemoney = @"0";
    }else{
        Apliay.onlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Online"];
    }
    if ([[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0"]||[[FundCoursedic objectForKey:@"T_PayMoney_Offline"]isEqualToString:@"0.00"]||[self isBlankString:[FundCoursedic objectForKey:@"T_PayMoney_Offline"]]){
        Apliay.offlinemoney = @"0";
    }else{
        Apliay.offlinemoney = [FundCoursedic objectForKey:@"T_PayMoney_Offline"];
    }
    Apliay.Street = [FundCoursedic objectForKey:@"t_FundCourse_Street"];
    Apliay.guid = [FundCoursedic objectForKey:@"Guid"];
    Apliay.titlestr = [FundCoursedic objectForKey:@"T_FundCourse_Title"];
    [self.navigationController pushViewController:Apliay animated:YES];

}

@end
