//
//  AppointRoomVC.m
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AppointRoomVC.h"
#import "ProjectDetailCell.h"
#import "SelectTimeVC.h"
#import "TextEntity.h"
#import "TextShowCell.h"
#import "ActivityPayVCN.h"

@interface AppointRoomVC ()<UITableViewDataSource,UITableViewDelegate,SelectTimeVCDeleagte>{
    UIImageView *bImageView;
    TextEntity *entity;
    
    NSInteger ind;
    UIView *footerView;
    UIView *typeView;
    UILabel *typeLabel;
    UIButton *selectTime;
    UILabel *Pricelab;
    NSString *guid;
    NSString *t_Place_StyleName;
    NSString *price;
    NSString *associateGuid;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *datelist;

@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View

@property (strong, nonatomic) NSArray *adsArray;


@end

@implementation AppointRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"预约场地"];

    ind=0;
    
    [self createTableView];
    [self createFooterView];
    
    if (_datelist!=nil) {
        _datelist=[[NSMutableArray alloc]init];
    }
    
    [self createHeadView];
    [self createFootView];
    [self updateFrame:ind];
    [self creatimgview];
    
}

- (void)creatimgview{
    UIImageView *logoimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60*PMBWIDTH, 60*PMBWIDTH)];
    logoimg.layer.cornerRadius = logoimg.height/2;
    logoimg.center = CGPointMake(ScreenWidth/2, 160*PMBWIDTH);
    logoimg.image = [UIImage imageNamed:@"logo"];
    [_tableView addSubview:logoimg];
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor themeGrayColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


-(void)createHeadView{
    [self creatimgview];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    _tableView.tableHeaderView=headView;
    
    {
        __weak AppointRoomVC *weakSelf=self;
        self.adsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160.0*SCREEN_WSCALE ) animationDuration:3];
        
        [_adsView setFetchContentViewAtIndex:^UIView *(NSInteger pageIndex){
            if (pageIndex < [weakSelf.adsArray count]) {
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  160.0 * PMBWIDTH)];
                NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,weakSelf.adsArray[pageIndex]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
                
                [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                imageView.contentMode =  UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds  = YES;
                
                return imageView;
                
            }
            return [[UIView alloc] initWithFrame:CGRectZero];
        }];
        [headView addSubview:_adsView];
    }
    
}

-(void)createFootView{
    
    footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300*SCREEN_WSCALE)];
    footerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableFooterView=footerView;
    
    
    NSInteger count=[_Placelist count];
    typeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (count/3 +1)*40*PMBWIDTH+30*PMBWIDTH)];
    [footerView addSubview:typeView];
    
    typeLabel=[self createLabelFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"场地类型"];
    [typeView addSubview:typeLabel];
    
    CGFloat width=(SCREEN_WIDTH-80*SCREEN_WSCALE)/3;
    
    for (int i=0; i<[_Placelist count]; i++) {
        NSDictionary *dict = [_Placelist objectAtIndex:i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), typeLabel.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
        [button setTitle:[dict objectForKey:@"t_Place_StyleName"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0) {
            button.backgroundColor=[UIColor btnBgkGaryColor];
            button.layer.borderWidth=0;
        } else {
            button.layer.borderColor=[UIColor grayColor].CGColor;
            button.layer.borderWidth=0.6;
        }
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
               button.tag=i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [typeView addSubview:button];
    }

    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(typeLabel.left, typeView.bottom+10*PMBWIDTH, SCREEN_WIDTH, 1*PMBWIDTH)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [footerView addSubview:line];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, line.bottom+10*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 30*PMBWIDTH)];
    bgView.backgroundColor=[UIColor themeGrayColor];
    bgView.layer.masksToBounds=YES;
    bgView.layer.cornerRadius=bgView.height/2;
    [footerView addSubview:bgView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 5*PMBWIDTH, 20*PMBWIDTH, 20*PMBWIDTH)];
    [imageView setImage:[UIImage imageNamed:@"yysj"]];
    [bgView addSubview:imageView];
    
    UILabel *yuyueLabel=[self createLabelFrame:CGRectMake(imageView.bottom+10*PMBWIDTH, 5*PMBWIDTH, 100*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"预约时间"];
    [bgView addSubview:yuyueLabel];
    
    UIImageView *nextImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40*PMBWIDTH, yuyueLabel.top+1*PMBWIDTH, 10*PMBWIDTH, 18*PMBWIDTH)];
    nextImgeView.image = [UIImage imageNamed:@"next"];
    [bgView addSubview:nextImgeView];
    
    selectTime=[UIButton buttonWithType:UIButtonTypeCustom];
    selectTime.frame=CGRectMake(0, yuyueLabel.top, bgView.width, yuyueLabel.height);
    [selectTime setTitle:@"请选择预约时间" forState:UIControlStateNormal];
    selectTime.titleEdgeInsets = UIEdgeInsetsMake(0, 140*PMBWIDTH, 0, 10*PMBWIDTH);
    selectTime.titleLabel.font=Font(14);
    [selectTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectTime addTarget:self action:@selector(selectTimeType:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectTime];
    
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, bgView.bottom+10*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 30*PMBWIDTH)];
    footview.backgroundColor=[UIColor themeGrayColor];
    footview.layer.masksToBounds=YES;
    footview.layer.cornerRadius=bgView.height/2;
    [footerView addSubview:footview];
    
    UIImageView *moneyimg=[[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 5*PMBWIDTH, 20*PMBWIDTH, 20*PMBWIDTH)];
    [moneyimg setImage:[UIImage imageNamed:@"price_vc"]];
    [footview addSubview:moneyimg];
    
    UILabel *moneylab=[self createLabelFrame:CGRectMake(moneyimg.bottom+10*PMBWIDTH, 5*PMBWIDTH, 100*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"价格"];
    [footview addSubview:moneylab];
    
    Pricelab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-150*PMBWIDTH, moneylab.top+3*PMBWIDTH, 80*PMBWIDTH, 14*PMBWIDTH)];
    Pricelab.textAlignment = NSTextAlignmentRight;
    Pricelab.textColor = [UIColor lightGrayColor];
    Pricelab.font = Font(14);
    [footview addSubview:Pricelab];
    [_tableView reloadData];
}

