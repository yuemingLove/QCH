//
//  MyDynamicVC.m
//  qch
//
//  Created by 青创汇 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "MyDynamicVC.h"
#import "DynamicTWCell.h"
#import "DynamicstateVC.h"
#import "ParntDetailVC.h"
#import "QchpartnerVC.h"
#import "MakersVC.h"
#import "DynamicTWCell3.h"
#import "DynamicTWCell5.h"
#import "DynamicTWCell7.h"
#define  ANGEL(x) x/180.0 * M_PI

#define kPerSecondA     ANGEL(6)
#define kPerMinuteA     ANGEL(6)
#define kPerHourA       ANGEL(30)
#define kPerHourMinuteA ANGEL(0.5)

@interface MyDynamicVC ()<UITableViewDataSource,UITableViewDelegate,DynamicTWCellDeleagte,XHImageViewerDelegate,DynamicCell3Deleagte,DynamicTWCell7Deleagte,DynamicTWCell5Deleagte>{
    
    NSString *name;
    NSString *Guid;
    UILabel *tabLabel; // 标签label
}

@property (nonatomic,strong) UITableView *Dynamictableview;
@property (nonatomic,strong) NSMutableArray*Dynamiclist;

@end

@implementation MyDynamicVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //禁用
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_Dynamiclist!=nil) {
        _Dynamiclist = [[NSMutableArray alloc]init];
    }
    [self createTableView];
    if (_type==1) {
        Guid = _guid;
    }else{
        Guid = UserDefaultEntity.uuid;
    }
}

