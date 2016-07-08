//
//  ProjectViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectCell.h"
#import "ProjectDetailVC.h"
#import "ProjectSelectTypeVC.h"
#import "PersonInfomationVC.h"
#import "AddProjectVC.h"
#import "SendProjectFourVC.h"
#import "SearchViewController.h"
#import "FMDBHelper.h"

@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectCellDelegate,QchCityViewControllerDelegate,UIAlertViewDelegate>{
    NSString *cityStr;
    
    NSString *pPhase;
    NSString *pFinancePhase;
    NSString *pParterWant;
    NSString *pField;
    NSString *Key;
    
    UIButton *shareBtn;
    UIButton *collectBtn;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *typelist;

@property (nonatomic,strong) NSMutableArray *cityList;

@property (nonatomic,strong) UIButton *selectCity;

@end

@implementation ProjectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目"];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    if (_cityList!=nil) {
        _cityList=[[NSMutableArray alloc]init];
    }
    
    if (_typelist!=nil) {
        _typelist=[[NSMutableArray alloc]init];
    }
    
    cityStr=@"";
    pPhase=@"";
    pFinancePhase=@"";
    pParterWant=@"";
    pField=@"";
    Key = @"";
    [self getHotCity];
    [self getProjectType];
    
    
    shareBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.frame=CGRectMake(0, 0, 32, 32);
    [shareBtn setImage:[UIImage imageNamed:@"sousuo_btn"] forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    //给button添加委托方法，即点击触发的事件。
    [shareBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    collectBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    collectBtn.frame=CGRectMake(0, 0, 32, 32);
    [collectBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    //给button添加委托方法，即点击触发的事件。
    [collectBtn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *collectBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:collectBtn];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareBarButtonItem,collectBarButtonItem, nil];
    
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
    
    [self createSelectView];
    [self createTableView];
    // 添加观察者, 观察手动触发下拉刷新的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mjPullingAction) name:@"mjstatepulling" object:nil];
}
- (void)mjPullingAction {
    pPhase=@"";
    pFinancePhase=@"";
    pParterWant=@"";
    pField=@"";
    Key = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pPhase"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pFinancePhase"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pParterWant"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pField"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refeleshView"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pPhase"]]) {
        pPhase=@"";
    } else {
        pPhase=[[NSUserDefaults standardUserDefaults] objectForKey:@"pPhase"];
    }
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pFinancePhase"]]) {
        pFinancePhase=@"";
    } else {
        pFinancePhase=[[NSUserDefaults standardUserDefaults] objectForKey:@"pFinancePhase"];
    }
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pParterWant"]]) {
        pParterWant=@"";
    } else {
        pParterWant=[[NSUserDefaults standardUserDefaults] objectForKey:@"pParterWant"];
    }
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"pField"]]) {
        pField=@"";
    } else {
        pField=[[NSUserDefaults standardUserDefaults] objectForKey:@"pField"];
    }
    
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"refeleshView"]]) {
        [self refeleshController];
        }
    
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

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pPhase"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pFinancePhase"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pParterWant"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pField"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refeleshView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)createSelectView{

    UIView *selectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.view addSubview:selectView];
    
    CGFloat width=(SCREEN_WIDTH-1)/2;

    _selectCity=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, width, 30)];
    _selectCity.titleLabel.font=Font(15);
    [_selectCity setTitle:@"全国" forState:UIControlStateNormal];
    [_selectCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectCity setImage:[UIImage imageNamed:@"select_set"] forState:UIControlStateNormal];
    _selectCity.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

    _selectCity.imageEdgeInsets = UIEdgeInsetsMake(0, _selectCity.titleLabel.width+50, 0, -_selectCity.titleLabel.width-50);
    
    [_selectCity addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:_selectCity];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(_selectCity.right, _selectCity.top, 1, _selectCity.height)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [selectView addSubview:line];
    
    UIButton *selectType=[[UIButton alloc]initWithFrame:CGRectMake(width+1, _selectCity.top, width, _selectCity.height)];
    selectType.titleLabel.font=Font(15);
    [selectType setTitle:@"筛选" forState:UIControlStateNormal];
    [selectType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectType setImage:[UIImage imageNamed:@"select_set"] forState:UIControlStateNormal];
    selectType.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    selectType.imageEdgeInsets = UIEdgeInsetsMake(0, selectType.titleLabel.width+50, 0, -selectType.titleLabel.width-50);
    
    [selectType addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectType];

    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, selectView.height-1, SCREEN_WIDTH, 1)];
    [line2 setBackgroundColor:[UIColor themeGrayColor]];
    [selectView addSubview:line2];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];

    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];

    [self refeleshController];
}

