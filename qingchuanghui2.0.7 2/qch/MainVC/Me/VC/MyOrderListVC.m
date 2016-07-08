//
//  MyOrderListVC.m
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyOrderListVC.h"
#import "MyOrder.h"
#import "OrderCell.h"
#import "MyOrderFirstCell.h"
#import "MyOrderSecondCell.h"
#import "MyOrderThirdCell.h"
#import "MyOrderFourCell.h"
#import "OrderDetailVC.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "ActivityPayVCNew.h"
#import "ActivityPayVC.h"
#import "AppointRoomVC.h"
#import "CertificateDetailVC.h"

@interface MyOrderListVC ()<UITableViewDelegate,UITableViewDataSource>
{
NSString *type;
UIButton *TypeBtn;
NSString *applyGuid;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic, strong) NSDictionary *activityDic;
@end

@implementation MyOrderListVC

- (NSDictionary *)activityDic {
    if (_activityDic == nil) {
        self.activityDic = [NSDictionary dictionary];
    }
    return _activityDic;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self headerRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我的订单"];
    type = @"0";
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    // 筛选buttonItem
    TypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    TypeBtn.frame = CGRectMake(0, 0, 60, 32);
    [TypeBtn setTitle:@"全部" forState:UIControlStateNormal];
    TypeBtn.titleLabel.font = Font(16);
    TypeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [TypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
    [TypeBtn addTarget:self action:@selector(Filter:) forControlEvents:UIControlEventTouchUpInside];
    TypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    TypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, TypeBtn.titleLabel.width + 10, 0, -TypeBtn.width- 10);
    UIBarButtonItem *TypeBtnItem=[[UIBarButtonItem alloc] initWithCustomView:TypeBtn];
    self.navigationItem.rightBarButtonItem = TypeBtnItem;
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimiss:) name:@"dimiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activitysuccess:) name:@"activitysuccess" object:nil];
}
- (void)activitysuccess:(NSNotification *)text{
    [self freePayAction];
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"activitysuccess" object:nil];
}
-(void)freePayAction{
    NSString *guid = [self.activityDic[@"assoctiate"] firstObject][@"guid"];
    NSString *title = [self.activityDic[@"assoctiate"] firstObject][@"title"];
    [HttpActivityAction AddActivityApply:UserDefaultEntity.uuid activityGuid:guid applyName:@"" applyMobile:@"" applyReamrk:title Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic = [dict objectForKey:@"result"][0];
            applyGuid = [dic objectForKey:@"Guid"];

            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self fristAlertView];
            });
        } else if([[dict objectForKey:@"state"]isEqualToString:@"false"]) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
    
}
-(void)fristAlertView{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"报名成功" message:@"是否查看报名凭证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        CertificateDetailVC *certi = [[CertificateDetailVC alloc]init];
        certi.ApplyGuid = applyGuid;
        [self.navigationController pushViewController:certi animated:YES];
    }
}
- (NSArray *) titles {
    return @[@"全部",
             @"充值",
             @"活动",
             @"众筹课程",
             @"课程",
             @"空间",
             ];
}
- (NSArray *) images {
    return @[@"quanbu",
             @"order_recharge2",
             @"order_activity2",
             @"order_public_programs2",
             @"order_programs2",
             @"order_room2",
             ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor themeGrayColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
    
    [_tableView.mj_header beginRefreshing];
}

-(void)cleanTableView:(UITableView*)tableView{
    
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=view;
}

-(void)headerRefreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [HttpAlipayAction newOrderList:UserDefaultEntity.uuid type:type page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
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
    [self headerRefreshing];
}
-(void)footerRefreshing{
    
    if ([_funlist count] > 0 && [_funlist count] % PAGESIZE == 0) {
        
        [HttpAlipayAction newOrderList:UserDefaultEntity.uuid type:type page:_funlist.count/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
            
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
    return [_funlist count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.section];
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
    NSInteger orderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];
    if (orderType == 1) {
        // 充值
        if (state==0) {
            return 150;
        } else if (state==1) {
            return 90;
        }
    } else {
        if (state==0) {
            return 200;
        } else if (state==1) {
            return 140;
        }
    }
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.section];
    NSInteger state=[(NSNumber*)[dict objectForKey:@"t_Order_State"]integerValue];
    NSInteger orderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];

    if (orderType == 1) {
        // 充值
        if (state==0) {
            // 未支付
            MyOrderFourCell *cell = (MyOrderFourCell*)[tableView dequeueReusableCellWithIdentifier:@"fourthCell"];
            if (cell==nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyOrderFourCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[MyOrderFourCell class]]) {
                        cell = (MyOrderFourCell *)oneObject;
                    }
                }
            }
            cell.backgroundColor = [UIColor themeGrayColor];
            [cell updateDate:dict];
            [cell setOrderBlock:^{
                // 支付
                ActivityPayVCNew *payVC = [[ActivityPayVCNew alloc] init];
                payVC.orderNum = [dict objectForKey:@"t_Order_No"];
                payVC.price = [(NSNumber *)[dict objectForKey:@"t_Order_Money"] floatValue];
                payVC.titlestr  = [dict objectForKey:@"t_Order_Name"];
                [self.navigationController pushViewController:payVC animated:YES];
            }];
            return cell;

        } else if (state==1) {
            // 已支付
            MyOrderThirdCell *cell = (MyOrderThirdCell*)[tableView dequeueReusableCellWithIdentifier:@"thirdCell"];
            if (cell==nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyOrderThirdCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[MyOrderThirdCell class]]) {
                        cell = (MyOrderThirdCell *)oneObject;
                    }
                }
            }
            cell.backgroundColor = [UIColor themeGrayColor];
            [cell updateDate:dict];
            return cell;
        }
    } else {
        if (state==0) {
            // 课程未支付
            MyOrderSecondCell *cell = (MyOrderSecondCell*)[tableView dequeueReusableCellWithIdentifier:@"secondCell"];
            if (cell==nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyOrderSecondCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[MyOrderSecondCell class]]) {
                        cell = (MyOrderSecondCell *)oneObject;
                    }
                }
            }
            cell.backgroundColor = [UIColor themeGrayColor];
            [cell updateDate:dict];
            [cell setOrderBlock:^{
                // 支付
                if (orderType == 5) {
                    NSDictionary *temDic = [[dict objectForKey:@"assoctiate"] firstObject];
                    [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
                    [HttpRoomAction GetPlaceStyle:[temDic objectForKey:@"guid"] Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
                        [SVProgressHUD dismiss];
                        NSDictionary *roomdict = result[0];
                        if ([[roomdict objectForKey:@"state"] isEqualToString:@"true"]) {
                            AppointRoomVC *appointRoom=[[AppointRoomVC alloc]init];
                            appointRoom.Placelist= [NSMutableArray arrayWithArray:[roomdict objectForKey:@"result"]];
                            
                            [self.navigationController pushViewController:appointRoom animated:YES];
                        }else if ([[roomdict objectForKey:@"state"]isEqualToString:@"false"]){
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showErrorWithStatus:@"不好意思，暂时没有可以预约的空间" maskType:SVProgressHUDMaskTypeBlack];
                        }
                    }];

                }else if (orderType ==2){
                    self.activityDic = dict;
                    NSString *guid = [self.activityDic[@"assoctiate"] firstObject][@"guid"];
                    [HttpActivityAction IfApply:UserDefaultEntity.uuid activityGuid:guid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
                        NSDictionary *dic = result[0];
                        if ([[dic objectForKey:@"state"]isEqualToString:@"false"]) {
                            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                        }else if ([[dic objectForKey:@"state"]isEqualToString:@"illegal"]){
                            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                        }else{
                            ActivityPayVC *payVC = [[ActivityPayVC alloc] init];
                            payVC.orderNum = [dict objectForKey:@"t_Order_No"];
                            payVC.price = [(NSNumber *)[dict objectForKey:@"t_Order_Money"] floatValue];
                            payVC.titlestr  = [dict objectForKey:@"t_Order_Name"];
                            [self.navigationController pushViewController:payVC animated:YES];
                        }
                    }];
                }else {
                    ActivityPayVC *payVC = [[ActivityPayVC alloc] init];
                    payVC.orderNum = [dict objectForKey:@"t_Order_No"];
                    payVC.price = [(NSNumber *)[dict objectForKey:@"t_Order_Money"] floatValue];
                    payVC.titlestr  = [dict objectForKey:@"t_Order_Name"];
                    [self.navigationController pushViewController:payVC animated:YES];
                }
               
            }];
            return cell;
        } else if (state==1) {
            // 课程已支付
            MyOrderFirstCell *cell = (MyOrderFirstCell*)[tableView dequeueReusableCellWithIdentifier:@"firstCell"];
            if (cell==nil) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyOrderFirstCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[MyOrderFirstCell class]]) {
                        cell = (MyOrderFirstCell *)oneObject;
                    }
                }
            }
            cell.backgroundColor = [UIColor themeGrayColor];
            [cell updateDate:dict];
            return cell;
        }
    }
    return [UITableViewCell new];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.section];
    
    OrderDetailVC *orderDetail=[[OrderDetailVC alloc]init];
    orderDetail.Guid=[dict objectForKey:@"Guid"];

    NSInteger orderType=[(NSNumber*)[dict objectForKey:@"t_Order_OrderType"]integerValue];
    if (orderType==1) {// 充值
        orderDetail.orderType = 0;
    } else {// 其他
        orderDetail.orderType = 1;
    }
    
    [self.navigationController pushViewController:orderDetail animated:YES];
    
}

