//
//  PartPresonViewController.m
//  qch
//
//  Created by 苏宾 on 16/3/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PartPresonViewController.h"
#import "ProjectCell.h"
#import "QchpartnerVC.h"
#import "PersonInfomationVC.h"
#import "PartnerCell.h"
@interface PartPresonViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectCellDelegate>{
    NSInteger ifPraise;
    
    CGFloat height;
    
    NSString *IsInvestor;
}

@property (nonatomic,strong) NSMutableArray *partnerlist;

@end

@implementation PartPresonViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetIsInvestor];

    if (_partnerlist !=nil) {
        _partnerlist=[[NSMutableArray alloc]init];
    }
    
    if (![UserDefaultEntity.user_style isEqualToString:@"2"] && ![UserDefaultEntity.user_style isEqualToString:@"3"]) {
        height=40;
        [self createHeaderView];
    }else if ([UserDefaultEntity.user_style isEqualToString:@"2"]&&[IsInvestor isEqualToString:@"0"]){
        height=40;
        [self createHeaderView];
    }else{
        height=0;
    }
    
    [self createTableView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createHeaderView{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headView.backgroundColor=[UIColor themeGrayColor];
    [self.view addSubview:headView];
    
    UILabel *label=[self createLabelFrame:CGRectMake(10, 10, SCREEN_WIDTH-100, 20) color:[UIColor grayColor] font:Font(14) text:@"完善信息，成为合伙人，结识更多创业者"];
    [headView addSubview:label];
    
    UIButton *changeInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    changeInfo.frame=CGRectMake(SCREEN_WIDTH-90, label.top, 80, label.height);
    [changeInfo setTitle:@"成为合伙人" forState:UIControlStateNormal];
    [changeInfo setTitleColor:TSEColor(110, 151, 245) forState:UIControlStateNormal];
    changeInfo.titleLabel.font=Font(14);
    
    if (![UserDefaultEntity.user_style isEqualToString:@"2"] && ![UserDefaultEntity.user_style isEqualToString:@"3"]) {
        [changeInfo addTarget:self action:@selector(changeInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [changeInfo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    [headView addSubview:changeInfo];
}

-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT-64-44-height) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
    [self.view addSubview:self.tableView];
    
    [self cleanTableView:self.tableView];
    [self refeleshController];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    tableView.tableFooterView=view;
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)changeInfoBtn:(id)sender{
    if ([UserDefaultEntity.user_style isEqualToString:@"2"]&&[IsInvestor isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:@"您申请投资人正在审核中……" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        PersonInfomationVC *person = [[PersonInfomationVC alloc]init];
        person.hidesBottomBarWhenPushed = YES;
        person.title = @"合伙人认证";
        [self.navigationController pushViewController:person animated:YES];
    }
}

-(void)headerFreshing{

    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSString *city = @"";
    if ([_cityStr isEqualToString:@"全国"]) {
        _cityStr = city;
    }
    [HttpPartnerAction GetUserList2:@"3" userGuid:UserDefaultEntity.uuid best:_BestStr foucs:_FocsStr city:_cityStr key:@"" page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

-(void)footerFreshing{
    
    NSString *city = @"";
    if ([_cityStr isEqualToString:@"全国"]) {
        _cityStr = city;
    }
    if ([_partnerlist count]>0 && [_partnerlist count]% PAGESIZE ==0) {
            
        [HttpPartnerAction GetUserList2:@"3" userGuid:UserDefaultEntity.uuid best:_BestStr foucs:_FocsStr city:_cityStr key:@"" page:[_partnerlist count]/PAGESIZE + 1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userStyle"] complete:^(id result, NSError *error) {
            
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

//关注
-(void)updateCareBtn:(ProjectCell *)cell{
    
    PartnerResult *model = [_partnerlist objectAtIndex:cell.tag];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dict setObject:model.guid forKey:@"foucsUserGuid"];
    [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [HttpPartnerAction AddCareOrCancelPraise:dict complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            if (ifPraise==0) {
                ifPraise=1;
                [cell.careButton setImage:[UIImage imageNamed:@"p_cared"] forState:UIControlStateNormal];

                [self headerFreshing];
            }else{
                ifPraise=0;
                [cell.careButton setImage:[UIImage imageNamed:@"p_care"] forState:UIControlStateNormal];

                [self headerFreshing];
            }
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
        
        }
    }];
}
@end
