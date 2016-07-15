//
//  PartnerList.m
//  qch
//
//  Created by 青创汇 on 16/6/23.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartnerList.h"
#import "PartnerCell.h"
#import "NewPartnerSelectVC.h"
#import "QchpartnerVC.h"
#import "SearchViewController.h"
#import "PersonInfomationVC.h"
@interface PartnerList ()<QchCityViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSString *cityStr;
    NSString *bestStr;
    NSString *intentionStr;
    NSString *nowneedStr;
    
    UIView *promptView;
    UIButton *closeButton;
    UIImageView *becomeImage;
    UIImageView *searchImage;
    NSString *Key;
    NSString *IsInvestor;

}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *partnerlist;
@property (nonatomic,strong) NSMutableArray *cityList;
@property (nonatomic,strong) UIButton *selectCity;
@property (nonatomic,strong) NSMutableArray *typelist;


@end

@implementation PartnerList

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"best"]]) {
        bestStr = @"";
    }else{
        bestStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"best"];
    }
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"intetion"]]) {
        intentionStr = @"";
    }else{
        intentionStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"intetion"];
    }
    if ([self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"nowneed"]]) {
        nowneedStr = @"";
    }else{
        nowneedStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"nowneed"];
    }
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults] objectForKey:@"reflesh"]]) {
        [self refeleshController];
    }
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"best"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"intetion"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nowneed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reflesh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"合伙人";
    cityStr=@"";
    bestStr = @"";
    intentionStr=@"";
    nowneedStr =@"";
    Key = @"";
    if (_partnerlist!=nil) {
        _partnerlist=[[NSMutableArray alloc]init];
    }
    
    if (_cityList!=nil) {
        _cityList=[[NSMutableArray alloc]init];
    }
    
    if (_typelist!=nil) {
        _typelist=[[NSMutableArray alloc]init];
    }
    [self GetIsInvestor];
    [self getHotCity];
    [self createSelectView];
    [self createTableView];
    [self getPartnerType];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"parter_open"] style:UIBarButtonItemStylePlain target:self action:@selector(openAction)];
    // 添加观察者, 观察手动触发下拉刷新的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mjPullingAction) name:@"mjstatepulling" object:nil];
}
- (void)openAction {
    // 展开
    self.navigationItem.rightBarButtonItem = nil;
    UIWindow *myWindow = [[[UIApplication sharedApplication] delegate] window];
    promptView = [[UIView alloc] initWithFrame:myWindow.frame];
    promptView.backgroundColor = [UIColor blackColor];
    promptView.alpha = 0.7;
    [myWindow addSubview:promptView];
    closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(self.view.right - 47*PMBWIDTH, 15*PMBWIDTH, 40*PMBWIDTH, 40*PMBWIDTH);
    [closeButton setImage:[UIImage imageNamed:@"parter_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [myWindow addSubview:closeButton];
    becomeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 110*PMBWIDTH, closeButton.bottom+20*PMBWIDTH, 100*PMBWIDTH, 40)];
    becomeImage.image = [UIImage imageNamed:@"parter_became"];
    becomeImage.userInteractionEnabled = YES;
    becomeImage.tag = 1000;
    [becomeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [myWindow addSubview:becomeImage];
    searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 110*PMBWIDTH, becomeImage.bottom+10*PMBWIDTH, 100*PMBWIDTH, 40)];
    searchImage.image = [UIImage imageNamed:@"parter_search"];
    searchImage.userInteractionEnabled = YES;
    searchImage.tag = 1001;
    [searchImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [myWindow addSubview:searchImage];
    
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
- (void)closeAction {
    // 关闭
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"parter_open"] style:UIBarButtonItemStylePlain target:self action:@selector(openAction)];
    [promptView removeFromSuperview];
    [closeButton removeFromSuperview];
    [becomeImage removeFromSuperview];
    [searchImage removeFromSuperview];
}
- (void)tapAction:(UITapGestureRecognizer*)sender {
    if (sender.view.tag == 1000) {
        // 成为合伙人
        [self closeAction];
        if ([UserDefaultEntity.user_style isEqualToString:@"3"]) {
            [SVProgressHUD showErrorWithStatus:@"您已经是合伙人了" maskType:SVProgressHUDMaskTypeBlack];
        }else if ([UserDefaultEntity.user_style isEqualToString:@"2"]){
            if ([IsInvestor isEqualToString:@"0"]) {
                [SVProgressHUD showErrorWithStatus:@"您申请投资人正在审核中" maskType:SVProgressHUDMaskTypeBlack];
            }else if ([IsInvestor isEqualToString:@"1"]){
                [SVProgressHUD showErrorWithStatus:@"您已经是投资人了" maskType:SVProgressHUDMaskTypeBlack];
            }else if ([IsInvestor isEqualToString:@"2"]){
                PersonInfomationVC *person = [[PersonInfomationVC alloc]init];
                person.hidesBottomBarWhenPushed = YES;
                person.title = @"合伙人认证";
                [self.navigationController pushViewController:person animated:YES];
            }
        }else{
            PersonInfomationVC *person = [[PersonInfomationVC alloc]init];
            person.hidesBottomBarWhenPushed = YES;
            person.title = @"合伙人认证";
            [self.navigationController pushViewController:person animated:YES];
        }
        
    } else if (sender.view.tag == 1001) {
        // 查找合伙人
        [self closeAction];
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [searchVC returnString:^(NSString *SearchString) {
            Key = SearchString;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self refeleshController];
             });
        }];
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchVC animated:YES];

    }
}
- (void)mjPullingAction {
    
    bestStr = @"";
    intentionStr=@"";
    nowneedStr =@"";
    Key = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"best"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"intetion"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nowneed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reflesh"];
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

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)headerFreshing{
 
    NSString *city = @"";
    if ([cityStr isEqualToString:@"全国"]) {
        cityStr = city;
    }
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [HttpPartnerAction GetUserList3:@"3" userGuid:UserDefaultEntity.uuid best:bestStr foucs:@"" nowneed:nowneedStr intetion:intentionStr city:cityStr key:Key page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:dict];
            _partnerlist=(NSMutableArray*)rpnc.result;
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _partnerlist=[[NSMutableArray alloc]init];
            
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
            _partnerlist=[[NSMutableArray alloc]init];
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
        if ([_partnerlist count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}


-(void)footerFreshing{
    
    NSString *city = @"";
    if ([cityStr isEqualToString:@"全国"]) {
        cityStr = city;
    }
    
    if ([_partnerlist count]>0 && [_partnerlist count]% PAGESIZE ==0) {
        [HttpPartnerAction GetUserList3:@"3" userGuid:UserDefaultEntity.uuid best:bestStr foucs:@"" nowneed:nowneedStr intetion:intentionStr city:cityStr key:Key page:[_partnerlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
                RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:dict];
                [_partnerlist addObjectsFromArray:rpnc.result];
                [self.tableView reloadData];
            }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
                _partnerlist=[[NSMutableArray alloc]init];
                
            }else{
                _partnerlist=[[NSMutableArray alloc]init];
            }
            
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
    return [_partnerlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PartnerResult *model = [_partnerlist objectAtIndex:indexPath.row];
    
    PartnerCell *cell = (PartnerCell*)[tableView dequeueReusableCellWithIdentifier:@"PartnerCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PartnerCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[PartnerCell class]]) {
                cell = (PartnerCell *)oneObject;
            }
        }
    }
    [cell updataFrame:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PartnerResult *model = [_partnerlist objectAtIndex:indexPath.row];
    QchpartnerVC *partner = [[QchpartnerVC alloc]init];
    partner.hidesBottomBarWhenPushed = YES;
    partner.Guid=model.guid;
    [self.navigationController pushViewController:partner animated:YES];
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

-(void)selectCity:(id)sender{
    QchCityViewController *qchSelectCity=[[QchCityViewController alloc]init];
    qchSelectCity.cityDelegate=self;
    qchSelectCity.citylist=_cityList;
    [self.navigationController pushViewController:qchSelectCity animated:YES];
}

- (void)selectType:(id)sender{
    
    NewPartnerSelectVC *partner = [[NewPartnerSelectVC alloc]init];
    partner.typelist = _typelist;
    partner.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:partner animated:YES];
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

-(void)getPartnerType{
    
    [HttpPartnerAction getStyles:[MyAes aesSecretWith:@"Ids"] Byids:@"81,1362,1361" complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _typelist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else{
            _typelist=[[NSMutableArray alloc]init];
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mjstatepulling" object:nil];
}
@end
