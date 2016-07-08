//
//  OrderDetailVC.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "OrderNewDetailVC.h"
#import "OrderImgCell.h"

@interface OrderNewDetailVC ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel *orderNumLabel;
    UILabel *statesLabel;
    
    UILabel *orderType;
    UILabel *orderPrice;
    UILabel *payWay;
    UILabel *orderTime;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *orderDict;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation OrderNewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"订单详情"];
    
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }

    [self createTableView];
    [self createHeadView];
    
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
            _funlist=[NSMutableArray arrayWithArray:[_orderDict objectForKey:@"strGood"]];
            orderNumLabel.text=[_orderDict objectForKey:@"t_Order_No"];
            
            NSInteger orderStatesInt=[(NSNumber*)[_orderDict objectForKey:@"t_Order_State"]integerValue];
            NSString *orderStatesStr;
            if (orderStatesInt==0) {
                orderStatesStr=@"未支付";
            } else {
                orderStatesStr=@"已支付";
            }
            
            statesLabel.text=orderStatesStr;
            
            NSInteger orderTypeInt=[(NSNumber*)[_orderDict objectForKey:@"t_Order_OrderType"]integerValue];
            NSString *orderTypeStr;
            if (orderTypeInt==1) {
                orderTypeStr=@"充值";
            }else if (orderTypeInt==2) {
                orderTypeStr=@"活动";
            }else if (orderTypeInt==3) {
                orderTypeStr=@"众筹课程";
            }else if (orderTypeInt==4) {
                orderTypeStr=@"课程";
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

    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180*SCREEN_WSCALE)];
    headView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=headView;
    
    orderNumLabel=[self createLabelFrame:CGRectMake(10, 10, SCREEN_WIDTH-120, 20) color:[UIColor themeBlueTwoColor] font:Font(14) text:@"213123313"];
    [headView addSubview:orderNumLabel];
    
    statesLabel=[self createLabelFrame:CGRectMake(orderNumLabel.right+10, orderNumLabel.top, 90, orderNumLabel.height) color:[UIColor blackColor] font:Font(14) text:@"未支付"];
    statesLabel.textAlignment=NSTextAlignmentRight;
    [headView addSubview:statesLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(5, orderNumLabel.bottom+10, SCREEN_WIDTH-10, 1)];
    line.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line];
    
    UILabel *orderTypeLabel=[self createLabelFrame:CGRectMake(orderNumLabel.left, line.bottom+10, 80, orderNumLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"订单类型:"];
    [headView addSubview:orderTypeLabel];
    
    orderType=[self createLabelFrame:CGRectMake(orderTypeLabel.right+10, orderTypeLabel.top, SCREEN_WIDTH-110, orderTypeLabel.height) color:[UIColor blackColor] font:Font(14) text:@""];
    [headView addSubview:orderType];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(5, orderTypeLabel.bottom+10, SCREEN_WIDTH-10, 1)];
    line1.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line1];
    
    UILabel *orderPriceLabel=[self createLabelFrame:CGRectMake(orderNumLabel.left, line1.bottom+10, 80, orderNumLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"订单金额:"];
    [headView addSubview:orderPriceLabel];
    
    orderPrice=[self createLabelFrame:CGRectMake(orderPriceLabel.right+10, orderPriceLabel.top, SCREEN_WIDTH-110, orderPriceLabel.height) color:[UIColor redColor] font:Font(14) text:@"¥120.00"];
    [headView addSubview:orderPrice];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(5, orderPriceLabel.bottom+10, SCREEN_WIDTH-10, 1)];
    line2.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line2];
    
    UILabel *payWayLabel=[self createLabelFrame:CGRectMake(orderNumLabel.left, line2.bottom+10, 80, orderNumLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"支付方式:"];
    [headView addSubview:payWayLabel];
    
    payWay=[self createLabelFrame:CGRectMake(payWayLabel.right+10, payWayLabel.top, SCREEN_WIDTH-110, payWayLabel.height) color:[UIColor redColor] font:Font(14) text:@"微信支付"];
    [headView addSubview:payWay];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(5, payWayLabel.bottom+10, SCREEN_WIDTH-10, 1)];
    line3.backgroundColor=[UIColor themeGrayColor];
    [headView addSubview:line3];
    
    UILabel *orderTimeLabel=[self createLabelFrame:CGRectMake(orderNumLabel.left, line3.bottom+10, 80, orderNumLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"订单时间:"];
    [headView addSubview:orderTimeLabel];
    
    orderTime=[self createLabelFrame:CGRectMake(orderTimeLabel.right+10, orderTimeLabel.top, SCREEN_WIDTH-110, orderTimeLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"2014-10-10 12:12:12"];
    [headView addSubview:orderTime];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [self cleanTableView:_tableView];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

@end
