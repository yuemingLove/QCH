//
//  TutorListVC.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TutorListVC.h"
#import "TutorDetailVC.h"
#import "ProjectCell.h"

@interface TutorListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSString *key;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation TutorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"导师"];
    
    self.view.backgroundColor=[UIColor themeGrayColor];
    
    key=@"";
    
    if (_funlist != nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    [self createSearchBar];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createSearchBar{
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-10, 5, SCREEN_WIDTH+20, 30)];
    searchBar.barStyle = UISearchBarStyleDefault;
    searchBar.tintColor = [UIColor clearColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入导师搜索";
    [searchBar setContentMode:UIViewContentModeLeft];
    [self.view addSubview:searchBar];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    key=searchBar.text;
    [searchBar resignFirstResponder];
    [self headerFreshing];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpCollegeAction GetLecturer:key userGuid:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"key"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
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
        
        [HttpCollegeAction GetLecturer:key userGuid:UserDefaultEntity.uuid page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"key"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }
            [self.tableView reloadData];
            
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
            }
        }
    }
    cell.tag = indexPath.row;
    cell.label.text=@"Ta的擅长:";
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"T_Lecturer_Pic"]];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    cell.themeLabel.text=[dict objectForKey:@"T_Lecturer_Name"];
    NSString *position=[[dict objectForKey:@"T_Lecturer_Position"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    cell.nameLabel.text=position;
    
    NSString *content=[dict objectForKey:@"T_Lecturer_Intor"];
    content=[content stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    cell.contentLabel.text=content;
    cell.careButton.hidden=YES;
    cell.signImageView.hidden=YES;
    cell.statusLabel.hidden=YES;

    cell.projectLabel.text=[[dict objectForKey:@"T_Lecturer_GoodArea"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    TutorDetailVC *tutorDetail=[[TutorDetailVC alloc]init];
    tutorDetail.Guid=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:tutorDetail animated:YES];
}


@end