-(void)createTableView{
    
    _Dynamictableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _Dynamictableview.delegate=self;
    _Dynamictableview.dataSource=self;
    _Dynamictableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.Dynamictableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerFreshing)];
    self.Dynamictableview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerFreshing)];
    
    [self.view addSubview:_Dynamictableview];
    [self setExtraCellLineHidden:_Dynamictableview];
    
    [self.Dynamictableview.mj_header beginRefreshing];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)headerFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.Dynamictableview.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.Dynamictableview.mj_footer resetNoMoreData];
    }

    [HttpCenterAction GetMyTopic:Guid page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array=(NSArray*)[dict objectForKey:@"result"];
            NSMutableArray *item=[[NSMutableArray alloc]init];
            for (int i=0; i<[array count]; i++) {
                
                NSDictionary *dict=array[i];
                DynamicModel *model=[[DynamicModel alloc]init];
                model.t_UserStyleAudit = [dict objectForKey:@"t_UserStyleAudit"];
                model.Guid=[dict objectForKey:@"Guid"];
                model.Pic=[dict objectForKey:@"Pic"];
                model.PraiseCount=[dict objectForKey:@"PraiseCount"];
                model.PraiseUsers=[[dict objectForKey:@"PraiseUsers"] mutableCopy];
                model.t_Topic_Latitude=[dict objectForKey:@"t_Topic_Latitude"];
                model.t_Topic_Top=[dict objectForKey:@"t_Topic_Top"];
                model.t_Date=[dict objectForKey:@"t_Date"];
                model.t_User_RealName=[dict objectForKey:@"t_User_RealName"];
                model.t_Topic_Longitude=[dict objectForKey:@"t_Topic_Longitude"];
                model.t_Topic_Address=[dict objectForKey:@"t_Topic_Address"];
                model.t_User_LoginId=[dict objectForKey:@"t_User_LoginId"];
                NSString *text=[[dict objectForKey:@"t_Topic_Contents"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                model.t_Topic_Contents=text;
                model.t_User_Pic=[dict objectForKey:@"t_User_Pic"];
                model.t_User_Guid=[dict objectForKey:@"t_User_Guid"];
                model.t_Topic_City=[dict objectForKey:@"t_Topic_City"];
                model.ifPraise=[dict objectForKey:@"ifPraise"];
                model.t_User_Position = [dict objectForKey:@"t_User_Position"];
                model.t_User_Commpany = [dict objectForKey:@"t_User_Commpany"];
                model.PositionName = [dict objectForKey:@"PositionName"];
                model.t_User_Style = [dict objectForKey:@"t_User_Style"];
                model.Best = [dict objectForKey:@"Best"];
                model.NowNeed = [dict objectForKey:@"NowNeed"];
                model.Intention = [dict objectForKey:@"Intention"];
                model.talkcount = [dict objectForKey:@"talkcount"];
                [item addObject:model];
            }
            _Dynamiclist=item;
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _Dynamiclist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.Dynamictableview.frame];
            UIImageView *empty=[[UIImageView alloc]initWithFrame:CGRectMake( (SCREEN_WIDTH-250)/2,(SCREEN_HEIGHT-64-49-250-40)/2, 250, 250)];
            [empty setImage:[UIImage imageNamed:@"no_dt"]];
            [emptyView addSubview:empty];
            self.Dynamictableview.tableHeaderView = emptyView;
            emptyView.userInteractionEnabled=NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            });

        }else{
            _Dynamiclist=[[NSMutableArray alloc]init];
            UIView *emptyView = [[UIView alloc] initWithFrame:self.Dynamictableview.frame];
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
            self.Dynamictableview.tableHeaderView = emptyView;
            [SVProgressHUD showErrorWithStatus:@"加载失败" maskType:SVProgressHUDMaskTypeBlack];
        }
     
        if ([_Dynamiclist count]>0) {
            self.Dynamictableview.tableHeaderView = nil;
        }
        [self.Dynamictableview.mj_header endRefreshing];
        [self.Dynamictableview reloadData];
    }];
}
- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self headerFreshing];
}
-(void)footerFreshing{
    
    if ([_Dynamiclist count] > 0 && [_Dynamiclist count] % PAGESIZE == 0) {
        
       [HttpCenterAction GetMyTopic:Guid page:[_Dynamiclist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                NSArray *array=(NSArray*)[dict objectForKey:@"result"];
                NSMutableArray *item=[[NSMutableArray alloc]init];
                for (int i=0; i<[array count]; i++) {
                    
                    NSDictionary *dict=array[i];
                    DynamicModel *model=[[DynamicModel alloc]init];
                    model.t_UserStyleAudit = [dict objectForKey:@"t_UserStyleAudit"];
                    model.Guid=[dict objectForKey:@"Guid"];
                    model.Pic=[dict objectForKey:@"Pic"];
                    model.PraiseCount=[dict objectForKey:@"PraiseCount"];
                    model.PraiseUsers=[[dict objectForKey:@"PraiseUsers"] mutableCopy];
                    model.t_Topic_Latitude=[dict objectForKey:@"t_Topic_Latitude"];
                    model.t_Topic_Top=[dict objectForKey:@"t_Topic_Top"];
                    model.t_Date=[dict objectForKey:@"t_Date"];
                    model.t_User_RealName=[dict objectForKey:@"t_User_RealName"];
                    model.t_Topic_Longitude=[dict objectForKey:@"t_Topic_Longitude"];
                    model.t_Topic_Address=[dict objectForKey:@"t_Topic_Address"];
                    model.t_User_LoginId=[dict objectForKey:@"t_User_LoginId"];
                    NSString *text=[[dict objectForKey:@"t_Topic_Contents"] stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
                    model.t_Topic_Contents=text;
                    model.t_User_Pic=[dict objectForKey:@"t_User_Pic"];
                    model.t_User_Guid=[dict objectForKey:@"t_User_Guid"];
                    model.t_Topic_City=[dict objectForKey:@"t_Topic_City"];
                    model.ifPraise=[dict objectForKey:@"ifPraise"];
                    model.t_User_Position = [dict objectForKey:@"t_User_Position"];
                    model.t_User_Commpany = [dict objectForKey:@"t_User_Commpany"];
                    model.PositionName = [dict objectForKey:@"PositionName"];
                    model.t_User_Style = [dict objectForKey:@"t_User_Style"];
                    model.Best = [dict objectForKey:@"Best"];
                    model.NowNeed = [dict objectForKey:@"NowNeed"];
                    model.Intention = [dict objectForKey:@"Intention"];
                    model.talkcount = [dict objectForKey:@"talkcount"];
                    [item addObject:model];
                }
                [_Dynamiclist addObjectsFromArray:item];
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
              
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
            }
            [self.Dynamictableview reloadData];
            [self.Dynamictableview.mj_footer endRefreshing];
        }];
        
    }else{
        [self.Dynamictableview.mj_footer endRefreshingWithNoMoreData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _Dynamiclist.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DynamicModel *model=[_Dynamiclist objectAtIndex:section];
    
    NSDate *date=[DateFormatter stringToDateCustom:model.t_Date formatString:def_YearMonthDayHourMinuteSec_DF];
    NSString *time=[DateFormatter dateToStringCustom:date formatString:def_YearMonthDayHourMinuteSec_DF];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor=[UIColor whiteColor];
    
    if ([self isBlankString:time]) {
        NSString *date=[DateFormatter dateToStringCustom:[NSDate new] formatString:def_YearMonthDayHourMinuteSec_DF];
        [self addHeadFrame:headView time:date model:model];
    }else{
        [self addHeadFrame:headView time:time model:model];
    }
    
    
    return headView;

}


-(void)addHeadFrame:(UIView *)view time:(NSString*)time model:(DynamicModel*)model{
    
    UIView *timeView = [[UIControl alloc] initWithFrame:CGRectMake(10, 5, 100, 27)];
    timeView.layer.masksToBounds=YES;
    timeView.layer.cornerRadius=timeView.height/2;
    
    [timeView setBackgroundColor:TSEColor(182, 203, 253)];
    [view addSubview:timeView];
    
    tabLabel = [[UILabel alloc] init];
    tabLabel.textColor = TSEColor(110, 151, 245);
    tabLabel.font = Font(12);
    [view addSubview:tabLabel];
    [tabLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.right.equalTo(view).offset(-10);
        make.height.mas_equalTo(15);
    }];
    UIImageView *tabImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_tab"]];
    [view addSubview:tabImage];
    [tabImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.right.equalTo(tabLabel.mas_left).offset(-1);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    NSString *IntentionName = @"";
    if ([model.Intention count]>0) {
        NSArray *Array = model.Intention;
        for (int i = 0; i <[Array count]; i++) {
            NSDictionary *dict = Array[i];
            NSString *intention = [dict objectForKey:@"IntentionName"];
            if ([self isBlankString:IntentionName]) {
                IntentionName = intention;
            } else {
                IntentionName = [IntentionName stringByAppendingString:[NSString stringWithFormat:@" %@",intention]];
            }
        }
        tabLabel.text =IntentionName;
    }else{
        tabLabel.hidden = YES;
        tabImage.hidden = YES;
    }
    
    
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 1*PMBWIDTH, 37-5-timeView.height)];
    linelab.backgroundColor = TSEColor(213, 226, 253);
    [view addSubview:linelab];
    UILabel *linelab1 = [[UILabel alloc]initWithFrame:CGRectMake(25, timeView.bottom, 1*PMBWIDTH, 5)];
    linelab1.backgroundColor = TSEColor(213, 226, 253);
    [view addSubview:linelab1];
    
    UIImageView *imageClock = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_block"]];
    
    [imageClock setBackgroundColor:[UIColor clearColor]];
    imageClock.frame = CGRectMake(1, 1, 25,25);
    imageClock.layer.masksToBounds=YES;
    imageClock.layer.cornerRadius=imageClock.height/2;
    [timeView addSubview:imageClock];
    
    
    CALayer *layerMin = [CALayer layer];
    layerMin.bounds = CGRectMake(0, 0, 0.3, 7);
    layerMin.backgroundColor = [UIColor blackColor].CGColor;
    layerMin.cornerRadius = 0.9;
    layerMin.anchorPoint = CGPointMake(0.5, 1);
    layerMin.position = CGPointMake(imageClock.width/2, imageClock.height/2);
    [imageClock.layer addSublayer:layerMin];
    
    CALayer *layerHour = [CALayer layer];
    layerHour.bounds = CGRectMake(0, 0, 0.6, 4);
    layerHour.backgroundColor = [UIColor blackColor].CGColor;
    layerHour.cornerRadius = 0.6;
    layerHour.anchorPoint = CGPointMake(0.5, 1);
    layerHour.position = CGPointMake(imageClock.width/2, imageClock.height/2);
    [imageClock.layer addSublayer:layerHour];
    
    
    [self timeChange:time layerMin:layerMin layerHour:layerHour];
    
    //设置  头视图的标题什么的
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(imageClock.right+5, imageClock.top+5, 80, imageClock.height/2)];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:10];
    time=[time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    time=[time substringFromIndex:5];
    time=[time substringToIndex:11];
    titleLable.text = time;
    [timeView addSubview:titleLable];
}