-(void)getHotCity{
    [HttpLoginAction getHotCity:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _cityList=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _cityList=[[NSMutableArray alloc]init];
        }
    }];
}

-(void)getProjectType{
    
    [HttpProjectAction getStyles:[MyAes aesSecretWith:@"Ids"] Byids:@"82,83,84,85" complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _typelist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else{
            _typelist=[[NSMutableArray alloc]init];
        }
    }];

}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)headerFreshing{
    NSString *city = @"";
    if ([cityStr isEqualToString:@"全国"]) {
        cityStr = city;
    }
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpProjectAction GetProject2:UserDefaultEntity.uuid cityName:cityStr pPhase:pPhase pFinancePhase:pFinancePhase pParterWant:pParterWant pField:pField key:Key page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            [self.tableView reloadData];
            
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
        
        [HttpProjectAction GetProject2:UserDefaultEntity.uuid cityName:cityStr pPhase:pPhase pFinancePhase:pFinancePhase pParterWant:pParterWant pField:pField key:Key page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
  
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"illegal"]) {
                
            }else{
                
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
                cell.projectDelegate=self;
            }
        }
    }
    cell.label.text = @"融资阶段:";
    cell.tag = indexPath.row;
    [cell updateFrame:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    ProjectDetailVC *projectDeatil=[[ProjectDetailVC alloc]init];
    projectDeatil.guId=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:projectDeatil animated:YES];
}

-(void)selectCity:(id)sender{
    QchCityViewController *qchSelectCity=[[QchCityViewController alloc]init];
    qchSelectCity.cityDelegate=self;
    qchSelectCity.citylist=_cityList;
    [self.navigationController pushViewController:qchSelectCity animated:YES];
}

-(void)selectCityData:(NSString *)city{
    cityStr=city;
    if ([city isEqualToString:@""]) {
        cityStr = @"全国";
        [_selectCity setTitle:@"全国" forState:UIControlStateNormal];
    } else {
        [_selectCity setTitle:city forState:UIControlStateNormal];
    }
    // 调整cityButton随内容自适应宽度
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGFloat length = [cityStr boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    _selectCity.titleEdgeInsets = UIEdgeInsetsZero;
    _selectCity.imageEdgeInsets = UIEdgeInsetsZero;
    _selectCity.frame = CGRectMake(10, 5, (SCREEN_WIDTH-1)/2, 30);
    [_selectCity setTitle:cityStr forState:UIControlStateNormal];
    _selectCity.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    _selectCity.imageEdgeInsets = UIEdgeInsetsMake(0, length, 0, -length);
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)selectType:(id)sender{
    
    
    ProjectSelectTypeVC *projectSelectType=[[ProjectSelectTypeVC alloc]init];
    projectSelectType.typelist=_typelist;
    [self.navigationController pushViewController:projectSelectType animated:YES];
}


-(void)sendBtn:(id)sender{
    
    NSInteger style= [(NSNumber*)UserDefaultEntity.user_style integerValue];
    if (style==2) {
        [SVProgressHUD showErrorWithStatus:@"您是投资人，没有发布项目的权限" maskType:SVProgressHUDMaskTypeBlack];
        return;
    } else if(style==3){

        AddProjectVC *addproject = [[AddProjectVC alloc]init];
        addproject.citylist = _cityList;
        // 清除数据库
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]) {
            [[FMDBHelper shareFMDBHelper] eraseTable:@"Project"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_id"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]) {
            [[FMDBHelper shareFMDBHelper] eraseTable:@"ProjectImage"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"proImage_id"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proFun_id"]) {
            [[FMDBHelper shareFMDBHelper] eraseTable:@"ProjectFun"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"proFun_id"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_buttonStr"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_buttonStr"];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_waitStr"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pro_waitStr"];
        }

        [self.navigationController pushViewController:addproject animated:YES];
        
    }else{
    
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的身份是创客，需要认证合伙人以后才能发布项目" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)search:(id)sender
{
    SearchViewController *search = [[SearchViewController alloc]init];
    [search returnString:^(NSString *SearchString) {
        Key = SearchString;
        [self headerFreshing];
    }];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        PersonInfomationVC *personVC=[[PersonInfomationVC alloc]init];
        [self.navigationController pushViewController:personVC animated:YES];
    }
}
#pragma mark - backAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 移除观察者
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mjstatepulling" object:nil];
}
@end
