//
//  MyInfoViewController.m
//  qch
//
//  Created by 苏宾 on 16/3/2.
//  Copyright © 2016年 qch. All rights reserved.
//
#import "MyDetailFirstCell.h"
#import "MyDetailSecondCell.h"
#import "MyDetailThirdCell.h"
#import "MyAccountDetailsCell.h"
#import "MyNewInfoViewController2.h"
#import "CarePersonListVC.h"
#import "MyProjectVC.h"
#import "MyActivityVC.h"
#import "MyCollectVC.h"
#import "MyDynamicVC.h"
#import "PersonInfomationVC.h"
#import "SetAppVC.h"
#import "MyInvestVC.h"
#import "MyAppointVC.h"
#import "ParntDetailVC.h"
#import "QchpartnerVC.h"
#import "MakersVC.h"
#import "MoneyVC.h"
#import "CertificationVC.h"
#import "MyOrderListVC.h"
#import "CertificateViewController.h"
#import "InviteVC.h"
#import "MyCouponVC.h"
#import "MyIntegralVC.h"
#import "SignViewController.h"
#import "AddCertificationVC.h"
#import "BindBankCardVC.h"

@interface MyNewInfoViewController2 ()<UITableViewDataSource,UITableViewDelegate,XHImageViewerDelegate, MyDetailFirstCellDelegate, MyDetailSecondCellDelegate, MyDetailThirdCellDelegate, MyAccountDetailsCellDelegate>{
    //身份区别
    NSInteger style;
    
    NSString *fcount;
    NSString *scount;
    NSString *integral;
    NSString *IsInvestor;
    UIView *promptView;
    UIImageView *lightView;
    UIImageView *promptImage;
    NSInteger status;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *bgkImageView;

@property (nonatomic,strong) UIImageView *mImgaeView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detalLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic,strong) UILabel *dyCount;
@property (nonatomic,strong) UILabel *careCount;
@property (nonatomic,strong) UILabel *fensiCount;

@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, strong) NSDictionary *titles;
@property (nonatomic, strong)NSString *currencyNumber;// 创业币
@property (nonatomic, strong)NSString *couponNumber;// 优惠券
@property (nonatomic, strong)NSString *integralNumber;// 积分

@property (nonatomic,strong) NSDictionary *Countdict;
@property (nonatomic,strong) NSMutableArray *funlist;
@property (nonatomic,strong) NSMutableArray *fanslist;


@end

@implementation MyNewInfoViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_funlist!=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }
    if (_fanslist!=nil) {
        _fanslist = [[NSMutableArray alloc]init];
    }
    [self ifAuditStatus];
    [self createTabelView];
    [self setNeedsStatusBarAppearanceUpdate];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateFrame];
    [self updateMenu];
    [self getData];
    [self GetPraiseUser];
    [self GetUserFuns];
    [self GetInviteUser];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self GetIsInvestor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

-(void)updateFrame{
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    [_mImgaeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    
    _nameLabel.text=UserDefaultEntity.realName;
    _detalLabel.text=UserDefaultEntity.remark;
}

-(void)createTabelView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAccountDetailsCell" bundle:nil] forCellReuseIdentifier:@"accountCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"firstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDetailSecondCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDetailThirdCell" bundle:nil] forCellReuseIdentifier:@"thirdCell"];
    
    [self cleanTableView:_tableView];
    [self createHeadView];
}

