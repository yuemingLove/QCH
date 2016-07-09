//
//  DynamicViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "DynamicViewController.h"
#import "DynamicTWCell.h"
#import "DynamicstateVC.h"
#import "MakersVC.h"
#import "QchpartnerVC.h"
#import "ParntDetailVC.h"
#import "WJAdsView.h"
#import "Masonry.h"
#import "PersonInfomationVC.h"
#import "CertificationVC.h"
#import "DynamicTWCell3.h"
#import "DynamicTWCell5.h"
#import "DynamicTWCell7.h"
#import "AddCertificationVC.h"

//角度转换成弧度
#define  ANGEL(x) x/180.0 * M_PI

#define kPerSecondA     ANGEL(6)
#define kPerMinuteA     ANGEL(6)
#define kPerHourA       ANGEL(30)
#define kPerHourMinuteA ANGEL(0.5)

@interface DynamicViewController ()<UITableViewDelegate,UITableViewDataSource,DynamicTWCellDeleagte,XHImageViewerDelegate,WJAdsViewDelegate,DynamicCell3Deleagte,DynamicTWCell7Deleagte,DynamicTWCell5Deleagte>
{
    UILabel *Money;
    UILabel *Moneylab;
    UILabel *tabLabel; // 标签label
    UIView *headBgkView; // 头广告视图
    NSString *IsInvestor;
    WJAdsView *adsView;
}

@property (nonatomic,strong) NSMutableArray *dynamiclist;

@property (nonatomic,strong) NSArray *keys;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TSEColor(240, 240, 240);
    //[self showView];
    if (_dynamiclist !=nil) {
        _dynamiclist=[[NSMutableArray alloc]init];
    }
    
    [self setTableView];
    [self setCertifiedPartnerView];
    if (![UserDefaultEntity.NowNeed isEqualToString:@"0"]) {
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
        
        [headBgkView removeFromSuperview];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self GetIsInvestor];
    if (![UserDefaultEntity.NowNeed isEqualToString:@"0"]) {
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
        
        [headBgkView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (void)setCertifiedPartnerView {
    headBgkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    headBgkView.backgroundColor = [UIColor themeGrayColor];
    headBgkView.userInteractionEnabled = YES;
    [headBgkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapheadBgkView:)]];
    [self.view addSubview:headBgkView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 5)];
    line.backgroundColor = TSEColor(240, 240, 240);
   // [headBgkView addSubview:line];
    UILabel *label = [self createLabelFrame:CGRectMake(10, 10, ScreenWidth - 20, 30) color:TSEColor(110, 151, 245) font:Font(12) text:@"        完善创业意向和需求，不错过每一个创业机会"];
    label.layer.cornerRadius = label.height / 2;
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 0.6;
    label.layer.borderColor = TSEColor(110, 151, 245).CGColor;
    [headBgkView addSubview:label];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(headBgkView.left + 14, 14, 22, 22)];
    [image setImage:[UIImage imageNamed:@"new_goon"]];
    [headBgkView addSubview:image];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(headBgkView.right - 50, 0, 50, 50);
    [button setImage:[UIImage imageNamed:@"new_cancle"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancleNewsAction) forControlEvents:UIControlEventTouchUpInside];
    [headBgkView addSubview:button];
}


