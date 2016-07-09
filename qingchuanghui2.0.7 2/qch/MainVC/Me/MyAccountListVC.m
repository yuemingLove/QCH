//
//  MyAccountListVC.m
//  qch
//
//  Created by 苏宾 on 16/3/21.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyAccountListVC.h"
#import "MyAccountCell.h"
#import "AccountPayVC.h"

@interface MyAccountListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyAccountListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"账户明细"];
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"充值" style:UIBarButtonItemStyleDone target:self action:@selector(payOrder:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    [self createTableView];
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor themeGrayColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
    [self.view addSubview:_tableView];
    
    [self cleanTableView:self.tableView];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=view;
}

-(void)payOrder:(id)sender{
    
    AccountPayVC *accountPay=[[AccountPayVC alloc]init];
    [self.navigationController pushViewController:accountPay animated:YES];
}

-(void)headerRefreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    [HttpAlipayAction AccountList:UserDefaultEntity.uuid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [self headerRefreshing];
}
-(void)footerRefreshing{

    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        
        [HttpAlipayAction AccountList:UserDefaultEntity.uuid page:[_funlist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_funlist count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.section];
    
    MyAccountCell *cell = (MyAccountCell*)[tableView dequeueReusableCellWithIdentifier:@"MyAccountCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"MyAccountCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[MyAccountCell class]]) {
                cell = (MyAccountCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    cell.typeLabel.text=[dict objectForKey:@"t_Remark"];
    NSString *price=[dict objectForKey:@"t_UserAccount_AddReward"];
    if ([price isEqualToString:@"0.00"]||[self isBlankString:price]) {
        cell.priceLabel.text=[NSString stringWithFormat:@"-¥%@",[dict objectForKey:@"t_UserAccount_ReduceReward"]];
        cell.priceLabel.textColor=[UIColor colorWithRed:(53.0f / 255.0f) green:(95.0f / 255.0f) blue:(150.0f / 255.0f) alpha:1.0f];
    } else {
        cell.priceLabel.text=[NSString stringWithFormat:@"+¥%@",price];
        cell.priceLabel.textColor=[UIColor colorWithRed:(225.0f / 255.0f) green:(119.0f / 255.0f) blue:(62.0f / 255.0f) alpha:1.0f];
    }
    
    NSString *date=[dict objectForKey:@"t_AddDate"];
//    date=[date substringFromIndex:5];
//    date=[date substringToIndex:5];
    cell.timeLabel.text=date;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