- (CGRect)menuFrame {
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width - 81;
    CGFloat menuY = -42;
    CGFloat width = 140;
    CGFloat heigh = 40 * 6;
    return (CGRect){menuX,menuY,width,heigh};
}

- (void)Filter:(id)sender
{
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao2"] forState:UIControlStateNormal];
    NSMutableArray *obj = [NSMutableArray array];
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }

    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:140 menuFrame:[self menuFrame]                                                              item:obj
        action:^(NSInteger index) {
           [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
           if (index==0) {
               [TypeBtn setTitle:@"全部" forState:UIControlStateNormal];
           }else if (index==1){
               [TypeBtn setTitle:@"充值" forState:UIControlStateNormal];
           }else if (index==2){
               [TypeBtn setTitle:@"活动" forState:UIControlStateNormal];
           } else if (index==3){
               [TypeBtn setTitle:@"众筹课程" forState:UIControlStateNormal];
           }else if (index==4){
               [TypeBtn setTitle:@"课程" forState:UIControlStateNormal];
           }else if (index==5){
               [TypeBtn setTitle:@"空间" forState:UIControlStateNormal];
           }
           type = [NSString stringWithFormat:@"%ld",(long)index];
            // 调整cityButton随内容自适应宽度
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
            CGFloat length = [[TypeBtn titleForState:UIControlStateNormal] boundingRectWithSize:CGSizeMake(100, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            TypeBtn.titleEdgeInsets = UIEdgeInsetsZero;
            TypeBtn.imageEdgeInsets = UIEdgeInsetsZero;
            TypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
            TypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, length + 15, 0, 0);
            
            [self headerRefreshing];
            
}];

}
-(void)dimiss:(NSNotification *)text{
    [TypeBtn setImage:[UIImage imageNamed:@"shanjiao1"] forState:UIControlStateNormal];
    /*
     *  移除通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpay" object:nil];
}

@end