-(void)createFooterView{
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, SCREEN_WIDTH, 49)];
    footView.backgroundColor=[UIColor themeBlueThreeColor];
    [self.view addSubview:footView];
    
    UIButton *appinotBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 30)];
    [appinotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appinotBtn setTitle:@"预约" forState:UIControlStateNormal];
    
    [appinotBtn addTarget:self action:@selector(appiontView:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:appinotBtn];
}

-(void)selectType:(UIButton*)sender{
    
    [typeView removeFromSuperview];
    [self createHeadView];
    guid=@"";
    [selectTime setTitle:@"请选择预约时间" forState:UIControlStateNormal];
    
    CGFloat width=(SCREEN_WIDTH-80*SCREEN_WSCALE)/3;
    UIButton *button=(UIButton*)sender;
    
    NSInteger count=[_Placelist count];
    typeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (count/3 +1)*40*PMBWIDTH+30*PMBWIDTH)];
    typeView.backgroundColor=[UIColor whiteColor];
    [footerView addSubview:typeView];
    
    typeLabel=[self createLabelFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, SCREEN_WIDTH-20*PMBWIDTH, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"场地类型"];
    [typeView addSubview:typeLabel];

    ind=[button tag];

    [self updateFrame:ind];
    
    for (int i=0; i<count; i++) {
        
        NSDictionary *dict=[_Placelist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), typeLabel.bottom+10*PMBWIDTH+(i/3)*40*PMBWIDTH, width, 30*PMBWIDTH);
        [button setTitle:[dict objectForKey:@"t_Place_StyleName"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.backgroundColor=[UIColor whiteColor];
        button.tag=i;
        
        if (ind==i) {
            [button setSelected:YES];
            button.backgroundColor=[UIColor btnBgkGaryColor];
            button.layer.borderColor=[UIColor whiteColor].CGColor;
        }
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [typeView addSubview:button];
    }
}

-(void)updateFrame:(NSInteger)index{

    NSDictionary *dict=[_Placelist objectAtIndex:index];

    if ([self isBlankString:[dict objectForKey:@"t_Place_Money"]]) {
        Pricelab.text = @"¥0.00";
        price = @"0.00";
    } else {
        Pricelab.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"t_Place_Money"]];
        price = [dict objectForKey:@"t_Place_Money"];
    }
    associateGuid = [dict objectForKey:@"Guid"];
    t_Place_StyleName = [dict objectForKey:@"t_Place_StyleName"];
    NSMutableArray *array=(NSMutableArray *)[dict objectForKey:@"Pic"];
    NSMutableArray *picArray=[[NSMutableArray alloc]init];
    for (NSDictionary *pic in array) {
        NSString *picStr=[pic objectForKey:@"t_Pic_Url"];
        [picArray addObject:picStr];
    }
    self.adsArray=[picArray copy];
    [_adsView setTotalPagesCount:^NSInteger{
        return [picArray count];
    }];
    
    entity=[TextEntity new];
    entity.isShowMoreText=NO;
    entity.textId=1;
    entity.textName=@"场地详情";
    entity.textContent=[[dict objectForKey:@"t_Place_Instruction"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
    
    [HttpRoomAction GetPlaceOrderDateTime:[dict objectForKey:@"Guid"] Token:[MyAes aesSecretWith:@"placeStyleGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            _datelist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _datelist=[[NSMutableArray alloc]init];
            
        }else{
            _datelist=[[NSMutableArray alloc]init];
        }
    }];
   
    
    [self.tableView reloadData];
}

