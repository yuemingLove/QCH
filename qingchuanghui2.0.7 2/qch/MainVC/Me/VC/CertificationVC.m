//
//  CertificationVC.m
//  qch
//
//  Created by 青创汇 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CertificationVC.h"
#import "PersonInfomationVC.h"
#import "InvestorsInformationVC.h"
@interface CertificationVC ()

@end

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证身份";
    [self creatView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)creatView
{
    UIButton *partnerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    partnerBtn.frame = CGRectMake(20*PMBWIDTH, 80*PMBWIDTH, ScreenWidth/2-40*PMBWIDTH, ScreenWidth/2-40*PMBWIDTH);
    partnerBtn.layer.cornerRadius = partnerBtn.height/2;
    partnerBtn.layer.masksToBounds = YES;
    [partnerBtn setImage:[UIImage imageNamed:@"chengweihehuoren_btn"] forState:UIControlStateNormal];
    [partnerBtn addTarget:self action:@selector(partnerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:partnerBtn];
    
    UILabel *partnerlab = [[UILabel alloc]initWithFrame:CGRectMake(partnerBtn.left, partnerBtn.bottom, partnerBtn.width, 15*PMBWIDTH)];
    partnerlab.text = @"合伙人";
    partnerlab.textAlignment = NSTextAlignmentCenter;
    partnerlab.textColor = [UIColor blackColor];
    partnerlab.font = Font(15);
    [self.view addSubview:partnerlab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, partnerBtn.top+40*PMBWIDTH, 1, 40*PMBWIDTH)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UIButton *investorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    investorBtn.frame = CGRectMake(line.right+20*PMBWIDTH, partnerBtn.top, partnerBtn.width, partnerBtn.height);
    investorBtn.layer.cornerRadius = investorBtn.height/2;
    investorBtn.layer.masksToBounds = YES;
    [investorBtn setImage:[UIImage imageNamed:@"chengweitouziren_btn"] forState:UIControlStateNormal];
    [investorBtn addTarget:self action:@selector(investorAciton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:investorBtn];
    
    UILabel *investorlab = [[UILabel alloc]initWithFrame:CGRectMake(investorBtn.left, investorBtn.bottom, investorBtn.width, partnerlab.height)];
    investorlab.text = @"投资人";
    investorlab.textColor = [UIColor blackColor];
    investorlab.font = Font(15);
    investorlab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:investorlab];
    
    UILabel *informationlab = [[UILabel alloc]initWithFrame:CGRectMake(partnerBtn.left-5*PMBWIDTH, partnerlab.bottom+20*PMBWIDTH, ScreenWidth-2*(partnerBtn.left-5*PMBWIDTH), 30*PMBWIDTH)];
    informationlab.numberOfLines = 2;
    informationlab.textColor = [UIColor lightGrayColor];
    informationlab.text = @"认证身份后将被准确推荐给匹配的用户、高效遇见最合适的投资人和创业者。";
    informationlab.font = Font(13);
    [self.view addSubview:informationlab];
}

- (void)partnerAction:(UIButton *)sender
{
    
    if ([UserDefaultEntity.user_style isEqualToString:@"3"]) {
    
        [SVProgressHUD showErrorWithStatus:@"您已经是合伙人了" maskType:SVProgressHUDMaskTypeBlack];
    }else{
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
}

- (void)investorAciton:(UIButton *)sender
{
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

@end
