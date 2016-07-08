//
//  PoineerConsultVC.m
//  qch
//
//  Created by 苏宾 on 16/1/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PoineerConsultVC.h"
#import "PConsultCell.h"
#import "PConsultModel.h"

@interface PoineerConsultVC ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    NSString *style;
    NSString *province;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@property (nonatomic,strong) NSMutableArray *typelist;
@property (nonatomic,strong) NSArray *typeArray;
@property (nonatomic,strong) NSArray *provincelist;

@end

@implementation PoineerConsultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"创业资讯"];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_typelist !=nil) {
        _typelist=[[NSMutableArray alloc]init];
    }
    
    style=@"";
    province=@"";
    
    _provincelist=@[@"全国",@"北京",@"上海",@"广州",@"深圳",@"天津",@"河南",@"湖南",@"河北",@"山西",@"辽宁",@"吉林",@"黑龙江",@"江苏",@"浙江",@"安徽",@"福建",@"江西",@"山东",@"湖北",@"广东",@"广西",@"海南",@"重庆",@"四川",@"贵州",@"云南",@"西藏",@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",@"香港",@"澳门",@"台湾"];
    
    [self getSelectData];
    [self createTableView];
    [self setExtraCellLineHidden:_tableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(consultHeaderFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(consultFooterFreshing)];

    [self.view addSubview:_tableView];
}

-(void)getSelectData{
    //type=39  类型
    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:39 complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSMutableArray *items=[[NSMutableArray alloc]init];
            
            _typelist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            [items addObject:@"全部"];
            for (NSDictionary *item in _typelist) {
                NSString *typeName=[item objectForKey:@"t_Style_Name"];
                [items addObject:typeName];
            }
            _typeArray=[items copy];
        }else if([[dict objectForKey:@"state"] isEqualToString:@"illegal"]){
         
            _typelist=[[NSMutableArray alloc]init];
        }
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
        
        menu.delegate = self;
        menu.dataSource = self;
        [self.view addSubview:menu];
    }];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    if (column == 0) {
        return _typeArray.count;
    }else{
        return self.provincelist.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        return self.typeArray[indexPath.row];
    } else{
        return self.provincelist[indexPath.row];
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.column == 0) {
        style=[_typeArray objectAtIndex:indexPath.row];
        if ([style isEqualToString:@"全部"]) {
            style=@"";
        }else{
            NSDictionary *dict=[_typelist objectAtIndex:indexPath.row-1];
            style=[dict objectForKey:@"Id"];
        }
    }else if(indexPath.column==1){
        province=[_provincelist objectAtIndex:indexPath.row];
        if ([province isEqualToString:@"全国"]) {
            province=@"";
        }
    }
    
    [self consultHeaderFreshing];
}


-(void)consultHeaderFreshing{
    
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpDiscoverAction GetNewsList:PAGE pagesize:PAGESIZE style:style province:province Token:[MyAes aesSecretWith:@"page"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PConsultModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]];
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
    [self consultHeaderFreshing];
}

-(void)consultFooterFreshing{

    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        
        [HttpDiscoverAction GetNewsList:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE style:style province:province Token:[MyAes aesSecretWith:@"page"] complete:^(id result, NSError *error) {
            
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[[NSMutableArray alloc]initWithArray: [RMMapper arrayOfClass:[PConsultModel class] fromArrayOfDictionary:[dict objectForKey:@"result"]]]];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
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
    
    PConsultModel *dict=[_funlist objectAtIndex:indexPath.row];
    
    PConsultCell *cell = (PConsultCell*)[tableView dequeueReusableCellWithIdentifier:@"PConsultCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"PConsultCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[PConsultCell class]]) {
                cell = (PConsultCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,dict.t_News_Pic];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:path]placeholderImage:[UIImage imageNamed:@"loading_2"]];
    [cell.pImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    cell.pImageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.pImageView.clipsToBounds  = YES;
    cell.titleLabel.text=dict.t_News_Title;
    cell.timeLabel.text=dict.t_News_Date;
    cell.typeLabel.text=dict.t_Style_Name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PConsultModel *dict=[_funlist objectAtIndex:indexPath.row];
    QCHWebViewController *qchWeb=[[QCHWebViewController alloc]init];
    qchWeb.theme=@"创业资讯详情";
    qchWeb.model = dict;
    qchWeb.type=2;
    qchWeb.sharebtn = @"1";
    qchWeb.url=[NSString stringWithFormat:@"%@NewsView.html?Guid=%@",SERIVE_HTML,dict.Guid];
    [self.navigationController pushViewController:qchWeb animated:YES];
}

@end