- (void)promptAction {
    // 投资人首次进入, 提示更新资料
    UIWindow *myWindow = [[[UIApplication sharedApplication] delegate] window];
    promptView = [[UIView alloc] initWithFrame:myWindow.frame];
    promptView.backgroundColor = [UIColor blackColor];
    promptView.alpha = 0.7;
    [myWindow addSubview:promptView];
    lightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_new_light"]];
    lightView.frame = CGRectMake(84*SCREEN_WSCALE, 87*SCREEN_WSCALE, 62*SCREEN_WSCALE, 46*SCREEN_WSCALE);
    lightView.userInteractionEnabled = YES;
    [myWindow addSubview:lightView];
    promptImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_new_prompt"]];
    promptImage.frame = CGRectMake(lightView.right - 25*SCREEN_WSCALE, lightView.bottom - 25*SCREEN_WSCALE, 120*SCREEN_WSCALE, 180*SCREEN_WSCALE);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 87*SCREEN_WSCALE, 46*SCREEN_WSCALE);
    [lightView addSubview:button];
    [button addTarget:self action:@selector(updateInvestorInfo) forControlEvents:UIControlEventTouchUpInside];
    [myWindow addSubview:promptImage];
}
- (void)updateInvestorInfo {
    [promptView removeFromSuperview];
    [lightView removeFromSuperview];
    [promptImage removeFromSuperview];
    // 投资人更新资料
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
    
}
-(void)updateMenu{
    //投资人：2；合伙人3；
    style=[(NSNumber*)UserDefaultEntity.user_style integerValue];
    if (style == 2) {
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"isNoFirstRun"]boolValue]) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isNoFirstRun"];
            [self promptAction];
        }
        if ([IsInvestor isEqualToString:@"1"]){
            [_statusImageView setImage:[UIImage imageNamed:@"my_new_investor"]];
        }else if ([IsInvestor isEqualToString:@"0"]){
            [_statusImageView setImage:[UIImage imageNamed:@"my_new_authentication"]];
        }else if ([IsInvestor isEqualToString:@"2"]){
            [_statusImageView setImage:[UIImage imageNamed:@"my_new_authentication"]];
        }
        _statusImageView.userInteractionEnabled = YES;
        [_statusImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapheadImage:)]];
    } else if (style == 3) {
        [_statusImageView setImage:[UIImage imageNamed:@"my_new_partner"]];
        _statusImageView.userInteractionEnabled = YES;
        [_statusImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    }  else {
        [_statusImageView setImage:[UIImage imageNamed:@"my_new_authentication"]];
        _statusImageView.userInteractionEnabled = YES;
        [_statusImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    [self.tableView reloadData];
}

-(void)cleanTableView:(UITableView*)tableView{
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    _tableView.tableFooterView=view;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    
    CertificationVC *certifi = [[CertificationVC alloc]init];
    certifi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:certifi animated:NO];
}

- (void)tapImage:(UITapGestureRecognizer *)tap{
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
    
}


- (void)tapheadImage:(UITapGestureRecognizer *)tap{
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
}

-(void)createHeadView{

    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200*SCREEN_WSCALE)];
    _headerView.backgroundColor = TSEColor(110, 151, 245);
    _tableView.tableHeaderView=_headerView;
    
    _bgkImageView=[[UIImageView alloc]initWithFrame:_headerView.frame];
    [_bgkImageView setImage:[UIImage imageNamed:@"my_new_bg"]];
    //[_headerView addSubview:_bgkImageView];
    
    UIButton *setButton=[[UIButton alloc]initWithFrame:CGRectMake(15*SCREEN_WSCALE, 25*SCREEN_WSCALE, 18*SCREEN_WSCALE, 18*SCREEN_WSCALE)];
    [setButton setImage:[UIImage imageNamed:@"my_set"] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(mySet:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:setButton];

    UIButton *CertificationButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 88*SCREEN_WSCALE, 21*SCREEN_WSCALE, 90, 30)];
    if (ScreenWidth < 330) {
        [CertificationButton setFrame:CGRectMake(ScreenWidth - 100*SCREEN_WSCALE, 21*SCREEN_WSCALE, 90, 30)];
    }
    [CertificationButton setImage:[UIImage imageNamed:@"new_renz"] forState:UIControlStateNormal];
    [CertificationButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    [CertificationButton setTitle:@"实名认证" forState:UIControlStateNormal];
    CertificationButton.titleLabel.font = Font(13);
    [CertificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CertificationButton addTarget:self action:@selector(CertificationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:CertificationButton];
    
    UIView *imageV=[[UIView alloc]initWithFrame:CGRectMake(13*SCREEN_WSCALE, 60*SCREEN_WSCALE, 62*SCREEN_WSCALE, 62*SCREEN_WSCALE)];
    [imageV setBackgroundColor:[UIColor whiteColor]];
    imageV.layer.cornerRadius=imageV.height/2;
    [_headerView addSubview:imageV];
    
    UIImageView *jrImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, 96*SCREEN_WSCALE, 12*SCREEN_WSCALE, 12*SCREEN_WSCALE)];
    [jrImageView setImage:[UIImage imageNamed:@"my_jr"]];
    [_headerView addSubview:jrImageView];
    
    UILabel *detailLabel=[self createLabelFrame:CGRectMake(jrImageView.left - 53, jrImageView.top - 2*SCREEN_WHCALE, 53, 15*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(13) text:@"个人资料"];
    [_headerView addSubview:detailLabel];
    
    _mImgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(1*SCREEN_WSCALE, 1*SCREEN_WSCALE, 60*SCREEN_WSCALE, 60*SCREEN_WSCALE)];
    NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,UserDefaultEntity.headPath];
    _mImgaeView.layer.masksToBounds=YES;
    _mImgaeView.layer.cornerRadius=_mImgaeView.height/2;
    [_mImgaeView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    [imageV addSubview:_mImgaeView];
    
    _nameLabel=[self createLabelFrame:CGRectMake(imageV.right+10*SCREEN_WSCALE, 65*SCREEN_WSCALE, SCREEN_WIDTH-imageV.width-65*SCREEN_WSCALE, 16*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(16) text:UserDefaultEntity.realName];
    [_headerView addSubview:_nameLabel];
    
    _statusImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.left - 1, _nameLabel.bottom + 10*SCREEN_WSCALE, 64*SCREEN_WSCALE, 21*SCREEN_WSCALE)];
    [_headerView addSubview:_statusImageView];
    
    
    UIButton *updateInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    updateInfo.frame=CGRectMake(imageV.right+100*PMBWIDTH, imageV.top+15*PMBHEIGHT, SCREEN_WIDTH-150*SCREEN_WSCALE, imageV.height);
    [updateInfo addTarget:self action:@selector(updateMyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:updateInfo];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, imageV.bottom+30*SCREEN_WSCALE, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=TSEColor(157, 184, 248);
    line.alpha=0.8;
    [_headerView addSubview:line];
    
    CGFloat width=(SCREEN_WIDTH-2)/3;
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(width, line.bottom+15*SCREEN_WSCALE, 1, 20*SCREEN_WSCALE)];
    line2.backgroundColor=TSEColor(157, 184, 248);
    line2.alpha=0.8;
    [_headerView addSubview:line2];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(width*2+1, line.bottom+15*SCREEN_WSCALE, 1, 20*SCREEN_WSCALE)];
    line3.backgroundColor=TSEColor(157, 184, 248);
    line3.alpha=0.8;
    [_headerView addSubview:line3];
    
    UIView *fristView=[[UIView alloc]initWithFrame:CGRectMake(0, line.bottom, width, _headerView.height-line.bottom)];
    [_headerView addSubview:fristView];
    
    _dyCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(13) text:[_Countdict objectForKey:@"TCount"]];
    _dyCount.textAlignment=NSTextAlignmentCenter;
    [fristView addSubview:_dyCount];
    
    UILabel *dyLabel=[self createLabelFrame:CGRectMake(0, _dyCount.bottom+5*SCREEN_WSCALE, _dyCount.width, _dyCount.height) color:TSEColor(197, 215, 255) font:Font(13) text:@"动态"];
    dyLabel.textAlignment=NSTextAlignmentCenter;
    [fristView addSubview:dyLabel];
    
    UIButton *fristBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    fristBtn.frame=fristView.frame;
    fristBtn.tag=1;
    [fristBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:fristBtn];
    
    UIView *secordView=[[UIView alloc]initWithFrame:CGRectMake(width+1, fristView.top, width, fristView.height)];
    [_headerView addSubview:secordView];
    
    _careCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(13) text:[_Countdict objectForKey:@"PCount"]];
    _careCount.textAlignment=NSTextAlignmentCenter;
    [secordView addSubview:_careCount];
    
    UILabel *careLabel=[self createLabelFrame:CGRectMake(0, _careCount.bottom+5*SCREEN_WSCALE, _careCount.width, _careCount.height) color:TSEColor(197, 215, 255) font:Font(13) text:@"关注"];
    careLabel.textAlignment=NSTextAlignmentCenter;
    [secordView addSubview:careLabel];
    
    UIButton *secordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    secordBtn.frame=secordView.frame;
    secordBtn.tag=2;
    [secordBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:secordBtn];
    
    UIView *thridView=[[UIView alloc]initWithFrame:CGRectMake((width+1)*2, fristView.top, width, fristView.height)];
    [_headerView addSubview:thridView];
    
    _fensiCount=[self createLabelFrame:CGRectMake(0, 10*SCREEN_WSCALE, width, 14*SCREEN_WSCALE) color:[UIColor whiteColor] font:Font(14) text:[_Countdict objectForKey:@"FCount"]];
    _fensiCount.textAlignment=NSTextAlignmentCenter;
    [thridView addSubview:_fensiCount];
    
    UILabel *fensiLabel=[self createLabelFrame:CGRectMake(0, _fensiCount.bottom+5*SCREEN_WSCALE, _fensiCount.width, _fensiCount.height) color:TSEColor(197, 215, 255) font:Font(14) text:@"粉丝"];
    fensiLabel.textAlignment=NSTextAlignmentCenter;
    [thridView addSubview:fensiLabel];
    
    UIButton *thridBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    thridBtn.frame=thridView.frame;
    thridBtn.tag=3;
    [thridBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:thridBtn];
}

