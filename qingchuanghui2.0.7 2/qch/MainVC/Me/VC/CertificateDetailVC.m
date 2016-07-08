//
//  CertificateDetailVC.m
//  qch
//
//  Created by 青创汇 on 16/4/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CertificateDetailVC.h"
#import "ActivityDetailVC.h"
@interface CertificateDetailVC (){
    UILabel *Namelab;
    UILabel *Numberlab;
    UIImageView *Brcodeimg;
    UILabel *feelab;
    UILabel *ActivityDate;
    UILabel *Addr;
    UILabel *Holder;
    UILabel *ApplyUserName;
    NSString *activityguid;
    
}

@property (weak, nonatomic) UITableView *tableListView;

@end

@implementation CertificateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报名凭证";
    self.view.backgroundColor = [UIColor themeGrayColor];
    [self creatview];
    [self getData];

}

- (void)creatview
{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, ScreenWidth-20*PMBWIDTH, 370*PMBWIDTH)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20*PMBWIDTH, 240*PMBWIDTH)];
    headerview.backgroundColor = TSEColor(2, 153, 232);
    [backview addSubview:headerview];
    
    UIImageView *headerimg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20*PMBWIDTH, 10*PMBWIDTH)];
    headerimg.image = [UIImage imageNamed:@"hor"];
    [headerview addSubview:headerimg];
    
    Namelab = [[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, headerimg.bottom+15*PMBWIDTH, ScreenWidth-30*PMBWIDTH, 35*PMBWIDTH)];
    Namelab.font = Font(15);
    Namelab.textColor = [UIColor whiteColor];
    Namelab.numberOfLines = 0;
    Namelab.textAlignment = NSTextAlignmentCenter;
    [headerview addSubview:Namelab];
    
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(4*PMBWIDTH, Namelab.bottom+10*PMBWIDTH, ScreenWidth-28*PMBWIDTH, 1*PMBWIDTH)];
    linelab.backgroundColor = [UIColor whiteColor];
    [headerview addSubview:linelab];
    
    UILabel *numlab = [[UILabel alloc]initWithFrame:CGRectMake(0, linelab.bottom+10*PMBWIDTH, (ScreenWidth-80*PMBWIDTH)/2, 13*PMBWIDTH)];
    numlab.text = @"数字码:";
    numlab.textColor = [UIColor whiteColor];
    numlab.font = Font(13);
    numlab.textAlignment = NSTextAlignmentRight;
    [headerview addSubview:numlab];
    
    Numberlab = [[UILabel alloc]initWithFrame:CGRectMake(numlab.right+5*PMBWIDTH, numlab.top, numlab.width, 15*PMBWIDTH)];
    Numberlab.textColor = [UIColor whiteColor];
    Numberlab.font = Font(15);
    Numberlab.textAlignment = NSTextAlignmentLeft;
    [headerview addSubview:Numberlab];
    
    Brcodeimg = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-140)/2, Numberlab.bottom+10*PMBWIDTH, 100*PMBWIDTH, 100*PMBWIDTH)];
    Brcodeimg.backgroundColor = [UIColor whiteColor];
    [headerview addSubview:Brcodeimg];
    
    feelab = [[UILabel alloc]initWithFrame:CGRectMake(Brcodeimg.left, Brcodeimg.bottom+10*PMBWIDTH, Brcodeimg.width, 14*PMBWIDTH)];
    feelab.textColor = [UIColor whiteColor];
    feelab.font = Font(14);
    feelab.text = @"免费";
    feelab.textAlignment = NSTextAlignmentCenter;
    [headerview addSubview:feelab];
    
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(6*PMBWIDTH, headerview.bottom+10*PMBWIDTH, 48*PMBWIDTH, 12*PMBWIDTH)];
    timelab.text = @"活动时间:";
    timelab.font = Font(12);
    timelab.textColor = [UIColor lightGrayColor];
    [backview addSubview:timelab];
    
    ActivityDate = [[UILabel alloc]initWithFrame:CGRectMake(timelab.right, timelab.top, ScreenWidth-20*PMBWIDTH-timelab.right, 12*PMBWIDTH)];
    ActivityDate.textColor = [UIColor blackColor];
    ActivityDate.font = Font(12);
    [backview addSubview:ActivityDate];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(timelab.left, timelab.bottom+10*PMBWIDTH, ScreenWidth-26*PMBWIDTH, 1*PMBWIDTH)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [backview addSubview:line1];
    
    UILabel *addlab = [[UILabel alloc]initWithFrame:CGRectMake(timelab.left, line1.bottom+10*PMBWIDTH, timelab.width, timelab.height)];
    addlab.textColor = [UIColor lightGrayColor];
    addlab.text = @"活动地点:";
    addlab.font = Font(12);
    [backview addSubview:addlab];
    
    Addr = [[UILabel alloc]initWithFrame:CGRectMake(ActivityDate.left, addlab.top, ActivityDate.width, ActivityDate.height)];
    Addr.textColor = [UIColor blackColor];
    Addr.font = Font(12);
    [backview addSubview:Addr];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(line1.left, Addr.bottom+10*PMBWIDTH, line1.width, 1*PMBWIDTH)];
    line2.backgroundColor = [UIColor themeGrayColor];
    [backview addSubview:line2];
    
    UILabel *holderlab = [[UILabel alloc]initWithFrame:CGRectMake(addlab.left, line2.bottom+10*PMBWIDTH, 40*PMBWIDTH, 12*PMBWIDTH)];
    holderlab.text = @"主办方:";
    holderlab.textColor = [UIColor lightGrayColor];
    holderlab.font = Font(12);
    [backview addSubview:holderlab];
    
    Holder = [[UILabel alloc]initWithFrame:CGRectMake(holderlab.right, holderlab.top, Addr.width, Addr.height)];
    Holder.textColor = [UIColor blackColor];
    Holder.font = Font(12);
    [backview addSubview:Holder];
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(holderlab.left, holderlab.bottom+10*PMBWIDTH, line2.width, line2.height)];
    line3.backgroundColor = [UIColor themeGrayColor];
    [backview addSubview:line3];
    
    UILabel *applylab = [[UILabel alloc]initWithFrame:CGRectMake(holderlab.left, line3.bottom+10*PMBWIDTH, holderlab.width, timelab.height)];
    applylab.textColor = [UIColor lightGrayColor];
    applylab.text = @"报名人:";
    applylab.font = Font(12);
    [backview addSubview:applylab];
    
    ApplyUserName = [[UILabel alloc]initWithFrame:CGRectMake(applylab.right, applylab.top, ScreenWidth-applylab.right-10*PMBWIDTH, Holder.height)];
    ApplyUserName.textColor = [UIColor blackColor];
    ApplyUserName.font = Font(12);
    ApplyUserName.lineBreakMode = NSLineBreakByCharWrapping;
    [backview addSubview:ApplyUserName];
    
    UIButton *ActivityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ActivityBtn.frame = CGRectMake(ScreenWidth/2-50*PMBWIDTH, backview.bottom+10*PMBWIDTH, 100*PMBWIDTH, 30*PMBWIDTH);
    [ActivityBtn setTitle:@"查看活动" forState:UIControlStateNormal];
    ActivityBtn.titleLabel.font = Font(15);
    ActivityBtn.backgroundColor = TSEColor(2, 153, 232);
    ActivityBtn.layer.cornerRadius = 5.0f;
    [ActivityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ActivityBtn addTarget:self action:@selector(activityaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ActivityBtn];
    
    
}

