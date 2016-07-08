//
//  DeductionVC2.m
//  qch
//
//  Created by W.兵 on 16/7/6.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DeductionVC2.h"
#import "DeductionCell.h"
#import "MyCouponVC.h"

@interface DeductionVC2 ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation DeductionVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择代金券";
    self.view.backgroundColor = [UIColor themeGrayColor];
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    [self createTableView];
}

- (void)butAction {
    if (self.couponBlock) {
        self.couponBlock(nil, nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)createTableView{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(10,10, SCREEN_WIDTH - 30, 35);
    but.layer.cornerRadius = but.height/2;
    but.layer.masksToBounds = YES;
    but.backgroundColor = [UIColor whiteColor];
    but.layer.borderColor = TSEColor(110, 151, 245).CGColor;
    but.layer.borderWidth = 0.6;
    [but setTitle:@"不使用代金券" forState:UIControlStateNormal];
    but.titleLabel.textAlignment = NSTextAlignmentCenter;
    [but setTitleColor:TSEColor(110, 151, 245) forState:UIControlStateNormal];
    [but addTarget:self action:@selector(butAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,55, SCREEN_WIDTH, SCREEN_HEIGHT-55) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    _tableView.backgroundColor = [UIColor themeGrayColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:_tableView];
    [self refeleshController];
    
}

-(void)refeleshController{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)headerFreshing{
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    [HttpCenterAction GetMyVoucher:UserDefaultEntity.uuid type:@"1" page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"result"]];
        }else if([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _funlist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.tableView.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"new_copon_no"]];
            [emptyView addSubview:empty];
            self.tableView.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            
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
-(void)footerFreshing{
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        [HttpCenterAction GetMyVoucher:UserDefaultEntity.uuid type:@"1" page:[_funlist count]/PAGESIZE +1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                [_funlist addObjectsFromArray:[dict objectForKey:@"result"]];
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"illegal"]) {
                
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


- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_funlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    DeductionCell *cell = (DeductionCell*)[tableView dequeueReusableCellWithIdentifier:@"DeductionCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DeductionCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[DeductionCell class]]) {
                cell = (DeductionCell *)oneObject;
                
            }
        }
    }
    if ([self.index isEqual:indexPath]) {
        cell.selsectImage.hidden = NO;
    }
    [cell updateData:dict];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index) {
        DeductionCell *cell = [self.tableView cellForRowAtIndexPath:self.index];
        cell.selsectImage.hidden = YES;
    }
    DeductionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selsectImage.hidden = NO;
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    if (self.couponBlock && [[dict objectForKey:@"isvalid"]isEqualToString:@"0"] && [[dict objectForKey:@"T_Voucher_State"]isEqualToString:@"0"]) {
        self.couponBlock(dict, indexPath);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.couponBlock) {
            self.couponBlock(nil, indexPath);
        }
    }
    self.index = indexPath;
}


@end