-(void)mySet:(id)sender {
    SetAppVC *setApp=[[SetAppVC alloc]init];
    setApp.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setApp animated:NO];
}

- (void)CertificationButtonAction{
    
    AddCertificationVC *AddCertification = [[AddCertificationVC alloc]init];
    AddCertification.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:AddCertification animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (status==0) {
            return 0;
        }else if (status==1){
            return 90*SCREEN_WSCALE;
        }
    }else if(indexPath.section==1) {
        return 160*SCREEN_WSCALE;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (status==0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (status==1){
            MyAccountDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
            cell.currencyNumberLabel.text = _currencyNumber;// 创业币
            cell.couponNumberLabel.text = _couponNumber;// 优惠券
            cell.integralNumberLabel.text = _integralNumber;// 积分
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section==1){
        if (style == 2) {//投资人：2；合伙人3；
            if ([IsInvestor isEqualToString:@"1"]) {

                MyDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdCell" forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            }else{
                MyDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
                cell.delegate = self;
                return cell;

            }
        } else if (style == 3) {
            MyDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;

        }  else {
            MyDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
    }
    return nil;
}

#pragma mark - MyDetailCellDelegate
- (void)clickTheAccountButton:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            // 创业币
            MoneyVC *money = [[MoneyVC alloc]init];
            money.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:money animated:YES];
        }
            break;
        case 101:
        {
            // 优惠券
            MyCouponVC *mycouponVC = [[MyCouponVC alloc]init];
            mycouponVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mycouponVC animated:YES];
        }
            break;
        case 102:
        {
            // 积分
            MyIntegralVC *integralVC = [[MyIntegralVC alloc]init];
            integralVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:integralVC animated:YES];
        }
            break;
        default:
            break;
    }
}
// 创客
- (void)clickTheFirstButton:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            // 我的订单
            MyOrderListVC *orderList=[[MyOrderListVC alloc]init];
            orderList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderList animated:YES];
        }
            break;
        case 101:
        {
            // 我的预约
            MyAppointVC *myappoint=[[MyAppointVC alloc]init];
            myappoint.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myappoint animated:YES];
        }
            break;
        case 102:
        {
            // 我的活动
            MyActivityVC *activity = [[MyActivityVC alloc]init];
            activity.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activity animated:YES];
        }
            break;
        case 103:
        {
            // 报名凭证
            CertificateViewController *cer = [[CertificateViewController alloc]init];
            cer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cer animated:YES];
        }
            break;
        case 104:
        {
            // 邀请有奖
            InviteVC *invite = [[InviteVC alloc]init];
            invite.hidesBottomBarWhenPushed = YES;
            invite.fcount = fcount;
            invite.scount = scount;
            invite.integral = integral;
            [self.navigationController pushViewController:invite animated:YES];
        }
            break;
        case 105:
        {
            // 在线客服
            MyChatViewController *myChat=[[MyChatViewController alloc]init];
            myChat.conversationType=ConversationType_PRIVATE;
            myChat.targetId=@"30bad6c8-88ab-4d82-967c-1764a91acc9e";
            myChat.title = @"在线客服";
            myChat.type=1;
            myChat.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myChat animated:YES];

        }
            break;
        case 106:
        {
            // 电话服务
            [self callPhone];
        }
            break;
        default:
            break;
    }

}
// 合伙人
- (void)clickTheSecondButton:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            // 我的订单
            MyOrderListVC *orderList=[[MyOrderListVC alloc]init];
            orderList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderList animated:YES];
        }
            break;
        case 101:
        {
            // 我的项目
            MyProjectVC *project = [[MyProjectVC alloc]init];
            project.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:project animated:YES];
        }
            break;
        case 102:
        {
            // 我的预约
            MyAppointVC *myappoint=[[MyAppointVC alloc]init];
            myappoint.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myappoint animated:YES];
        }
            break;
        case 103:
        {
            // 我的活动
            MyActivityVC *activity = [[MyActivityVC alloc]init];
            activity.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activity animated:YES];
        }
            break;
        case 104:
        {
            // 报名凭证
            CertificateViewController *cer = [[CertificateViewController alloc]init];
            cer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cer animated:YES];
        }
            break;
        case 105:
        {
            // 邀请有奖
            InviteVC *invite = [[InviteVC alloc]init];
            invite.hidesBottomBarWhenPushed = YES;
            invite.fcount = fcount;
            invite.scount = scount;
            invite.integral = integral;
            [self.navigationController pushViewController:invite animated:YES];
        }
            break;
        case 106:
        {
            // 在线客服
            MyChatViewController *myChat=[[MyChatViewController alloc]init];
            myChat.conversationType=ConversationType_PRIVATE;
            myChat.targetId=@"30bad6c8-88ab-4d82-967c-1764a91acc9e";
            myChat.title = @"在线客服";
            myChat.type=1;
            myChat.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myChat animated:YES];

        }
            break;
        case 107:
        {
            // 电话服务
            [self callPhone];
        }
            break;
        default:
            break;
    }
    
}
// 投资人
- (void)clickTheThirdButton:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            // 我的订单
            MyOrderListVC *orderList=[[MyOrderListVC alloc]init];
            orderList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderList animated:YES];
        }
            break;
        case 101:
        {
            // 投递项目
            MyInvestVC *myInvest=[[MyInvestVC alloc]init];
            myInvest.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myInvest animated:YES];
        }
            break;
        case 102:
        {
            // 我的预约
            MyAppointVC *myappoint=[[MyAppointVC alloc]init];
            myappoint.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myappoint animated:YES];
        }
            break;
        case 103:
        {
            // 我的活动
            MyActivityVC *activity = [[MyActivityVC alloc]init];
            activity.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activity animated:YES];
        }
            break;
        case 104:
        {
            // 报名凭证
            CertificateViewController *cer = [[CertificateViewController alloc]init];
            cer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cer animated:YES];
        }
            break;
        case 105:
        {
            // 邀请有奖
            InviteVC *invite = [[InviteVC alloc]init];
            invite.hidesBottomBarWhenPushed = YES;
            invite.fcount = fcount;
            invite.scount = scount;
            invite.integral = integral;
            [self.navigationController pushViewController:invite animated:YES];
        }
            break;
        case 106:
        {
            // 在线客服
            MyChatViewController *myChat=[[MyChatViewController alloc]init];
            myChat.conversationType=ConversationType_PRIVATE;
            myChat.targetId=@"30bad6c8-88ab-4d82-967c-1764a91acc9e";
            myChat.title = @"在线客服";
            myChat.type=1;
            myChat.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myChat animated:YES];

        }
            break;
        case 107:
        {
            // 电话服务
            [self callPhone];
        }
            break;
        default:
            break;
    }
    
}

