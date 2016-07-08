//
//  SignViewController.m
//  qch
//
//  Created by W.兵 on 16/7/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SignViewController.h"
#import "WJAdsView.h"

@interface SignViewController ()<WJAdsViewDelegate>
{
    NSString *T_SignIn_Days;// 连续签到天数
    NSString *T_SignIn_Date;// 签到日期
    NSString *T_Integral;// 获得积分
    NSString *T_Extra_Integral;// 额外奖励积分
}
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //share
    //UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareViewBtn:)];
    //self.navigationItem.rightBarButtonItem=shareView;
    //[self showViewWithDate:@"7" integral:@"60"];
    [self createbgkView];
    [self getsignInData];
    T_Extra_Integral = @"0";
    T_Integral = @"0";
    T_SignIn_Date = @"";
    T_SignIn_Days = @"0";
}
// 获取历史签到信息
- (void)getsignInData {
    [HttpSignAction getGetSignInWithUserGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        Liu_DBG(@"%@", UserDefaultEntity.uuid);
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSDictionary *dic=[dict objectForKey:@"result"][0];
            if ([[dic objectForKey:@"state"]isEqualToString:@"true"]) {
                NSDictionary *resultdic = [dic objectForKey:@"result"][0];
                T_Extra_Integral = resultdic[@"T_Extra_Integral"];
                T_Integral = resultdic[@"T_Integral"];
                T_SignIn_Date = resultdic[@"T_SignIn_Date"];
                T_SignIn_Days = resultdic[@"T_SignIn_Days"];
                [self signActionWith:[(NSNumber *)T_SignIn_Days integerValue]];
            }
        }
    }];
}
// 签到
- (void)signInData {
    [HttpSignAction getSignInWithUserGuid:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            // 签到成功, 再次获取签到信息
            NSDictionary *dic=[dict objectForKey:@"result"][0];
            if ([[dic objectForKey:@"state"]isEqualToString:@"true"]) {
                NSDictionary *resultdic = [dic objectForKey:@"result"][0];
                T_Extra_Integral = resultdic[@"T_Extra_Integral"];
                T_Integral = resultdic[@"T_Integral"];
                T_SignIn_Date = resultdic[@"T_SignIn_Date"];
                T_SignIn_Days = resultdic[@"T_SignIn_Days"];
                [self signActionWith:[(NSNumber *)T_SignIn_Days integerValue]];
                [self showViewWithDate:T_SignIn_Days integral:[NSString stringWithFormat:@"%ld", [(NSNumber *)T_Integral integerValue] + [(NSNumber *)T_Extra_Integral integerValue]]];
            }
        } else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            // 签到失败
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
- (void)createbgkView {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    if (ScreenWidth > 380) {
        imageV.image = [UIImage imageNamed:@"my_new_sign_6p"];
    } else if (ScreenWidth < 380 && ScreenWidth > 330) {
        imageV.image = [UIImage imageNamed:@"my_new_sign_6"];
    } else if(ScreenWidth < 330) {
    imageV.image = [UIImage imageNamed:@"my_new_sign_5"];
    }
    [self.view addSubview:imageV];
    UIImageView *imagePoint1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_new_pointN"]];
    imagePoint1.tag = 100;
    imagePoint1.frame = CGRectMake(16*PMBWIDTH, 270*PMBHEIGHT, 25, 25);
    if (ScreenHeight < 490) {
        // iPhone4
        [imagePoint1 setFrame:CGRectMake(4*PMBWIDTH, 200*PMBHEIGHT, 25, 25)];
    } else if (ScreenHeight > 500 && ScreenHeight < 570) {
        // iPhone5
        [imagePoint1 setFrame:CGRectMake(4*PMBWIDTH, 260*PMBHEIGHT, 25, 25)];
    }
    [self.view addSubview:imagePoint1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imagePoint1.left+5*PMBWIDTH, imagePoint1.bottom+5*PMBHEIGHT, 15, 15)];
    label1.text = [NSString stringWithFormat:@"%d", 1];
    label1.textColor = TSEColor(85, 104, 145);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = Font(15);
    [self.view addSubview:label1];
    for (int i = 0; i < 6; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(imagePoint1.right+(34*PMBWIDTH+25-11*PMBWIDTH)*i-5.5*PMBWIDTH, imagePoint1.top+imagePoint1.height/2-1*PMBHEIGHT, 34*PMBWIDTH, 2*PMBHEIGHT)];
        line.backgroundColor = TSEColor(177, 187, 209);
        line.tag = 100+2*i+1;
        [self.view addSubview:line];
        UIImageView *imagePoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_new_pointN"]];
        imagePoint.tag = 100+2*(i+1);
        imagePoint.frame = CGRectMake(line.right-5.5*PMBWIDTH, imagePoint1.top, 25, 25);
        [self.view addSubview:imagePoint];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imagePoint.left+5*PMBWIDTH, imagePoint.bottom+5*PMBHEIGHT, 15, 15)];
        label.text = [NSString stringWithFormat:@"%d", i+2];
        label.textColor = TSEColor(85, 104, 145);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = Font(15);
        [self.view addSubview:label];
        if (i==1||i==5) {
            label.hidden = YES;
            UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(imagePoint.left, imagePoint.bottom, 26, 26)];
            ima.image = [UIImage imageNamed:@"my_new_k"];
            [self.view addSubview:ima];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(6*PMBWIDTH, 8*PMBHEIGHT, 13, 13)];
            lab.text = [NSString stringWithFormat:@"%d", i+2];
            lab.textColor = TSEColor(85, 104, 145);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = Font(11);
            [ima addSubview:lab];
        }
    }
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(50*PMBWIDTH, 340*PMBHEIGHT, ScreenWidth-100*PMBWIDTH, 40);
    if (ScreenHeight < 490) {
        // iPhone4
        [sureButton setFrame:CGRectMake(50*PMBWIDTH, 270*PMBHEIGHT, ScreenWidth-100*PMBWIDTH, 30)];
    } else if (ScreenHeight > 500 && ScreenHeight < 570) {
        // iPhone5
        [sureButton setFrame:CGRectMake(50*PMBWIDTH, 330*PMBHEIGHT, ScreenWidth-100*PMBWIDTH, 35)];
    }
    [sureButton setTitle:@"立即签到领积分" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = Font(15);
    sureButton.layer.cornerRadius = sureButton.height/2;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = TSEColor(110, 151, 245);
    [sureButton addTarget:self action:@selector(sureSign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}
- (void)sureSign {
    // 点击签到
    [self signInData];
}
- (void)signActionWith:(NSInteger)signNumber {
    switch (signNumber) {
        case 1:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
            }
        }
            break;
        case 2:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        case 3:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102|| self.view.subviews[i].tag == 104) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101 || self.view.subviews[i].tag == 103) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        case 4:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102|| self.view.subviews[i].tag == 104 || self.view.subviews[i].tag == 106) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101 || self.view.subviews[i].tag == 103 || self.view.subviews[i].tag == 105) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        case 5:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102|| self.view.subviews[i].tag == 104 || self.view.subviews[i].tag == 106 || self.view.subviews[i].tag == 108) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101 || self.view.subviews[i].tag == 103 || self.view.subviews[i].tag == 105 || self.view.subviews[i].tag == 107) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        case 6:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102|| self.view.subviews[i].tag == 104 || self.view.subviews[i].tag == 106 || self.view.subviews[i].tag == 108 || self.view.subviews[i].tag == 110) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101 || self.view.subviews[i].tag == 103 || self.view.subviews[i].tag == 105 || self.view.subviews[i].tag == 107 || self.view.subviews[i].tag == 109) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        case 7:
        {
            for (int i = 0; i < self.view.subviews.count; i++) {
                if (self.view.subviews[i].tag == 100 || self.view.subviews[i].tag == 102|| self.view.subviews[i].tag == 104 || self.view.subviews[i].tag == 106 || self.view.subviews[i].tag == 108 || self.view.subviews[i].tag == 110 || self.view.subviews[i].tag == 112) {
                    [(UIImageView *)self.view.subviews[i] setImage:[UIImage imageNamed:@"my_new_pointL"]];
                }
                if (self.view.subviews[i].tag == 101 || self.view.subviews[i].tag == 103 || self.view.subviews[i].tag == 105 || self.view.subviews[i].tag == 107 || self.view.subviews[i].tag == 109 || self.view.subviews[i].tag == 111) {
                    [(UIView *)self.view.subviews[i] setBackgroundColor:TSEColor(110, 151, 245)];
                }
            }
        }
            break;
        default:
            break;
    }
}
- (void)showViewWithDate:(NSString *)date integral:(NSString *)integral{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.backgroundColor = [UIColor colorWithWhite:20
                                                           alpha:0.3];
    WJAdsView *adsView = [[WJAdsView alloc] initWithWindow:appDelegate.window];
    
    adsView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    adsView.delegate = self;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.height)];
    backview.backgroundColor = [UIColor clearColor];
    
    UIImageView *backimg = [[UIImageView alloc]initWithFrame:CGRectMake(30*PMBWIDTH, 0*PMBWIDTH, backview.width-50*PMBWIDTH, 228*PMBWIDTH)];//215, 265.5
    backimg.image = [UIImage imageNamed:@"my_new_signImage"];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10*PMBWIDTH, 163*PMBHEIGHT, backimg.width - 20*PMBWIDTH, 20)];
    if ([(NSNumber *)T_Extra_Integral integerValue] > 10) {
        [lab setFrame:CGRectMake(10*PMBWIDTH, 155*PMBHEIGHT, backimg.width - 20*PMBWIDTH, 20)];
    }
    lab.textColor = TSEColor(254, 73, 88);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = Font(17);
    lab.text = [NSString stringWithFormat:@"恭喜你获得 %@ 积分", integral];
    [backimg addSubview:lab];
    
    if ([(NSNumber *)T_Extra_Integral integerValue] > 10) {
        UILabel *lab0 = [[UILabel alloc] initWithFrame:CGRectMake(10*PMBWIDTH, lab.bottom+2*PMBHEIGHT, backimg.width - 20*PMBWIDTH, 16)];
        lab0.textColor = TSEColor(254, 73, 88);
        lab0.textAlignment = NSTextAlignmentCenter;
        lab0.font = Font(14);
        lab0.text = [NSString stringWithFormat:@"(含额外奖励 %@ 积分)", (NSNumber *)T_Extra_Integral];
        [backimg addSubview:lab0];
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您已连续签到 %@ 天", date]];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:17.0]
                          range:NSMakeRange(7, 1)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:TSEColor(254, 73, 88)
                          range:NSMakeRange(7, 1)];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10*PMBWIDTH, 200*PMBHEIGHT, backimg.width - 20*PMBWIDTH, 18)];
    lab1.textColor = TSEColor(115, 132, 167);
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = Font(16);
    lab1.attributedText = AttributedStr;
    [backimg addSubview:lab1];
    
    [backview addSubview:backimg];
    [array addObject:backview];
    adsView.containerSubviews = array;
    [appDelegate.window addSubview:adsView];
    [adsView showAnimated:YES];
}