- (void)timeChange:(NSString *)time layerMin:(CALayer*)layerMin layerHour:(CALayer*)layerHour{
    
    if (![self isBlankString:time]) {
        
        NSDate *day= [DateFormatter stringToDateCustom:time formatString:def_YearMonthDayHourMinuteSec_DF];
        
        NSInteger mm=[[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:day];
        NSInteger hh=[[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:day];
        
        layerMin.transform = CATransform3DMakeRotation(mm * kPerMinuteA, 0, 0, 1);
        
        layerHour.transform = CATransform3DMakeRotation(hh * kPerHourA, 0, 0, 1);
        layerHour.transform = CATransform3DMakeRotation(mm * kPerHourMinuteA + hh*kPerHourA, 0, 0, 1);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self tableView:self.Dynamictableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:indexPath.section];
    
    if ([model.t_User_Style isEqualToString:@"2"]) {
        if ([model.Best count]==0 &&[model.Intention count]==0) {
            DynamicTWCell7 *cell = (DynamicTWCell7*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell7"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell7" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell7 class]]) {
                        cell = (DynamicTWCell7 *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([model.Best count]==0 || [model.Intention count]==0){
            DynamicTWCell5 *cell = (DynamicTWCell5*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell5"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell5" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell5 class]]) {
                        cell = (DynamicTWCell5 *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            DynamicTWCell *cell = (DynamicTWCell*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell class]]) {
                        cell = (DynamicTWCell *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    } else if([model.t_User_Style isEqualToString:@"3"]){
        
        if ([model.Best count]==0 &&[model.Intention count]==0) {
            DynamicTWCell7 *cell = (DynamicTWCell7*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell7"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell7" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell7 class]]) {
                        cell = (DynamicTWCell7 *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([model.Best count]==0 || [model.Intention count]==0){
            DynamicTWCell5 *cell = (DynamicTWCell5*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell5"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell5" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell5 class]]) {
                        cell = (DynamicTWCell5 *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            DynamicTWCell *cell = (DynamicTWCell*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell"];
            if (cell == nil) {
                NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell" owner:self options:nil];
                for (id oneObject in nibs) {
                    if ([oneObject isKindOfClass:[DynamicTWCell class]]) {
                        cell = (DynamicTWCell *)oneObject;
                        cell.dyDelegate = self;
                    }
                }
            }
            cell.tag = indexPath.section;
            [cell updateData:model];
            cell.DeleteBtn = nil;
            [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        DynamicTWCell3 *cell = (DynamicTWCell3*)[tableView dequeueReusableCellWithIdentifier:@"DynamicTWCell3"];
        if (cell == nil) {
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"DynamicTWCell3" owner:self options:nil];
            for (id oneObject in nibs) {
                if ([oneObject isKindOfClass:[DynamicTWCell3 class]]) {
                    cell = (DynamicTWCell3 *)oneObject;
                    cell.dyDelegate = self;
                }
            }
        }
        cell.tag = indexPath.section;
        [cell updateData:model];
        cell.DeleteBtn = nil;
        [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel *model = [_Dynamiclist objectAtIndex:indexPath.section];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:YES];

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DynamicModel *model = [_Dynamiclist objectAtIndex:indexPath.section];
        [self delete:model.Guid];
        [_Dynamiclist removeObjectAtIndex:indexPath.section];
    }
}

- (void)more:(UIButton *)sender
{
    NSInteger index = sender.tag;
    DynamicModel *model=[_Dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:YES];
    
}

//动态评论
- (void)talkClicked:(DynamicTWCell *)cell index:(NSInteger)index
{
    DynamicModel *model = [_Dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = YES;
    [dynamic setRefleshBlock:^{
        model.talkcount = [NSString stringWithFormat:@"%lu", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
    
}

- (void)talkClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_Dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}

- (void)talkClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_Dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}

- (void)talkClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_Dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}

- (void)delete:(NSString*)guId{
    
    NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
    [deletedic setObject:guId forKey:@"guid"];
    [deletedic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
    [HttpDynamicAction dynamicdelete:deletedic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
    
            [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            [self headerFreshing];
        }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
            
            [SVProgressHUD showErrorWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([Guid isEqualToString:UserDefaultEntity.uuid]) {
        return YES;
    }else{
        return NO;
    }
}


- (void)tapImageWithObject:(DynamicTWCell *)cell tap:(UITapGestureRecognizer *)tap{
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject3:(DynamicTWCell3 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject5:(DynamicTWCell5 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

- (void)tapImageWithObject7:(DynamicTWCell7 *)cell tap:(UITapGestureRecognizer *)tap
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:cell.imageViews selectedView:(UIImageView *)tap.view];
}

//头像跳转
- (void)tapImg:(DynamicTWCell *)cell tap:(UITapGestureRecognizer *)tap{
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.t_User_Style isEqualToString:@"2"]) {
        if ([model.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = model.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([model.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = model.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = model.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if ([model.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = model.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = model.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }
    
}

- (void)tapImg3:(DynamicTWCell3 *)cell tap:(UITapGestureRecognizer *)tap
{
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.t_User_Style isEqualToString:@"2"]) {
        if ([model.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = model.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([model.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = model.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = model.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if ([model.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = model.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = model.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }
    
}

- (void)tapImg5:(DynamicTWCell5 *)cell tap:(UITapGestureRecognizer *)tap
{
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.t_User_Style isEqualToString:@"2"]) {
        if ([model.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = model.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([model.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = model.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = model.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if ([model.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = model.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = model.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }

}

- (void)tapImg7:(DynamicTWCell7 *)cell tap:(UITapGestureRecognizer *)tap
{
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.t_User_Style isEqualToString:@"2"]) {
        if ([model.t_User_Guid isEqualToString:UserDefaultEntity.uuid]) {
            ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
            parnter.Guid = model.t_User_Guid;
            parnter.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:parnter animated:YES];
            
        }else{
            if ([model.t_UserStyleAudit isEqualToString:@"1"]) {
                ParntDetailVC *parnter = [[ParntDetailVC alloc]init];
                parnter.Guid = model.t_User_Guid;
                parnter.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:parnter animated:YES];
            }else {
                MakersVC *maker = [[MakersVC alloc]init];
                maker.Guid = model.t_User_Guid;
                maker.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:maker animated:YES];
            }
        }
        
    }else if ([model.t_User_Style isEqualToString:@"3"]){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.Guid = model.t_User_Guid;
        partner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:partner animated:YES];
    }else {
        MakersVC *maker = [[MakersVC alloc]init];
        maker.Guid = model.t_User_Guid;
        maker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:maker animated:YES];
    }

}

//点赞
- (void)careClicked:(DynamicTWCell *)cell index:(NSInteger)index{
    
    CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
    keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
    keyAnimation.calculationMode=kCAAnimationLinear;
    [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:index];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:model.Guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    if ([model.ifPraise isEqualToString:@"0"]) {
        // 点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"1"];
        
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in model.PraiseUsers) {
            [arr addObject:dic[@"PraiseUserRealName"]];
        }
        if (![arr containsObject:UserDefaultEntity.realName]) {
            model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] + 1];
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setObject:UserDefaultEntity.realName forKey:@"PraiseUserRealName"];
            [model.PraiseUsers addObject:temDic];
        }
    } else {
        // 取消点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"0"];
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        for (int i = 0; i < model.PraiseUsers.count; i++) {
            NSDictionary *dic = model.PraiseUsers[i];
            if ([dic[@"PraiseUserRealName"] isEqualToString:UserDefaultEntity.realName]) {
                model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] - 1];
                [model.PraiseUsers removeObject:dic];
            }
        }
    }
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }];
}

- (void)careClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index
{
    CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
    keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
    keyAnimation.calculationMode=kCAAnimationLinear;
    [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:index];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:model.Guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    if ([model.ifPraise isEqualToString:@"0"]) {
        // 点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"1"];
        
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in model.PraiseUsers) {
            [arr addObject:dic[@"PraiseUserRealName"]];
        }
        if (![arr containsObject:UserDefaultEntity.realName]) {
            model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] + 1];
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setObject:UserDefaultEntity.realName forKey:@"PraiseUserRealName"];
            [model.PraiseUsers addObject:temDic];
        }
    } else {
        // 取消点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"0"];
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        for (int i = 0; i < model.PraiseUsers.count; i++) {
            NSDictionary *dic = model.PraiseUsers[i];
            if ([dic[@"PraiseUserRealName"] isEqualToString:UserDefaultEntity.realName]) {
                model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] - 1];
                [model.PraiseUsers removeObject:dic];
            }
        }
    }
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }];
}

- (void)careClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index
{
    
    CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
    keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
    keyAnimation.calculationMode=kCAAnimationLinear;
    [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:index];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:model.Guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    if ([model.ifPraise isEqualToString:@"0"]) {
        // 点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"1"];
        
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in model.PraiseUsers) {
            [arr addObject:dic[@"PraiseUserRealName"]];
        }
        if (![arr containsObject:UserDefaultEntity.realName]) {
            model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] + 1];
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setObject:UserDefaultEntity.realName forKey:@"PraiseUserRealName"];
            [model.PraiseUsers addObject:temDic];
        }
    } else {
        // 取消点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"0"];
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        for (int i = 0; i < model.PraiseUsers.count; i++) {
            NSDictionary *dic = model.PraiseUsers[i];
            if ([dic[@"PraiseUserRealName"] isEqualToString:UserDefaultEntity.realName]) {
                model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] - 1];
                [model.PraiseUsers removeObject:dic];
            }
        }
    }
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }];
}