- (void)cancleNewsAction {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [headBgkView removeFromSuperview];
}
- (void)tapheadBgkView:(UITapGestureRecognizer *)tap{
    if ([UserDefaultEntity.user_style isEqualToString:@"2"]) {
        if ([IsInvestor isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:@"您申请投资人正在审核中……" maskType:SVProgressHUDMaskTypeBlack];
        }else if ([IsInvestor isEqualToString:@"1"]){
            [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
            [dict setObject:UserDefaultEntity.uuid forKey:@"guid"];
            [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
            [HttpPartnerAction GetUserView:dict complete:^(id result, NSError *error) {
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                    NSDictionary *_parntDict = [result objectForKey:@"result"][0];
                    InvestorsInformationVC *person =[[InvestorsInformationVC alloc]init];
                    person.hidesBottomBarWhenPushed = YES;
                    person.title = @"编辑资料";
                    person.InvestArray = (NSMutableArray *)[_parntDict objectForKey:@"InvestCase"];
                    NSString *purpose = @"";
                    NSString *purposeid = @"";
                    
                    for (int i = 0; i<[[_parntDict objectForKey:@"Intention"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"Intention"] objectAtIndex:i];
                        NSString *intention = [dict objectForKey:@"IntentionName"];
                        NSString *ID = [dict objectForKey:@"IntentionID"];
                        if ([self isBlankString:purpose]) {
                            purpose = intention;
                        }else{
                            purpose = [purpose stringByAppendingString:[NSString stringWithFormat:@" %@",intention]];
                        }
                        if ([self isBlankString:purposeid]) {
                            purposeid = ID;
                        }else{
                            purposeid = [purposeid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                        }
                    }
                    person.purpose = purpose;
                    person.purposeID = purposeid;
                    person.type = 1;
                    
                    NSString *beststr =@"";
                    NSString *bestid = @"";
                    
                    for (int i = 0; i<[[_parntDict objectForKey:@"Best"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"Best"] objectAtIndex:i];
                        NSString *best = [dict objectForKey:@"BestName"];
                        NSString *ID = [dict objectForKey:@"BestID"];
                        
                        if ([self isBlankString:beststr]) {
                            beststr = best;
                        }else{
                            beststr = [beststr stringByAppendingString:[NSString stringWithFormat:@" %@",best]];
                        }
                        
                        if ([self isBlankString:bestid]) {
                            bestid = ID;
                        }else{
                            bestid = [bestid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                        }
                    }
                    person.Best = beststr;
                    person.Bestid = bestid;
                    person.type = 1;
                    
                    NSString *attention = @"";
                    NSString *attentionid = @"";
                    
                    for (int i = 0; i<[[_parntDict objectForKey:@"FoucsArea"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"FoucsArea"] objectAtIndex:i];
                        NSString *atten = [dict objectForKey:@"FoucsName"];
                        NSString *ID = [dict objectForKey:@"FoucsID"];
                        if ([self isBlankString:attention]) {
                            attention = atten;
                        }else{
                            attention = [attention stringByAppendingString:[NSString stringWithFormat:@" %@",atten]];
                        }
                        if ([self isBlankString:attentionid]) {
                            attentionid = ID;
                        }else{
                            attentionid = [attentionid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                        }
                    }
                    person.Attentionstr = attention;
                    person.Attentionid = attentionid;
                    person.type = 1;
                    
                    NSString *nowneed = @"";
                    NSString *nowneedid = @"";
                    
                    for (int i = 0; i<[[_parntDict objectForKey:@"NowNeed"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"NowNeed"] objectAtIndex:i];
                        NSString *need = [dict objectForKey:@"NowNeedName"];
                        NSString *ID = [dict objectForKey:@"NowNeedID"];
                        if ([self isBlankString:nowneed]) {
                            nowneed = need;
                        }else{
                            nowneed = [nowneed stringByAppendingString:[NSString stringWithFormat:@" %@",need]];
                        }
                        if ([self isBlankString:nowneedid]) {
                            nowneedid = ID;
                        }else{
                            nowneedid = [nowneedid stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                        }
                    }
                    
                    person.NowneedStr = nowneed;
                    person.NowneedID = nowneedid;
                    person.type = 1;
                    
                    NSString *beststring = @"";
                    NSString *bestID = @"";
                    for (int i=0; i<[[_parntDict objectForKey:@"InvestArea"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"InvestArea"] objectAtIndex:i];
                        NSString *best = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestAreaName"]];
                        NSString*ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestAreaID"]];
                        if ([self isBlankString:beststring]) {
                            beststring = best;
                        }else{
                            beststring = [beststring stringByAppendingString:[NSString stringWithFormat:@" %@",best]];
                        }
                        if ([self isBlankString:bestID]) {
                            bestID=ID;
                        } else {
                            bestID = [bestID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                        }
                    }
                    person.DomainIDstr = bestID;
                    person.type=1;
                    person.DomainStr = beststring;
                    
                    NSString *DomainS = @"";
                    NSString *Id = @"";
                    for (int i =0; i<[[_parntDict objectForKey:@"InvestPhase"] count]; i++) {
                        NSDictionary *dict = [[_parntDict objectForKey:@"InvestPhase"] objectAtIndex:i];
                        NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestPhaseName"]];
                        NSString *domainID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"InvestPhaseID"]];
                        if ([self isBlankString:DomainS]) {
                            DomainS = domain;
                        }else{
                            DomainS = [DomainS stringByAppendingString:[NSString stringWithFormat:@" %@",domain]];
                        }
                        if ([self isBlankString:Id]) {
                            Id = domainID;
                        } else {
                            Id = [Id stringByAppendingString:[NSString stringWithFormat:@";%@",domainID]];
                        }
                    }
                    person.StateIDstr = Id;
                    person.type=1;
                    person.StateStr = DomainS;
                    person.IforNo=YES;
                    [self.navigationController pushViewController:person animated:NO];
                    
                }
            }];
        }else if ([IsInvestor isEqualToString:@"2"]){
            CertificationVC *certifi = [[CertificationVC alloc]init];
            certifi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:certifi animated:NO];
        }
    }else if ([UserDefaultEntity.user_style isEqualToString:@"3"]){
        [SVProgressHUD showWithStatus:@"加载中……" maskType:SVProgressHUDMaskTypeBlack];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        [dict setObject:UserDefaultEntity.uuid forKey:@"guid"];
        [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpPartnerAction GetUserView:dict complete:^(id result, NSError *error) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                RootPartnerClass *rpnc = [[RootPartnerClass alloc]initWithDictionary:result];
                NSDictionary*_item = [result objectForKey:@"result"][0];
                PartnerResult*model = rpnc.result[0];
                PersonInfomationVC *person =[[PersonInfomationVC alloc]init];
                person.title = @"编辑资料";
                person.hidesBottomBarWhenPushed = YES;
                person.HistoryWorkArray = [model.historyWork mutableCopy];
                NSString *beststring = @"";
                NSString *bestID = @"";
                for (int i=0; i<[[_item objectForKey:@"Best"] count]; i++) {
                    NSDictionary *dict = [[_item objectForKey:@"Best"] objectAtIndex:i];
                    NSString *best = [NSString stringWithFormat:@"%@",[dict objectForKey:@"BestName"]];
                    NSString*ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"BestID"]];
                    if ([self isBlankString:beststring]) {
                        beststring = best;
                    }else{
                        beststring = [beststring stringByAppendingString:[NSString stringWithFormat:@" %@",best]];
                    }
                    if ([self isBlankString:bestID]) {
                        bestID=ID;
                    } else {
                        bestID = [bestID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                    }
                }
                person.BestIDstr = bestID;
                person.type=1;
                person.BestStr = beststring;
                
                
                NSString *DomainS = @"";
                NSString *Id = @"";
                for (int i =0; i<[[_item objectForKey:@"FoucsArea"] count]; i++) {
                    NSDictionary *dict = [[_item objectForKey:@"FoucsArea"] objectAtIndex:i];
                    NSString *domain = [NSString stringWithFormat:@"%@",[dict objectForKey:@"FoucsName"]];
                    NSString *domainID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"FoucsID"]];
                    if ([self isBlankString:DomainS]) {
                        DomainS = domain;
                    }else{
                        DomainS = [DomainS stringByAppendingString:[NSString stringWithFormat:@" %@",domain]];
                    }
                    if ([self isBlankString:Id]) {
                        Id = domainID;
                    } else {
                        Id = [Id stringByAppendingString:[NSString stringWithFormat:@";%@",domainID]];
                    }
                }
                person.DomainIDstr = Id;
                person.type=1;
                person.DomainStr = DomainS;
                
                NSString *IntentionName = @"";
                NSString *IntentionID = @"";
                
                for (int i = 0; i<[[_item objectForKey:@"Intention"] count]; i++) {
                    NSDictionary *dict = [[_item objectForKey:@"Intention"] objectAtIndex:i];
                    NSString *Name = [dict objectForKey:@"IntentionName"];
                    NSString *ID = [dict objectForKey:@"IntentionID"];
                    if ([self isBlankString:IntentionName]) {
                        IntentionName = Name;
                    } else {
                        IntentionName = [IntentionName stringByAppendingString:[NSString stringWithFormat:@" %@",Name]];
                    }
                    if ([self isBlankString:IntentionID]) {
                        IntentionID = ID;
                    } else {
                        IntentionID = [IntentionID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                    }
                }
                person.IntentionIDStr = IntentionID;
                person.IntentionName = IntentionName;
                person.type = 1;
                
                NSString *NowNeedName=@"";
                NSString *NowNeedID = @"";
                
                for (int i = 0; i<[[_item objectForKey:@"NowNeed"] count]; i++) {
                    NSDictionary *dict = [[_item objectForKey:@"NowNeed"] objectAtIndex:i];
                    NSString *Name = [dict objectForKey:@"NowNeedName"];
                    NSString *ID =[dict objectForKey:@"NowNeedID"];
                    
                    if ([self isBlankString:NowNeedName]) {
                        NowNeedName = Name;
                    } else {
                        NowNeedName = [NowNeedName stringByAppendingString:[NSString stringWithFormat:@" %@",Name]];
                    }
                    if ([self isBlankString:NowNeedID]) {
                        NowNeedID = ID;
                    }else{
                        NowNeedID = [NowNeedID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                    }
                }
                person.NowNeedName = NowNeedName;
                person.NowNeedID = NowNeedID;
                person.type = 1;
                [self.navigationController pushViewController:person animated:NO];
                
            }
        }];
        
    }else{
        CertificationVC *certifi = [[CertificationVC alloc]init];
        certifi.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certifi animated:NO];
    }
}
-(void)setTableView{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dynamicHeaderFreshing)];
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dynamicFooterFreshing)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.bottom.right.equalTo(self.view);
    }];
    [self cleanTableView:self.tableView];
}

