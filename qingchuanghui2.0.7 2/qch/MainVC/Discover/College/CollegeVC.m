//
//  CollegeVC.m
//  qch
//
//  Created by 青创汇 on 16/4/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CollegeVC.h"
#import "TutorListVC.h"
#import "CrowdfundinglistVC.h"
#import "LiveOnlineListVC.h"
#import "CrowdfundingCell.h"
#import "RecommendCell.h"
#import "ActivityPayVC.h"
#import "CrowdDetailsVC.h"
#import "CourseListViewController.h"
#import "ApliaySelectVC.h"
#import "CourseViewVC.h"
@interface CollegeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableviewlist;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation CollegeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"双创学院";
    [self getData];
    [self creattableview];
    [self creatheaderview];
    if (_listArray!=nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)creattableview
{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    [tableview setBackgroundColor:[UIColor themeGrayColor]];
    tableview.delegate = self;
    tableview.dataSource = self;
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableviewlist = tableview;
    [self.view addSubview:self.tableviewlist];
    [self setExtraCellLineHidden:self.tableviewlist];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)creatheaderview{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100*PMBWIDTH)];
    _headerView.backgroundColor = [UIColor whiteColor];
    NSArray *menuArray = @[@"众筹",@"课程",@"导师",@"直播"];
    CGFloat width = (self.headerView.frame.size.width-30*PMBWIDTH)/4;
    for (int i=0; i<[menuArray count]; i++) {
        
        NSString *name=[menuArray objectAtIndex:i];
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE+width*i, 0, width, _headerView.height)];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-20*SCREEN_WSCALE);
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"discover_%d",i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:button];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+8*PMBWIDTH, btnView.width, 16*SCREEN_WSCALE)];
        
        nameLabel.text=name;
        nameLabel.font=Font(15);
        nameLabel.textColor=[UIColor blackColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [btnView addSubview:nameLabel];
        
        [self.headerView addSubview:btnView];
    }
    self.tableviewlist.tableHeaderView = _headerView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [_listArray count];
    }else if (section==1){
        return [_funlist count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
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
        if ([(NSNumber*)[dict objectForKey:@"isApply"]integerValue]==1) {
            [cell.Supportbtn setTitle:@"已支持" forState:UIControlStateNormal];
            [cell.Supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
            [cell.Supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
        }else if ([(NSNumber*)[dict objectForKey:@"isApply"]integerValue]==2){
            [cell.Supportbtn setTitle:@"已完结" forState:UIControlStateNormal];
            [cell.Supportbtn setBackgroundColor:TSEAColor(240, 140, 0, 0.3)];
            [cell.Supportbtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.Supportbtn setTitle:@"支持一下" forState:UIControlStateNormal];
            [cell.Supportbtn addTarget:self action:@selector(supportAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        cell.Progress.transform = transform;
        
        cell.Supportbtn.tag = indexPath.section;
        [cell updataframe:dict];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1){
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
        
        RecommendCell *cell = (RecommendCell*)[tableView dequeueReusableCellWithIdentifier:@"RecommendCell"];
        if (cell==nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[RecommendCell class]]) {
                    cell = (RecommendCell *)oneObject;
                }
            }
        }
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Course_Pic"]];
        [cell.HeadImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
        cell.Title.text=[dict objectForKey:@"t_Course_Title"];
        cell.Remark.text=[[dict objectForKey:@"t_Course_Instruction"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
        CrowdDetailsVC *crow = [[CrowdDetailsVC alloc]init];
        crow.guid = [dict objectForKey:@"Guid"];
        [self.navigationController pushViewController:crow animated:YES];
    }else if (indexPath.section==1){
        NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
        CourseViewVC *sourseView=[[CourseViewVC alloc]init];
        sourseView.guid=[dict objectForKey:@"Guid"];
        [self.navigationController pushViewController:sourseView animated:YES];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*PMBWIDTH)];
    headView.backgroundColor=[UIColor themeGrayColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 5*PMBWIDTH,ScreenWidth-10*PMBWIDTH , 20*PMBWIDTH)];
    title.textColor = [UIColor lightGrayColor];
    title.font = Font(15);
    [headView addSubview:title];
    if (section==0) {
        title.text = @"众筹课程";
    }else if (section==1){
        title.text = @"热门推荐";
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30*PMBWIDTH;
}

- (void)noAction{
    
}

- (void)getData
{
    
    [HttpCollegeAction GetRecommendFundCourse:TOP userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"top"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _listArray = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _listArray = [[NSMutableArray alloc]init];

        }
        [_tableviewlist reloadData];
    }];
    
    [HttpCollegeAction GetRecommendCourse:TOP userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"top"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _funlist = [[NSMutableArray alloc]init];
        }
        [_tableviewlist reloadData];
        
    }];

}


- (void)ButtonClicked:(UIButton *)sender
{
    NSInteger listed = sender.tag;
    if (listed==0) {
        CrowdfundinglistVC *list = [[CrowdfundinglistVC alloc]init];
        [self.navigationController pushViewController:list animated:YES];
    }else if (listed==1){
        CourseListViewController *course = [[CourseListViewController alloc]init];
        [self.navigationController pushViewController:course animated:YES];
    }else if (listed==2){
        TutorListVC *teacher = [[TutorListVC alloc]init];
        [self.navigationController pushViewController:teacher animated:YES];
    }else if (listed==3){
        LiveOnlineListVC *live = [[LiveOnlineListVC alloc]init];
        [self.navigationController pushViewController:live animated:YES];
    }
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
