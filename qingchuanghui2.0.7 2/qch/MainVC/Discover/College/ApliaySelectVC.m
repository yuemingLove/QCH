//
//  ApliaySelectVC.m
//  qch
//
//  Created by 青创汇 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ApliaySelectVC.h"
#import "ActivityPayVC.h"
@interface ApliaySelectVC (){
    
    UIButton *Offline;
    UIButton *Online;
    UILabel *Informationlab;
    UIButton *selectedbtn;
    UILabel *moneylab;
    
}

@end

@implementation ApliaySelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"众筹";
    [self creatframe];
    
}

- (void)creatframe
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*PMBWIDTH)];
    title.text = @"   选择授课类型";
    title.backgroundColor = [UIColor themeGrayColor];
    title.textColor = [UIColor lightGrayColor];
    title.font = Font(15);
    [self.view addSubview:title];
    
    UIImageView *offlineimg = [[UIImageView alloc]initWithFrame:CGRectMake(50*PMBWIDTH, title.bottom+10*PMBWIDTH, 30*PMBWIDTH, 30*PMBWIDTH)];
    offlineimg.image = [UIImage imageNamed:@"现场"];
    [self.view addSubview:offlineimg];
    
    UILabel *offlinelab = [[UILabel alloc]initWithFrame:CGRectMake(offlineimg.right+10*PMBWIDTH, offlineimg.top+8*PMBWIDTH, 100*PMBWIDTH, 14*PMBWIDTH)];
    offlinelab.text = @"现场听课";
    offlinelab.textColor = [UIColor blackColor];
    offlinelab.font = Font(14);
    [self.view addSubview:offlinelab];
    
    UILabel *offremark = [[UILabel alloc]initWithFrame:CGRectMake(offlineimg.left, offlineimg.bottom+5*PMBWIDTH, 300*PMBWIDTH, 14*PMBWIDTH)];
    offremark.textColor = [UIColor lightGrayColor];
    offremark.font = Font(14);
    offremark.text = _Street;
    [self.view addSubview:offremark];
    
    
    Offline = [UIButton buttonWithType:UIButtonTypeCustom];
    Offline.frame = CGRectMake(0, title.bottom, ScreenWidth, 67*PMBWIDTH);
    [Offline setImage:[UIImage imageNamed:@"huodong_wxz_btn"] forState:UIControlStateNormal];
    [Offline setImage:[UIImage imageNamed:@"huodong_xz_btn"] forState:UIControlStateSelected];
    Offline.imageEdgeInsets = UIEdgeInsetsMake(12*PMBWIDTH, 10*PMBWIDTH, 30*PMBWIDTH, ScreenWidth-40*PMBWIDTH);
    Offline.tag = 1000;
    if ([_offlinemoney isEqualToString:@"0"]) {
        [Offline addTarget:selectedbtn action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [Offline addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:Offline];
    
    UIImageView *onlineimg = [[UIImageView alloc]initWithFrame:CGRectMake(offlineimg.left, Offline.bottom+15*PMBWIDTH, offlineimg.width, offlineimg.height)];
    onlineimg.image = [UIImage imageNamed:@"在线"];
    [self.view addSubview:onlineimg];
    
    UILabel *onlinelab = [[UILabel alloc]initWithFrame:CGRectMake(onlineimg.right+10*PMBWIDTH, onlineimg.top+8*PMBWIDTH, 100*PMBWIDTH, 14*PMBWIDTH)];
    onlinelab.text = @"在线直播";
    onlinelab.textColor = [UIColor blackColor];
    onlinelab.font = Font(14);
    [self.view addSubview:onlinelab];
    
    Online = [UIButton buttonWithType:UIButtonTypeCustom];
    Online.frame = CGRectMake(0, Offline.bottom+5*PMBWIDTH, ScreenWidth, Offline.height);
    [Online setImage:[UIImage imageNamed:@"huodong_wxz_btn"] forState:UIControlStateNormal];
    [Online setImage:[UIImage imageNamed:@"huodong_xz_btn"] forState:UIControlStateSelected];
    Online.imageEdgeInsets = UIEdgeInsetsMake(12*PMBWIDTH, 10*PMBWIDTH, 30*PMBWIDTH, ScreenWidth-40*PMBWIDTH);
    if ([_onlinemoney isEqualToString:@"0"]) {
        [Online addTarget:self action:@selector(selec:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [Online addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    Online.tag = 1001;
    [self.view addSubview:Online];
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, Online.bottom, ScreenWidth, title.height)];
    subtitle.text = @"  众筹说明";
    subtitle.backgroundColor = [UIColor themeGrayColor];
    subtitle.textColor = [UIColor lightGrayColor];
    subtitle.font = Font(15);
    [self.view addSubview:subtitle];
    
    
    Informationlab = [[UILabel alloc]initWithFrame:CGRectMake(20, subtitle.bottom+10*PMBWIDTH, ScreenWidth-20*PMBWIDTH, 60*PMBWIDTH)];
    Informationlab.textColor = [UIColor lightGrayColor];
    Informationlab.font = Font(14);
    Informationlab.numberOfLines = 0;
    [self.view addSubview:Informationlab];
    
    if ([_offlinemoney isEqualToString:@"0"]) {
        [self selectedAction:Online];
    }else if ([_onlinemoney isEqualToString:@"0"]){
        [self selectedAction:Offline];
    }else{
        [self selectedAction:Offline];
    }
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Informationlab.bottom+10*PMBWIDTH, ScreenWidth, ScreenHeight-Informationlab.bottom-10*PMBWIDTH)];
    view.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:view];
    
    UILabel *moneyLabel=[self createLabelFrame:CGRectMake(10, 10*PMBWIDTH, ScreenWidth/2-10, 20*PMBWIDTH) color:[UIColor blackColor] font:Font(14) text:@"需支付金额:"];
    moneyLabel.textAlignment=NSTextAlignmentRight;
    [view addSubview:moneyLabel];
    
    moneylab = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right, moneyLabel.top, moneyLabel.width, moneyLabel.height)];
    moneylab.textColor = [UIColor redColor];
    moneylab.textAlignment = NSTextAlignmentLeft;
    moneylab.font = Font(14);
    if ([_onlinemoney isEqualToString:@"0"]) {
        moneylab.text = [NSString stringWithFormat:@"¥%@",_offlinemoney];
    }else if ([_offlinemoney isEqualToString:@"0"]){
        moneylab.text = [NSString stringWithFormat:@"¥%@",_onlinemoney];
    }else{
        moneylab.text = [NSString stringWithFormat:@"¥%@",_offlinemoney];
    }
    [view addSubview:moneylab];
    
    
    UIButton *surebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame = CGRectMake(15*PMBWIDTH, moneylab.bottom+20*PMBWIDTH, ScreenWidth-30*PMBWIDTH, 30*PMBWIDTH);
    [surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebtn.titleLabel.font = Font(15);
    surebtn.layer.masksToBounds=YES;
    surebtn.layer.cornerRadius=5;
    surebtn.backgroundColor = [UIColor themeBlueColor];
    [surebtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:surebtn];
}