-(void)cleanTableView:(UITableView *)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    tableView.tableFooterView=view;
}

-(void)dynamicHeaderFreshing{
    // 下拉加载显示加载完成时上拉刷新重新改变下拉加载为普通状态
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSString *city = @"";
    if ([_dyCity isEqualToString:@"全国"]) {
        _dyCity = city;
    }
    [HttpDynamicAction dynamiclist:UserDefaultEntity.uuid city:_dyCity page:PAGE pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            if (![self isBlankString:UserDefaultEntity.Coupon]) {
                [self showView];
            }
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
            _dynamiclist=[[NSMutableArray alloc]initWithArray:item];
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            _dynamiclist=[[NSMutableArray alloc]init];
            
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
            _dynamiclist=[[NSMutableArray alloc]init];
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
        if ([_dynamiclist count]>0) {
            self.tableView.tableHeaderView = nil;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    }];
}

- (void)touchAction:(UITapGestureRecognizer *)tap{
    [self dynamicHeaderFreshing];
}

-(void)dynamicFooterFreshing{
    
    NSString *city = @"";
    if ([_dyCity isEqualToString:@""]) {
        _dyCity = city;
    }
    
    if ([_dynamiclist count] > 0 && [_dynamiclist count] % PAGESIZE == 0) {
        
        [HttpDynamicAction dynamiclist:UserDefaultEntity.uuid city:_dyCity page:[_dynamiclist count]/PAGESIZE+1 pagesize:PAGESIZE Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
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
                    model.NowNeed =[dict objectForKey:@"NowNeed"];
                    model.Intention = [dict objectForKey:@"Intention"];
                    model.talkcount = [dict objectForKey:@"talkcount"];
                    [item addObject:model];
                }
                
                [_dynamiclist addObjectsFromArray:item];
                
            }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
                
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

- (void)showView {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.backgroundColor = [UIColor colorWithWhite:20
                                                           alpha:0.3];
    adsView = [[WJAdsView alloc] initWithWindow:appDelegate.window];
    
    adsView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    adsView.delegate = self;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.height)];
    backview.backgroundColor = [UIColor clearColor];
    
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 0*PMBWIDTH, 222*PMBWIDTH, 265*PMBWIDTH)];
    backimg.image = [UIImage imageNamed:@"my_beijing"];//260,310; 260,235
    
    Money = [[UILabel alloc]initWithFrame:CGRectMake(82*PMBWIDTH, 100*PMBWIDTH, 90*PMBWIDTH, 20*PMBWIDTH)];
    Money.text = [NSString stringWithFormat:@"¥%@",UserDefaultEntity.Coupon];
    Money.font = Font(20);
    Money.textAlignment = NSTextAlignmentCenter;
    Money.textColor = TSEColor(110, 151, 245);
    [backimg addSubview:Money];
    Moneylab = [[UILabel alloc]initWithFrame:CGRectMake(0, 162*PMBWIDTH, backimg.width, 30*PMBWIDTH)];
    Moneylab.text = [NSString stringWithFormat:@"恭喜！获得%@元代金券",UserDefaultEntity.Coupon];
    Moneylab.font = Font(17);
    Moneylab.textAlignment = NSTextAlignmentCenter;
    Moneylab.textColor = [UIColor whiteColor];
    [backimg addSubview:Moneylab];
    [backview addSubview:backimg];
    UILabel *messageLabel = [self createLabelFrame:CGRectMake(20*PMBWIDTH, Moneylab.bottom+2*PMBWIDTH, backimg.width-37*PMBWIDTH, 15*PMBWIDTH) color:TSEColor(94, 255, 207) font:Font(13) text:@"进行实名认证, 得到更多代金券"];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [backview addSubview:messageLabel];
    UIButton *sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame = CGRectMake(40*PMBWIDTH, messageLabel.bottom+10*PMBWIDTH, backimg.width-80*PMBWIDTH, 30*PMBWIDTH);
    sharebtn.center = CGPointMake(backimg.center.x, sharebtn.center.y);
    sharebtn.backgroundColor = TSEColor(110, 151, 245);
    sharebtn.layer.cornerRadius = sharebtn.height/2;
    sharebtn.layer.borderWidth = 0.6;
    sharebtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [sharebtn setTitle:@"实名认证" forState:UIControlStateNormal];
    [sharebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sharebtn.titleLabel.font = Font(15);
    [sharebtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:sharebtn];
    [array addObject:backview];
    adsView.containerSubviews = array;
    [appDelegate.window addSubview:adsView];
    [adsView showAnimated:YES];
    UserDefaultEntity.Coupon = nil;
    [UserDefault saveUserDefault];
    
}