- (void)careClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index
{
    
    CAKeyframeAnimation *keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.values=@[@(0.1),@(1.0),@(1.5)];
    keyAnimation.keyTimes=@[@(0.0),@(0.5),@(0.8),@(1.0)];
    keyAnimation.calculationMode=kCAAnimationLinear;
    [cell.collectBtn.layer addAnimation:keyAnimation forKey:@"SHOW"];
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:index];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [dic setObject:model.Guid forKey:@"topicGuid"];
    [dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    if ([model.ifPraise isEqualToString:@"0"]) {
        // 点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"1"];
        
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_sel"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:TSEColor(176, 190, 224) forState:UIControlStateNormal];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in model.PraiseUsers) {
            [arr addObject:dic[@"PraiseUserRealName"]];
        }
        if (![arr containsObject:UserDefaultEntity.realName]) {
            model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] + 1];
            NSMutableDictionary *temDic = [NSMutableDictionary dictionary];
            [temDic setObject:UserDefaultEntity.realName forKey:@"PraiseUserRealName"];
            [model.PraiseUsers addObject:temDic];
        }
    } else {
        // 取消点赞
        model.ifPraise=[NSString stringWithFormat:@"%@",@"0"];
        [cell.collectBtn setImage:[UIImage imageNamed:@"new_zan_nor"] forState:UIControlStateNormal];
        [cell.collectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        for (int i = 0; i < model.PraiseUsers.count; i++) {
            NSDictionary *dic = model.PraiseUsers[i];
            if ([dic[@"PraiseUserRealName"] isEqualToString:UserDefaultEntity.realName]) {
                model.PraiseCount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.PraiseCount integerValue] - 1];
                [model.PraiseUsers removeObject:dic];
            }
        }
    }
    [HttpDynamicAction care:dic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
            [self.Dynamictableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }];
}

