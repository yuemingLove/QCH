//
//  InviteDetailsVC.m
//  qch
//
//  Created by 青创汇 on 16/5/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InviteDetailsVC.h"

@interface InviteDetailsVC ()
{
    UILabel *Namelab;
    UILabel *Numlab;
    UILabel *Rewardslab;
    UILabel *PersonNumlab;
    UILabel *Timelab;
}

@end

@implementation InviteDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请明细";
    [self creatmainview];
    [self getdata];
}

- (void)creatmainview
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40*PMBWIDTH)];
    [self.view addSubview:view1];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, view1.bottom-1*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [view1 addSubview:line1];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(15*PMBWIDTH, 12*PMBWIDTH, 15*PMBWIDTH, 15*PMBWIDTH)];
    image1.image = [UIImage imageNamed:@"mingxi_ninchen_img"];
    [view1 addSubview:image1];
    
    UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(image1.right+3*PMBWIDTH, image1.top, 30*PMBWIDTH, 15*PMBWIDTH)];
    namelab.text = @"昵称";
    namelab.font = Font(14);
    namelab.textColor = [UIColor blackColor];
    [view1 addSubview:namelab];
    
    Namelab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-115*PMBWIDTH, namelab.top, 100*PMBWIDTH, 15*PMBWIDTH)];
    Namelab.textAlignment = NSTextAlignmentRight;
    Namelab.font = Font(14);
    Namelab.textColor = [UIColor blackColor];
    [view1 addSubview:Namelab];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom, ScreenWidth, view1.height)];
    [self.view addSubview:view2];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.top, ScreenWidth, 1*PMBWIDTH)];
    line2.backgroundColor = [UIColor themeGrayColor];
    [view2 addSubview:line2];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.left, 12*PMBWIDTH, image1.width, image1.height)];
    image2.image = [UIImage imageNamed:@"mingxi_zhanghao_img"];
    [view2 addSubview:image2];
    
    UILabel *numlab = [[UILabel alloc]initWithFrame:CGRectMake(image2.right+3*PMBWIDTH, image2.top, namelab.width, namelab.height)];
    numlab.text= @"账号";
    numlab.textColor = [UIColor blackColor];
    numlab.font = Font(14);
    [view2 addSubview:numlab];
    
    Numlab = [[UILabel alloc]initWithFrame:CGRectMake(Namelab.left, image2.top, Namelab.width, Namelab.height)];
    Numlab.font = Font(14);
    Numlab.textAlignment = NSTextAlignmentRight;
    Numlab.textColor = [UIColor blackColor];
    [view2 addSubview:Numlab];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.bottom, ScreenWidth, view1.height)];
    [self.view addSubview:view3];
    
    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.top, ScreenWidth, 1*PMBWIDTH)];
    line3.backgroundColor = [UIColor themeGrayColor];
    [view3 addSubview:line3];
    
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.left, 12*PMBWIDTH, image1.width, image1.height)];
    image3.image = [UIImage imageNamed:@"mingxi_yaoqingjiangli_img"];
    [view3 addSubview:image3];
    
    UILabel *rewardslab = [[UILabel alloc]initWithFrame:CGRectMake(image3.right+3*PMBWIDTH, image3.top, 60*PMBWIDTH, namelab.height)];
    rewardslab.text = @"邀请奖励";
    rewardslab.textColor = [UIColor blackColor];
    rewardslab.font = Font(14);
    [view3 addSubview:rewardslab];
    
    Rewardslab = [[UILabel alloc]initWithFrame:CGRectMake(Namelab.left, image3.top, Namelab.width, Namelab.height)];
    Rewardslab.textColor = TSEColor(162, 201, 240);
    Rewardslab.font = Font(14);
    Rewardslab.textAlignment = NSTextAlignmentRight;
    [view3 addSubview:Rewardslab];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.bottom, ScreenWidth, view1.height)];
    [self.view addSubview:view4];
    
    UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(0, line1.bottom, ScreenWidth, 1*PMBWIDTH)];
    line4.backgroundColor = [UIColor themeGrayColor];
    [view4 addSubview:line4];
    
    UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.left,12*PMBWIDTH, image1.width, image1.height)];
    image4.image = [UIImage imageNamed:@"mingxi_yaoqingrenshu_img"];
    [view4 addSubview:image4];
    
    UILabel *person = [[UILabel alloc]initWithFrame:CGRectMake(rewardslab.left, image4.top, rewardslab.width, rewardslab.height)];
    person.text = @"邀请人数";
    person.textColor = [UIColor blackColor];
    person.font = Font(14);
    [view4 addSubview:person];
    
    PersonNumlab = [[UILabel alloc]initWithFrame:CGRectMake(Rewardslab.left, image4.top, Rewardslab.width, Rewardslab.height)];
    PersonNumlab.textColor = TSEColor(162, 201, 240);
    PersonNumlab.font = Font(14);
    PersonNumlab.textAlignment = NSTextAlignmentRight;
    [view4 addSubview:PersonNumlab];
    
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view4.bottom, ScreenWidth, view1.height)];
    [self.view addSubview:view5];
    
    UILabel *line5 = [[UILabel alloc]initWithFrame:CGRectMake(line1.left, line1.top, line1.width, line1.height)];
    line5.backgroundColor = [UIColor themeGrayColor];
    [view5 addSubview:line5];
    
    UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.left, 12*PMBWIDTH, image1.width, image1.height)];
    image5.image = [UIImage imageNamed:@"mingxi_zhuceshijian_img"];
    [view5 addSubview:image5];
    
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(person.left, image5.top, person.width, person.height)];
    timelab.text = @"注册时间";
    timelab.textColor = [UIColor blackColor];
    timelab.font = Font(14);
    [view5 addSubview:timelab];
    
    Timelab = [[UILabel alloc]initWithFrame:CGRectMake(PersonNumlab.left-20*PMBWIDTH, image5.top, PersonNumlab.width+20*PMBWIDTH, PersonNumlab.height)];
    Timelab.textColor = [UIColor blackColor];
    Timelab.textAlignment = NSTextAlignmentRight;
    Timelab.font = Font(14);
    [view5 addSubview:Timelab];
}
- (void)getdata
{
    [HttpCenterAction GetInviteUserView:_guid Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error) {
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            NSDictionary *dic = [dict objectForKey:@"result"][0];
            PersonNumlab.text = [NSString stringWithFormat:@"%@人",[dic objectForKey:@"RecomCount"]];
            Timelab.text = [dic objectForKey:@"t_User_Date"];
            Numlab.text = [dic objectForKey:@"t_User_LoginId"];
            Namelab.text = [dic objectForKey:@"t_User_RealName"];
            Rewardslab.text = [NSString stringWithFormat:@"%@积分",[dic objectForKey:@"integral"]];
        }
    }];
}

@end