-(void)shareViewBtn:(id)sender{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    //NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[_projectDict objectForKey:@"t_Project_ConverPic"]];
    
    UIImageView *img = [[UIImageView alloc] init];
    
    //[img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    
   // NSString *path=[NSString stringWithFormat:@"%@ShareProject.html?Guid=%@&UserGuid=%@",SHARE_HTML,[_projectDict objectForKey:@"Guid"],UserDefaultEntity.uuid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
    
    if (imageArray) {
       // NSString *oneword = [[_projectDict objectForKey:@"t_Project_OneWord"]stringByReplacingOccurrencesOfString:@"===" withString:@"\n"];
       // if (oneword.length>140) {
       //     oneword = [NSString stringWithFormat:@"%@",[oneword substringToIndex:140]];
       // }
       // NSString *title = [[NSString stringWithFormat:@"%@",[_projectDict objectForKey:@"t_Project_Name"]] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
        //if (title.length>50) {
        //    title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
        //}
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
       // [shareParams SSDKSetupShareParamsByText:oneword
        //                                 images:imageArray
        //                                    url:[NSURL URLWithString:path]
        //                                  title:title
        //                                   type:SSDKContentTypeAuto];
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
                           case SSDKResponseStateSuccess:{
                               [self ShareIntegral:@"5"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:{
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