- (void)shareClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.Pic count]>0) {
        
        NSDictionary *dict=model.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
                                               type:SSDKContentTypeAuto];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           //启动键盘
                           IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                           //启用/禁用键盘
                           manager.enable = YES;
                           //启用/禁用键盘触摸外面
                           manager.shouldResignOnTouchOutside = YES;
                           manager.shouldToolbarUsesTextFieldTintColor = YES;
                           manager.enableAutoToolbar = NO;
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
        
    }else{
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       //启动键盘
                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                       //启用/禁用键盘
                       manager.enable = YES;
                       //启用/禁用键盘触摸外面
                       manager.shouldResignOnTouchOutside = YES;
                       manager.shouldToolbarUsesTextFieldTintColor = YES;
                       manager.enableAutoToolbar = NO;
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
        
        
    }

}

- (void)shareClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.Pic count]>0) {
        
        NSDictionary *dict=model.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
                                               type:SSDKContentTypeAuto];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           //启动键盘
                           IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                           //启用/禁用键盘
                           manager.enable = YES;
                           //启用/禁用键盘触摸外面
                           manager.shouldResignOnTouchOutside = YES;
                           manager.shouldToolbarUsesTextFieldTintColor = YES;
                           manager.enableAutoToolbar = NO;
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
        
    }else{
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       //启动键盘
                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                       //启用/禁用键盘
                       manager.enable = YES;
                       //启用/禁用键盘触摸外面
                       manager.shouldResignOnTouchOutside = YES;
                       manager.shouldToolbarUsesTextFieldTintColor = YES;
                       manager.enableAutoToolbar = NO;
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
        
        
    }

}

