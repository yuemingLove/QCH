//
//  OrderDetailVC.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "OrderDetailVC.h"
#import "OrderImgCell.h"
#import "ActivityPayVCNew.h"
#import "ActivityPayVC.h"
#import "ActivityDetailVC.h"
#import "RoomDetailVC.h"
#import "CrowdDetailsVC.h"
#import "CourseViewVC.h"
#import "AppointRoomVC.h"
@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *orderNumLabel;
    UILabel *statesLabel;
    UIButton *orderButton;
    UILabel *orderType;
    UILabel *orderPrice;
    UILabel *payWay;
    UILabel *orderTime;
    UIImageView *publicProgramsImage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *orderDict;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"订单详情"];

    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }

    [self createTableView];
    [self createHeadView];
    [self createFootView];

    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getData{

    [HttpAlipayAction OrderView:_Guid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _orderDict=[dict objectForKey:@"result"][0];
            _funlist=[NSMutableArray arrayWithArray:[_orderDict objectForKey:@"assoctiate"]];
            orderNumLabel.text=[_orderDict objectForKey:@"t_Order_No"];
            
            NSInteger orderStatesInt=[(NSNumber*)[_orderDict objectForKey:@"t_Order_State"]integerValue];
            NSString *orderStatesStr;
            if (orderStatesInt==0) {
                orderStatesStr=@"未支付";
                orderButton.hidden = NO;
            } else {
                orderStatesStr=@"已支付";
                
                orderButton.hidden = YES;
            }
            
            statesLabel.text=orderStatesStr;
            
            NSInteger orderTypeInt=[(NSNumber*)[_orderDict objectForKey:@"t_Order_OrderType"]integerValue];
            NSString *orderTypeStr;
            if (orderTypeInt==1) {
                orderTypeStr=@"充值";
                publicProgramsImage.image = [UIImage imageNamed:@"order_recharge"];
            }else if (orderTypeInt==2) {
                orderTypeStr=@"活动";
                publicProgramsImage.image = [UIImage imageNamed:@"order_activity"];
            }else if (orderTypeInt==3) {
                orderTypeStr=@"众筹课程";
                publicProgramsImage.image = [UIImage imageNamed:@"order_public_programs"];
            }else if (orderTypeInt==4) {
                orderTypeStr=@"课程";
                publicProgramsImage.image = [UIImage imageNamed:@"order_programs"];
            }else if (orderTypeInt==5){
                orderTypeStr = @"空间";
                 publicProgramsImage.image = [UIImage imageNamed:@"order_room"];
            }
            orderType.text=orderTypeStr;
            orderPrice.text=[NSString stringWithFormat:@"¥%@",[_orderDict objectForKey:@"t_Order_Money"]];
            payWay.text=[_orderDict objectForKey:@"t_Order_PayType"];
            orderTime.text=[_orderDict objectForKey:@"t_Order_Date"];
            
        } else {
            _orderDict=[[NSDictionary alloc]init];
            _funlist=[[NSMutableArray alloc]init];
        }
        [self.tableView reloadData];
    }];
}