-(void)updateMyInfo:(id)sender{
    //投资人：2；合伙人3；
    if(style==2){
        if ([IsInvestor isEqualToString:@"2"]) {
            MakersVC *maker = [[MakersVC alloc]init];
            maker.hidesBottomBarWhenPushed = YES;
            maker.Guid = UserDefaultEntity.uuid;
            [self.navigationController pushViewController:maker animated:YES];
        }else{
            ParntDetailVC *parnt = [[ParntDetailVC alloc]init];
            parnt.hidesBottomBarWhenPushed = YES;
            parnt.Guid = UserDefaultEntity.uuid;
            [self.navigationController pushViewController:parnt animated:YES];
        }
    }else if(style==3){
        QchpartnerVC *partner = [[QchpartnerVC alloc]init];
        partner.hidesBottomBarWhenPushed = YES;
        partner.Guid = UserDefaultEntity.uuid;
        [self.navigationController pushViewController:partner animated:YES];
    }else{
        MakersVC *maker = [[MakersVC alloc]init];
        maker.hidesBottomBarWhenPushed = YES;
        maker.Guid = UserDefaultEntity.uuid;
        [self.navigationController pushViewController:maker animated:YES];
    }
}

-(void)callPhone{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",@"4001690999"];
    UIWebView *callWebview =[[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

-(void)selectBtn:(UIButton*)sender{
    
    UIButton *button=(UIButton*)sender;

    NSInteger index=button.tag;;
    
    if (index==1) {
        MyDynamicVC *dynamic = [[MyDynamicVC alloc]init];
        dynamic.hidesBottomBarWhenPushed=YES;
        dynamic.title = @"我的动态";
        [self.navigationController pushViewController:dynamic animated:YES];
    }else if (index==2){
        MyCollectVC *collect = [[MyCollectVC alloc]init];
        collect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collect animated:YES];
    }else if (index==3){
        CarePersonListVC *care = [[CarePersonListVC alloc]init];
        care.type = 4;
        care.title = @"我的粉丝";
        care.model = [_fanslist mutableCopy];
        care.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:care animated:YES];
    }

}

//是否审核
-(void)ifAuditStatus {
    [HttpLoginAction OnOffTravel:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            status=[(NSNumber*)[dict objectForKey:@"result"]integerValue];
        }
    }];
}
//判断是不是投资人
- (void)GetIsInvestor{
    [HttpProjectAction GetIsInvestor:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            IsInvestor = [dict objectForKey:@"result"];
        }
        [self.tableView reloadData];
    }];
}

