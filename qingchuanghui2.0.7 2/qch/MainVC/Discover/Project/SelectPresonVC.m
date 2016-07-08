//
//  SelectPresonVC.m
//  qch
//
//  Created by W.兵 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SelectPresonVC.h"
#import "TeacherCell.h"

@interface SelectPresonVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    NSString *key;
}


@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *seleArray;



@end

@implementation SelectPresonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择合伙人"];
    _seleArray = [[NSMutableArray array]init];
    key=@"";
    
    if (_funlist != nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveData:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [self createSearchBar];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)saveData:(UIButton*)sender{

    NSSet *set=[NSSet setWithArray:_seleArray];
    NSArray *array=[set allObjects];
    NSMutableArray *muArray=[array copy];
    
    if (self.returnArray!=nil) {
        self.returnArray(muArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createSearchBar{
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-10, 5, SCREEN_WIDTH+20, 30)];
    searchBar.barStyle = UISearchBarStyleDefault;
    searchBar.tintColor = [UIColor clearColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"输入合伙人姓名搜索";
    [searchBar setContentMode:UIViewContentModeLeft];
    [self.view addSubview:searchBar];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    key=searchBar.text;
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

    [HttpPartnerAction GetUserList2:@"3" userGuid:UserDefaultEntity.uuid best:@"" foucs:@"" city:@"" key:key page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
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
    
    if ([_funlist count]>0 && [_funlist count]% PAGESIZE ==0) {
        
        [HttpPartnerAction GetUserList2:@"3" userGuid:UserDefaultEntity.uuid best:@"" foucs:@"" city:@"" key:key page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                _funlist=[[NSMutableArray alloc]init];
                
            }else{
                _funlist=[[NSMutableArray alloc]init];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
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
    
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
   
    TeacherCell *cell = (TeacherCell*)[tableView dequeueReusableCellWithIdentifier:@"TeacherCell"];
    if (cell==nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"TeacherCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[TeacherCell class]]) {
                cell = (TeacherCell *)oneObject;
            }
        }
    }
    [cell.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"t_User_Pic"]]] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    cell.Name.text = [dict objectForKey:@"t_User_RealName"];
    cell.Remark.text = [[dict objectForKey:@"t_User_Remark"] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
    cell.position.hidden=NO;
    cell.position.text=[dict objectForKey:@"t_Position"];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    if ([self setSignBtn:[dict objectForKey:@"Guid"]]) {
        
        if ([_seleArray count]==0) {
            [_seleArray addObject:dict];
        }else{
            if ([self setSaveBtn:[dict objectForKey:@"Guid"]]) {
                [_seleArray addObject:dict];
            }
        }
        cell.isSelect = YES;
        [cell.selectbtn setImage:[UIImage imageNamed:@"xuanzhong.jpg"] forState:UIControlStateNormal];
    }else{
        cell.isSelect = NO;
        [cell.selectbtn setImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TeacherCell *cell = (TeacherCell*)[tableView  cellForRowAtIndexPath:indexPath];
    if (cell.isSelect) {
        cell.isSelect = NO;
        [cell.selectbtn setImage:[UIImage imageNamed:@"weixuanzhong.jpg"] forState:UIControlStateNormal];
        [_seleArray removeObject:[_funlist objectAtIndex:indexPath.row]];
    }else{
        cell.isSelect = YES;
        [cell.selectbtn setImage:[UIImage imageNamed:@"xuanzhong.jpg"] forState:UIControlStateNormal];
        [_seleArray addObject:[_funlist objectAtIndex:indexPath.row]];
    }
    

}

- (BOOL)setSignBtn:(NSString*)Guid{
    
    for (NSDictionary *item in _selectArray) {
        if ([[item objectForKey:@"Guid"] isEqualToString:Guid]) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)setSaveBtn:(NSString *)guid{
    for (NSDictionary *item in _seleArray) {
        if (![[item objectForKey:@"Guid"] isEqualToString:guid]) {
            return YES;
        }else{
            
        }
    }
    
    return NO;
}

- (void)returnArray:(ReturnArrayblock)block
{
    self.returnArray = block;
}


@end