- (void)shareClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.Pic count]>0) {
        
        NSDictionary *dict=model.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
                                               type:SSDKContentTypeAuto];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           //启动键盘
                           IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                           //启用/禁用键盘
                           manager.enable = YES;
                           //启用/禁用键盘触摸外面
                           manager.shouldResignOnTouchOutside = YES;
                           manager.shouldToolbarUsesTextFieldTintColor = YES;
                           manager.enableAutoToolbar = NO;
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
        
    }else{
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       //启动键盘
                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                       //启用/禁用键盘
                       manager.enable = YES;
                       //启用/禁用键盘触摸外面
                       manager.shouldResignOnTouchOutside = YES;
                       manager.shouldToolbarUsesTextFieldTintColor = YES;
                       manager.enableAutoToolbar = NO;
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
        
        
    }
    
}
- (void)shareClicked:(DynamicTWCell *)cell index:(NSInteger)index{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    DynamicModel *model=[_Dynamiclist objectAtIndex:cell.tag];
    
    if ([model.Pic count]>0) {
        
        NSDictionary *dict=model.Pic[0];
        
        NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
        
        UIImageView *img = [[UIImageView alloc] init];
        
        [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        //1、创建分享参数
        
        NSArray *imageArray = @[img.image];
        
        if (imageArray) {

            NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:[NSString stringWithFormat:@"%@的动态",title]
                                               type:SSDKContentTypeAuto];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           //启动键盘
                           IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                           //启用/禁用键盘
                           manager.enable = YES;
                           //启用/禁用键盘触摸外面
                           manager.shouldResignOnTouchOutside = YES;
                           manager.shouldToolbarUsesTextFieldTintColor = YES;
                           manager.enableAutoToolbar = NO;
                           switch (state) {
                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"1"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }
        
    }else{
        
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"logo"];
        NSArray *imageArray = @[img.image];

        NSString *title = [[NSString stringWithFormat:@"%@",model.t_User_RealName] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        if (title.length>50) {
            title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        }
        NSString *path=[NSString stringWithFormat:@"%@ShareTopic.html?Guid=%@&UserGuid=%@",SHARE_HTML,model.Guid,UserDefaultEntity.uuid];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"我刚在青创汇上发布了一条最新动态，大家快来围观吧"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:[NSString stringWithFormat:@"%@的动态",title]
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       //启动键盘
                       IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                       //启用/禁用键盘
                       manager.enable = YES;
                       //启用/禁用键盘触摸外面
                       manager.shouldResignOnTouchOutside = YES;
                       manager.shouldToolbarUsesTextFieldTintColor = YES;
                       manager.enableAutoToolbar = NO;
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [self ShareIntegral:@"1"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
        
        
    }
    
}
@end
