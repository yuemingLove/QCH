//
//  RoomViewController.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomListCell.h"
#import "RoomMapViewController.h"
#import "RoomDetailVC.h"

@interface RoomViewController ()<UITableViewDataSource,UITableViewDelegate,QchCityViewControllerDelegate>{
    NSString *cityStr;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *citylist;

@property (nonatomic,strong) UILabel *cityLabel;

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"空间"];
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_citylist !=nil) {
        _citylist=[[NSMutableArray alloc]init];
    }
    [self createHeadView];
    [self createTableView];
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"changeMap"] style:UIBarButtonItemStyleDone target:self action:@selector(changeView:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    cityStr = UserDefaultEntity.city;
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
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHotCity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)getHotCity{
    [HttpLoginAction getHotCity:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _citylist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _citylist=[[NSMutableArray alloc]init];
        }
    }];
}

-(void)createHeadView{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor=[UIColor themeGrayColor];
    [self.view addSubview:headView];
    
    UILabel *label=[self createLabelFrame:CGRectMake(10, 10, 200, 20) color:[UIColor grayColor] font:Font(14) text:@"根据您的项目情况推荐创业空间"];
    [headView addSubview:label];
    
    UIButton *updateCity=[UIButton buttonWithType:UIButtonTypeCustom];
    updateCity.frame=CGRectMake(SCREEN_WIDTH-50, label.top, 40, label.height);
    [updateCity setTitle:@"更改" forState:UIControlStateNormal];
    [updateCity setTitleColor:[UIColor themeBlueColor] forState:UIControlStateNormal];
    updateCity.titleLabel.font=Font(14);
    [updateCity addTarget:self action:@selector(updateCity) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:updateCity];
    
    _cityLabel=[self createLabelFrame:CGRectMake(updateCity.left-60, label.top, 50, label.height) color:[UIColor blackColor] font:Font(16) text:UserDefaultEntity.city];
    _cityLabel.textAlignment=NSTextAlignmentRight;
    [headView addSubview:_cityLabel];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    
    [self.tableView.mj_header beginRefreshing];
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
    
    [HttpRoomAction GetPlace:UserDefaultEntity.uuid cityName:cityStr lat:[NSString stringWithFormat:@"%f",UserDefaultEntity.latitude] lng:[NSString stringWithFormat:@"%f",UserDefaultEntity.longitude] page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
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
        
        [HttpRoomAction GetPlace:UserDefaultEntity.uuid cityName:cityStr lat:[NSString stringWithFormat:@"%f",UserDefaultEntity.latitude] lng:[NSString stringWithFormat:@"%f",UserDefaultEntity.longitude] page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
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

-(void)changeView:(id)sender{
    
    RoomMapViewController *roomMapVC=[[RoomMapViewController alloc]init];
    
    roomMapVC.positionlist=_funlist;
    [self.navigationController pushViewController:roomMapVC animated:YES];
}

-(void)updateCity{

    QchCityViewController *qchSelectCity=[[QchCityViewController alloc]init];
    qchSelectCity.cityDelegate=self;
    qchSelectCity.citylist=_citylist;
    qchSelectCity.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qchSelectCity animated:YES];
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
    
    RoomListCell *cell = (RoomListCell*)[tableView dequeueReusableCellWithIdentifier:@"RoomListCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"RoomListCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[RoomListCell class]]) {
                cell = (RoomListCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    [cell updateFrame:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.row];
    RoomDetailVC *roomDetail=[[RoomDetailVC alloc]init];
    roomDetail.Guid=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:roomDetail animated:YES];
}

-(void)selectCityData:(NSString *)city{
    cityStr=city;
    _cityLabel.text=city;
    if ([city isEqualToString:@""]) {
        _cityLabel.text = @"全国";
        cityStr = @"";
    }
    [self.tableView.mj_header beginRefreshing];
}

@end