-(void)createHeadView{

    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor=[UIColor themeGrayColor];
    self.tableView.tableHeaderView=headView;
    publicProgramsImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    [headView addSubview:publicProgramsImage];
    publicProgramsImage.image = [UIImage imageNamed:@"order_recharge"];
    orderType = [self createLabelFrame:CGRectMake(publicProgramsImage.right+5, 5, 120, 20) color:[UIColor themeBlueColor] font:Font(15) text:@"众筹课程"];
    [headView addSubview:orderType];
}
- (void)createFootView {
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 178*SCREEN_WSCALE)];
    footView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableFooterView=footView;
    UILabel *orderPriceLabel=[self createLabelFrame:CGRectMake(10, 10, 60, 21) color:[UIColor lightGrayColor] font:Font(14) text:@"订单金额:"];
    [footView addSubview:orderPriceLabel];
    
    orderPrice=[self createLabelFrame:CGRectMake(orderPriceLabel.right + 10, orderPriceLabel.top, SCREEN_WIDTH-110, orderPriceLabel.height) color:[UIColor themeBlueColor] font:Font(14) text:@"¥120.00"];
    [footView addSubview:orderPrice];
    
    UILabel *orderstatesLabel=[self createLabelFrame:CGRectMake(10, orderPriceLabel.bottom + 5, 60, 21) color:[UIColor lightGrayColor] font:Font(14) text:@"订单状态:"];
    [footView addSubview:orderstatesLabel];
    statesLabel=[self createLabelFrame:CGRectMake(orderstatesLabel.right+10, orderstatesLabel.top, 90, orderstatesLabel.height) color:[UIColor blackColor] font:Font(14) text:@"未支付"];
    [footView addSubview:statesLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, statesLabel.bottom+10, SCREEN_WIDTH, 10)];
    line.backgroundColor=[UIColor themeGrayColor];
    [footView addSubview:line];
    UILabel *orderNumber=[self createLabelFrame:CGRectMake(10, line.bottom+10, 60, 21) color:[UIColor lightGrayColor] font:Font(14) text:@"订单编号:"];
    [footView addSubview:orderNumber];
    
    orderNumLabel=[self createLabelFrame:CGRectMake(orderNumber.right+10, orderNumber.top, SCREEN_WIDTH-110, orderNumber.height) color:[UIColor themeBlueColor] font:Font(14) text:@"213123313"];
    [footView addSubview:orderNumLabel];
    
    UILabel *orderDate=[self createLabelFrame:CGRectMake(10, orderNumber.bottom + 5, 60, 21) color:[UIColor lightGrayColor] font:Font(14) text:@"订单时间:"];
    [footView addSubview:orderDate];
    orderTime=[self createLabelFrame:CGRectMake(orderDate.right+10, orderDate.top, SCREEN_WIDTH-110, orderDate.height) color:[UIColor themeBlueColor] font:Font(14) text:@"201606111111"];
    [footView addSubview:orderTime];
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(10, orderTime.bottom + 10, SCREEN_WIDTH - 20, 1)];
    line1.backgroundColor=[UIColor themeGrayColor];
    [footView addSubview:line1];
    orderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    orderButton.frame = CGRectMake(ScreenWidth * 0.33, line1.bottom + 15, ScreenWidth * 0.34, 33.5);
    [orderButton setTitle:@"去支付" forState:UIControlStateNormal];
    [orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderButton.backgroundColor = [UIColor themeBlueThreeColor];
    orderButton.layer.cornerRadius = orderButton.height / 2;
    orderButton.layer.masksToBounds = YES;
    [orderButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:orderButton];
}
- (void)payAction:(UIButton *)sender {
    // 去支付
    if (self.orderType == 0) {
        // 充值
        ActivityPayVCNew *payVC = [[ActivityPayVCNew alloc] init];
        payVC.orderNum = [_orderDict objectForKey:@"t_Order_No"];
        payVC.price = [(NSNumber *)[_orderDict objectForKey:@"t_Order_Money"] floatValue];
        payVC.titlestr  = [_orderDict objectForKey:@"t_Order_Name"];
        [self.navigationController pushViewController:payVC animated:YES];
    } else {
        // 其他
        if ([[_orderDict objectForKey:@"t_Order_OrderType"]isEqualToString:@"5"]) {
            NSDictionary *temDic = [[_orderDict objectForKey:@"assoctiate"] firstObject];
            [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
            [HttpRoomAction GetPlaceStyle:[temDic objectForKey:@"guid"] Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
                
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
                NSDictionary *roomdict = result[0];
                if ([[roomdict objectForKey:@"state"] isEqualToString:@"true"]) {
                    AppointRoomVC *appointRoom=[[AppointRoomVC alloc]init];
                    appointRoom.Placelist= [NSMutableArray arrayWithArray:[roomdict objectForKey:@"result"]];
                    
                    [self.navigationController pushViewController:appointRoom animated:YES];
                }else if ([[roomdict objectForKey:@"state"]isEqualToString:@"false"]){
                    
                    [SVProgressHUD showErrorWithStatus:@"不好意思，暂时没有可以预约的空间" maskType:SVProgressHUDMaskTypeBlack];
                }
            }];
        }else{
            ActivityPayVC *payVC = [[ActivityPayVC alloc] init];
            payVC.orderNum = [_orderDict objectForKey:@"t_Order_No"];
            payVC.price = [(NSNumber *)[_orderDict objectForKey:@"t_Order_Money"] floatValue];
            payVC.titlestr  = [_orderDict objectForKey:@"t_Order_Name"];
            [self.navigationController pushViewController:payVC animated:YES];
        }
    }
    
}
-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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
    
    OrderImgCell *cell = (OrderImgCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderImgCell"];
    if (cell == nil) {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"OrderImgCell" owner:self options:nil];
        for (id oneObject in nibs) {
            if ([oneObject isKindOfClass:[OrderImgCell class]]) {
                cell = (OrderImgCell *)oneObject;
            }
        }
    }
    cell.tag = indexPath.row;
    
    [cell updateDate:dict];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转到课程详情
    
    NSInteger orderTypeInt=[(NSNumber*)[_orderDict objectForKey:@"t_Order_OrderType"]integerValue];
    NSArray *array = [_orderDict objectForKey:@"assoctiate"];
    NSDictionary *dict = [array objectAtIndex:0];
    NSString *guid = [dict objectForKey:@"guid"];
    NSString *orderTypeStr;
    if (orderTypeInt==1) {
        
    }else if (orderTypeInt==2) {
        orderTypeStr=@"活动";
        ActivityDetailVC *activity = [[ActivityDetailVC alloc]init];
        activity.hidesBottomBarWhenPushed = YES;
        activity.guid = guid;
        [self.navigationController pushViewController:activity animated:YES];
    }else if (orderTypeInt==3) {
        orderTypeStr=@"众筹课程";
        CrowdDetailsVC *crow = [[CrowdDetailsVC alloc]init];
        crow.hidesBottomBarWhenPushed = YES;
        crow.guid = guid;
        [self.navigationController pushViewController:crow animated:YES];
    }else if (orderTypeInt==4) {
        orderTypeStr=@"课程";
        CourseViewVC *course = [[CourseViewVC alloc]init];
        course.hidesBottomBarWhenPushed =YES;
        course.guid = guid;
        [self.navigationController pushViewController:course animated:YES];
    }else if (orderTypeInt==5){
        orderTypeStr=@"空间";
        [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
        [HttpRoomAction GetPlaceStyle:guid Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
            NSDictionary *roomdict = result[0];
            if ([[roomdict objectForKey:@"state"] isEqualToString:@"true"]) {
                AppointRoomVC *appointRoom=[[AppointRoomVC alloc]init];
                appointRoom.Placelist= [NSMutableArray arrayWithArray:[roomdict objectForKey:@"result"]];
                [self.navigationController pushViewController:appointRoom animated:YES];
            }else if ([[roomdict objectForKey:@"state"]isEqualToString:@"false"]){
                
                [SVProgressHUD showErrorWithStatus:@"不好意思，暂时没有可以预约的空间" maskType:SVProgressHUDMaskTypeBlack];
            }
        }];

    }

    
}
@end