-(void)shareAction:(UIButton *)sender
{
    [adsView hideAnimated:YES];
    AddCertificationVC *addVC = [[AddCertificationVC alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dynamiclist.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DynamicModel *model=[_dynamiclist objectAtIndex:section];
    
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
    return 37;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel *model=[_dynamiclist objectAtIndex:indexPath.section];
    
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
        [cell.MoreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DynamicModel *model = [_dynamiclist objectAtIndex:indexPath.section];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:YES];
}

//图片浏览
- (void) tapImageWithObject:(DynamicTWCell *)cell tap:(UITapGestureRecognizer *)tap{
    
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:index];
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:index];
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:index];
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:index];
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
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
    }];
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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

- (void)shareClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
    
    DynamicModel *model=[_dynamiclist objectAtIndex:cell.tag];
    
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
//删除动态
- (void)deleteClicked:(DynamicTWCell *)cell index:(NSInteger)index{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除此条动态么" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okActon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            DynamicModel *model=[_dynamiclist objectAtIndex:index];
            NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
            [deletedic setObject:model.Guid forKey:@"guid"];
            [deletedic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
            [HttpDynamicAction dynamicdelete:deletedic complete:^(id result, NSError *error) {
                if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                    [self.tableView.mj_header beginRefreshing];
                }
            }];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okActon];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除此条动态么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        DynamicModel *model=[_dynamiclist objectAtIndex:index];
        NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
        [deletedic setObject:model.Guid forKey:@"guid"];
        [deletedic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
        [HttpDynamicAction dynamicdelete:deletedic complete:^(id result, NSError *error) {
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                
                [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okActon];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除此条动态么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        DynamicModel *model=[_dynamiclist objectAtIndex:index];
        NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
        [deletedic setObject:model.Guid forKey:@"guid"];
        [deletedic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
        [HttpDynamicAction dynamicdelete:deletedic complete:^(id result, NSError *error) {
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                
                [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okActon];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确定删除此条动态么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okActon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        DynamicModel *model=[_dynamiclist objectAtIndex:index];
        NSMutableDictionary *deletedic = [[NSMutableDictionary alloc]init];
        [deletedic setObject:model.Guid forKey:@"guid"];
        [deletedic setObject:[MyAes aesSecretWith:@"guid"] forKey:@"Token"];
        [HttpDynamicAction dynamicdelete:deletedic complete:^(id result, NSError *error) {
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                
                [SVProgressHUD showSuccessWithStatus:[result objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okActon];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//点击全文进入详情
- (void)more:(UIButton *)sender
{
    NSInteger index = sender.tag;
    DynamicModel *model=[_dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamic animated:YES];
    
}

//动态评论
- (void)talkClicked:(DynamicTWCell *)cell index:(NSInteger)index
{
    DynamicModel *model = [_dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = YES;
    [dynamic setRefleshBlock:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
    
}

- (void)talkClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}

- (void)talkClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}

- (void)talkClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index
{
    DynamicModel *model = [_dynamiclist objectAtIndex:index];
    DynamicstateVC *dynamic = [[DynamicstateVC alloc]init];
    dynamic.guid = model.Guid;
    dynamic.hidesBottomBarWhenPushed = YES;
    dynamic.type=1;
    dynamic.flag = NO;
    [dynamic setReflesh1Block:^{
        model.talkcount = [NSString stringWithFormat:@"%ld", [(NSNumber *)model.talkcount integerValue] + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:dynamic animated:YES];
}
@end