//查询个人中心个数
- (void)getData{
    
    [HttpCenterAction GetUserCenterCount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array = (NSArray*)[dict objectForKey:@"result"];
            if ([array count]>0) {
                _Countdict=[array objectAtIndex:0];
                _dyCount.text=[_Countdict objectForKey:@"TCount"];// 动态
                _careCount.text=[_Countdict objectForKey:@"PCount"];// 关注
                _fensiCount.text=[_Countdict objectForKey:@"FCount"];// 粉丝
                self.currencyNumber = [_Countdict objectForKey:@"ACount"];// 创业币
                self.couponNumber = [_Countdict objectForKey:@"VCount"];// 优惠券
                self.integralNumber = [_Countdict objectForKey:@"ICount"];// 积分
            }
            
            [_tableView reloadData];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
        }
    }];
}

//查询我关注人数
- (void)GetPraiseUser{
    
    [HttpCenterAction GetPraiseUser:UserDefaultEntity.uuid type:-1 Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _funlist = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _funlist = [[NSMutableArray alloc]init];

        }else{
            _funlist = [[NSMutableArray alloc]init];

        }
    }];
}

//查询粉丝数
- (void)GetUserFuns {
    
    [HttpCenterAction GetUserFuns:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            _fanslist = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            _fanslist = [[NSMutableArray alloc]init];
        }else{
            _fanslist = [[NSMutableArray alloc]init];

        }
    }];
}

//获取邀请好友
- (void)GetInviteUser{
    [HttpCenterAction GetInviteUser:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            fcount = [dict objectForKey:@"fcount"];
            scount = [dict objectForKey:@"scount"];
            integral = [dict objectForKey:@"integral"];
        }
    }];
}

- (NSString*)encodeURL:(NSString *)string{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}
@end
