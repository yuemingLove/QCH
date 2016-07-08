//
//  ActivityListViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityCell.h"
#import "SendActivityVC.h"
#import "ActivityDetailVC.h"

@interface ActivityListViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    NSString *cityName;
    NSString *feeType;
    NSString *day;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *userlist;
@property (nonatomic,strong) NSMutableArray *citylist;

@property (nonatomic,strong) NSArray *cityArray;
@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *priceArray;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"活动"];
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_userlist!=nil) {
        _userlist=[[NSMutableArray alloc]init];
    }
    if (_citylist!=nil) {
        _citylist=[[NSMutableArray alloc]init];
    }
    [self getHotCity];
    cityName=@"";
    feeType=@"";
    day=@"";

    _timeArray=@[@"日期",@"今天",@"明天",@"最近一周"];
    _priceArray=@[@"费用",@"免费",@"付费"];
    
    [self createTableView];
    
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(sendBtn:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeleshController) name:@"refeleshView" object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refeleshView" object:nil];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)refeleshController {//调用这个方法关闭B，显示A
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)getHotCity{

    [HttpLoginAction getHotCity:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSMutableArray *items=[[NSMutableArray alloc]init];
            _citylist=(NSMutableArray*)[dict objectForKey:@"result"];
            [items addObject:@"全国"];
            for (NSDictionary *item in _citylist) {
                NSString *typeName=[item objectForKey:@"CityName"];
                [items addObject:typeName];
            }
            _cityArray=[items copy];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"illegal"]){
            _citylist=[[NSMutableArray alloc]init];
        }
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
        
        menu.delegate = self;
        menu.dataSource = self;
        [self.view addSubview:menu];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(activityHeaderFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(activityFooterFreshing)];

    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    if (column == 0) {
        return _cityArray.count;
    }else if (column == 1) {
        return _timeArray.count;
    }else{
        return _priceArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        return _cityArray[indexPath.row];
    }else if (indexPath.column == 1) {
        return _timeArray[indexPath.row];
    } else{
        return _priceArray[indexPath.row];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.column == 0) {
        cityName=_cityArray[indexPath.row];
        if ([cityName isEqualToString:@"全国"]) {
            cityName=@"";
        }
    }else if(indexPath.column==1){
        day=_timeArray[indexPath.row];
        if ([day isEqualToString:@"日期"]) {
            day=@"";
        }else if ([day isEqualToString:@"今天"]){
            day=@"0";
        }else if ([day isEqualToString:@"明天"]){
            day=@"1";
        }else{
            day=@"7";
        }
    }else if(indexPath.column==2){
        feeType=_priceArray[indexPath.row];
        if ([feeType isEqualToString:@"费用"]) {
            feeType=@"";
        }
    }
    [self activityHeaderFreshing];
}

-(void)activityHeaderFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [HttpActivityAction getActivityList:UserDefaultEntity.uuid cityName:cityName feeType:feeType day:day page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PActivityModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
            _userlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _funlist=[[NSMutableArray alloc]init];
            _userlist=[[NSMutableArray alloc]init];
            
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
            _userlist=[[NSMutableArray alloc]init];
            
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
        if ([_funlist count] > 0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self activityHeaderFreshing];
}

-(void)activityFooterFreshing{

    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        
        [HttpActivityAction getActivityList:UserDefaultEntity.uuid cityName:cityName feeType:feeType day:day page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PActivityModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]]];
                [_userlist addObjectsFromArray:[dict objectForKey:@"result"]];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"illegal"]) {

                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else{
               
                [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
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
    return 110*SCREEN_WSCALE;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PActivityModel *model=[_funlist objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%zi%zi",indexPath.section,indexPath.row];
    ActivityCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (cell == nil) {
        cell=[[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell updateData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PActivityModel *model=[_funlist objectAtIndex:indexPath.row];
    ActivityDetailVC *activityDetail=[[ActivityDetailVC alloc]init];
    activityDetail.guid=model.Guid;
    [self.navigationController pushViewController:activityDetail animated:YES];
}

-(void)sendBtn:(id)sender{
    SendActivityVC *sendActivity=[[SendActivityVC alloc]init];
    [self.navigationController pushViewController:sendActivity animated:YES];
}

@end