-(void)selectTimeType:(id)sender{
    
    if ([_datelist count]>0) {
        SelectTimeVC *selecttime=[[SelectTimeVC alloc]init];
        //selecttime.timeDelegate=self;
        selecttime.datelist=_datelist;
        [selecttime setDateBlock:^(NSString * Guid, NSInteger index) {
            guid  = Guid;
            NSDictionary *dict=[_datelist objectAtIndex:index];
            NSMutableArray *array=(NSMutableArray*)[dict objectForKey:@"Times"];
            NSString *time;
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"Guid"] isEqualToString:Guid]) {
                    time=[NSString stringWithFormat:@"%@:00--%@:00",[dict objectForKey:@"t_PlaceOder_sTime"],[dict objectForKey:@"t_PlaceOder_eTime"]];
                }
            }
            [selectTime setTitle:[NSString stringWithFormat:@"%@   %@",[dict objectForKey:@"t_Order_Date"],time] forState:UIControlStateNormal];
        }];
        [self.navigationController pushViewController:selecttime animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"该场地没有推出使用，请耐心等待" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)selectDate:(NSString *)Guid index:(NSInteger)index {
    guid=Guid;
    NSDictionary *dict=[_datelist objectAtIndex:index];
    NSMutableArray *array=(NSMutableArray*)[dict objectForKey:@"Times"];
    NSString *time;
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"Guid"] isEqualToString:Guid]) {
            time=[NSString stringWithFormat:@"%@:00--%@:00",[dict objectForKey:@"t_PlaceOder_sTime"],[dict objectForKey:@"t_PlaceOder_eTime"]];
        }
    }
    [selectTime setTitle:[NSString stringWithFormat:@"%@   %@",[dict objectForKey:@"t_Order_Date"],time] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)EnSureOrdered {
    
    [SVProgressHUD showWithStatus:@"预约空间" maskType:SVProgressHUDMaskTypeBlack];
    [HttpRoomAction EnSureOrdered:guid userGuid:UserDefaultEntity.uuid remark:@"" Token:[MyAes aesSecretWith:@"orderPlaceGuid"] complete:^(id result, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSDictionary *dict=result[0];
        
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请检查信息重新提交" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}


-(void)payRoom{
    
    NSString *payType=@"";
    [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
    [HttpAlipayAction AddOrder:associateGuid userGuid:UserDefaultEntity.uuid ordertype:5 paytype:payType money:price name:t_Place_StyleName remark:[NSString stringWithFormat:@"空间预约%@",t_Place_StyleName] Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *dic=[dict objectForKey:@"result"][0];
            NSString*ordernum = [dic objectForKey:@"t_Order_No"];
            ActivityPayVCN *activity = [[ActivityPayVCN alloc]init];
            activity.orderDic = dic;
            activity.price = [(NSNumber*)price floatValue];
            activity.type = 3;
            activity.orderNum = ordernum;
            activity.titlestr = t_Place_StyleName;
            [activity setDealBlock:^{
                [self EnSureOrdered];
            }];
            [self.navigationController pushViewController:activity animated:YES];
        }
        
    }];

}

-(void)appiontView:(id)sender{
    
    if ([self isBlankString:guid]) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约空间的时间" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [HttpRoomAction IfOrder:associateGuid userGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"orderPlaceGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"false"]) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"illegal"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            float money = [(NSNumber*)price floatValue];
            if (money==0.00) {
                [self EnSureOrdered];
            } else {
                [self payRoom];
            }
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.height;
    //根据isShowMoreText属性判断cell的高度
    if (indexPath.section == 0) {
        if (entity.isShowMoreText){
            return [TextShowCell cellMoreHeight:entity];
        }else{
            return [TextShowCell cellDefaultHeight:entity];
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell";
        TextShowCell *cell = (TextShowCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[TextShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //这里的判断是为了防止数组越界
        cell.entity = entity;
        //自定义cell的回调，获取要展开/收起的cell。刷新点击的cell
        cell.showMoreTextBlock = ^(UITableViewCell *currentCell){
            NSIndexPath *indexRow = [self.tableView indexPathForCell:currentCell];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexRow, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self creatimgview];
        };
        
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 5*PMBHEIGHT;
    }
    return 0;
}

@end