- (void)getData{
    
    [HttpActivityAction GetMyApplyView:_ApplyGuid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic = [dict objectForKey:@"result"][0];
            Namelab.text = [dic objectForKey:@"t_Activity_Title"];
        if ([self isBlankString:[dic objectForKey:@"t_ProofCode"]]) {
            Numberlab.text = @"*************";
        }else{
            Numberlab.text = [dic objectForKey:@"t_ProofCode"];
        }
        if ([self isBlankString:[dic objectForKey:@"t_QrCode"]]) {
            Brcodeimg.image = [UIImage imageNamed:@"nopingzheng"];
        }else{

            NSString *str = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dic objectForKey:@"t_QrCode"]];
            [Brcodeimg sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        }
        if ([[dic objectForKey:@"t_Activity_Fee"] floatValue]==0) {
            feelab.text = [dic objectForKey:@"t_Activity_FeeType"];
        }else{
            feelab.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"t_Activity_Fee"]];
        }
        NSDate *time = [DateFormatter stringToDateCustom:[dic objectForKey:@"t_Activity_sDate"] formatString:def_YearMonthDayHourMinuteSec_DF];
        NSString *date = [DateFormatter dateToStringCustom:time formatString:def_YearMonthDayHourMinuteSec_];
        ActivityDate.text = date;
            Addr.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"t_Activity_CityName"],[dic objectForKey:@"t_Activity_Street"]];
        Holder.text = [dic objectForKey:@"t_Activity_Holder"];
        ApplyUserName.text = [NSString stringWithFormat:@"%@ （%@）",[dic objectForKey:@"ApplyUserRealName"],[dic objectForKey:@"t_Activity_Tel"]];
        activityguid = [dic objectForKey:@"t_Activity_Guid"];

        }else if ([[dict objectForKey:@"state"]isEqualToString:@"false"]){
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            
        }
    }];

}

- (void)activityaction:(UIButton *)sender
{
    ActivityDetailVC *activity = [[ActivityDetailVC alloc]init];
    activity.guid = activityguid;
    [self.navigationController pushViewController:activity animated:YES];
}


@end