- (void)selected:(UIButton *)sender
{
    [Utils showAlertView:@"温馨提示" :@"该课程只支持在线播放" :@"我知道了"];
}

- (void)selec:(UIButton *)sender
{
    [Utils showAlertView:@"温馨提示" :@"该课程只支持现场听课" :@"我知道了"];
}



- (void)selectedAction:(UIButton*)sender
{
        if (sender!=selectedbtn) {
            selectedbtn.selected=NO;
            selectedbtn = sender;
        }
        selectedbtn.selected=YES;
    
    if (Offline.selected==YES) {
        Informationlab.text = @"线下：导师零距离接触，诊断创业难题，企业家交流互动，扩展事业人脉。\n线上：移动课程，学习业务两不误，也有机会获得线下导师答疑。";
        moneylab.text = [NSString stringWithFormat:@"¥%@",_offlinemoney];
    }else{
        Informationlab.text = @"现场听课：移动课程，学习业务两不误，也有机会获得线下导师答疑。\n在线直播：移动课程，学习业务两不误，也有机会获得线下导师答疑。";
        moneylab.text = [NSString stringWithFormat:@"¥%@",_onlinemoney];
    }

    
}

- (void)sureAction:(UIButton *)sender
{
    NSString *money = @"";
    if (Offline.selected==YES) {
        money = _offlinemoney;
    }else{
        money = _onlinemoney;
    }
        NSString *payType=@"";
        [SVProgressHUD showWithStatus:@"加载中…" maskType:SVProgressHUDMaskTypeBlack];
        [HttpAlipayAction AddOrder:_guid userGuid:UserDefaultEntity.uuid ordertype:3 paytype:payType money:money name:_titlestr remark:_titlestr Token:[MyAes aesSecretWith:@"associateGuid"] complete:^(id result, NSError *error) {
    
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            NSDictionary *dict=result[0];
            if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
                NSDictionary *param=[dict objectForKey:@"result"][0];
    
                NSString *orderNum=[param objectForKey:@"t_Order_No"];
    
                ActivityPayVC *activityPay=[[ActivityPayVC alloc]init];
                activityPay.price=[(NSNumber*)money floatValue];
                activityPay.titlestr=_titlestr;
                activityPay.orderNum=orderNum;
                activityPay.type=1;
    
                [self.navigationController pushViewController:activityPay animated:YES];
            }
        }];

}

@end
