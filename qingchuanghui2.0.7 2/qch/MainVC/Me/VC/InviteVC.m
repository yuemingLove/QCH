//
//  InviteVC.m
//  qch
//
//  Created by 青创汇 on 16/5/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InviteVC.h"
#import "InviteListVC.h"
@interface InviteVC ()
{
    UILabel *Invitationlab;
    UIButton *backBtn;

    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;
@property (strong, nonatomic) CycleScrollView *adsView; //显示滚动图片的View
@property (strong, nonatomic) NSArray *adsArray;
@property (nonatomic,strong) UIView *menuView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) NSMutableArray *funlist;

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    [self setNeedsStatusBarAppearanceUpdate];
    [self createscrollView];
    [self creatfooterview];
    if (_funlist !=nil) {
        _funlist=[[NSMutableArray alloc]init];
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
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
    self.navigationController.navigationBarHidden=NO;
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(void)createscrollView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor=[UIColor themeGrayColor];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 420*SCREEN_WSCALE)];
    _headerView.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200*PMBWIDTH)];
    image.image = [UIImage imageNamed:@"datu_img.jpg"];
    [_headerView addSubview:image];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15*SCREEN_WSCALE, 22*SCREEN_WSCALE, 20*SCREEN_WSCALE, 20*SCREEN_WSCALE);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:backBtn];
    
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, image.frame.size.height+15*PMBWIDTH, SCREEN_WIDTH, 150.0*SCREEN_WSCALE)];
    NSArray *menuArray=@[@"直接推荐",@"间接推荐"];
    NSArray *personArray =@[[NSString stringWithFormat:@"%@人",_fcount],[NSString stringWithFormat:@"%@人",_scount]];
    CGFloat width=(self.menuView.frame.size.width)/2.0;
    for (int i=0; i<[menuArray count]; i++) {
        
        NSString *name=[menuArray objectAtIndex:i];
        NSString *person = [personArray objectAtIndex:i];
        
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0*SCREEN_WSCALE+width*i, 0, width, _menuView.height)];

        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10*SCREEN_WSCALE, 15*PMBWIDTH, width-20*SCREEN_WSCALE, width-80*SCREEN_WSCALE);
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zhijie_img%d",i]] forState:UIControlStateNormal];
        button.tag = i;
        [btnView addSubview:button];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, button.bottom+5*PMBWIDTH, btnView.width, 16*SCREEN_WSCALE)];
        nameLabel.text=name;
        nameLabel.font=Font(15);
        nameLabel.textColor=[UIColor lightGrayColor];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [btnView addSubview:nameLabel];
        
        UILabel *personlab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.bottom+5, nameLabel.width, nameLabel.height)];
        personlab.text = person;
        personlab.font = Font(15);
        personlab.textColor = TSEColor(162, 201, 240);
        personlab.textAlignment = NSTextAlignmentCenter;
        [btnView addSubview:personlab];
        
         [self.menuView addSubview:btnView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 25*PMBWIDTH, 1*PMBWIDTH, _menuView.height-35*PMBWIDTH)];
        line.backgroundColor = [UIColor themeGrayColor];
        [_menuView addSubview:line];

        [_headerView addSubview:_menuView];

    }
    
    UIButton *Detailsbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    Detailsbtn.frame = CGRectMake(0, self.menuView.bottom, ScreenWidth, 50*PMBWIDTH);
    [Detailsbtn setTitle:@"查看直接邀请的人 》" forState:UIControlStateNormal];
    [Detailsbtn setTitleColor:TSEColor(162, 201, 240) forState:UIControlStateNormal];
    Detailsbtn.titleLabel.font = Font(15);
    [Detailsbtn addTarget:self action:@selector(Detaileselect:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:Detailsbtn];
    
    _tableView.tableHeaderView=_headerView;
}

- (void)creatfooterview
{
    self.footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*SCREEN_WSCALE)];
    [self.footerView setBackgroundColor:[UIColor whiteColor]];
    _tableView.tableFooterView=_footerView;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 8*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [_footerView addSubview:line];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15*PMBWIDTH, 20*PMBWIDTH, ScreenWidth-30*PMBWIDTH, 30*PMBWIDTH)];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = view.height/2;
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_footerView addSubview:view];
    
    UILabel *yaoqinglab = [[UILabel alloc]initWithFrame:CGRectMake(0*PMBWIDTH, 0*PMBWIDTH, 100*PMBWIDTH, 30*PMBWIDTH)];
    yaoqinglab.textAlignment = NSTextAlignmentCenter;
    yaoqinglab.text = @"我的邀请码";
    yaoqinglab.font = Font(14);
    yaoqinglab.backgroundColor = [UIColor themeGrayColor];
    yaoqinglab.textColor = [UIColor lightGrayColor];
    [view addSubview:yaoqinglab];
    
    Invitationlab = [[UILabel alloc]initWithFrame:CGRectMake(160*PMBWIDTH, yaoqinglab.top, 120*PMBWIDTH, yaoqinglab.height)];
    Invitationlab.textColor = [UIColor lightGrayColor];
    Invitationlab.text = UserDefaultEntity.account;
    Invitationlab.font = Font(14);
    [view addSubview:Invitationlab];
    
    UIButton *Invitationbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Invitationbtn.frame = CGRectMake(view.left, view.bottom+15*PMBWIDTH, view.width, 30*PMBWIDTH);
    [Invitationbtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [Invitationbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Invitationbtn.layer.cornerRadius = Invitationbtn.height/2;
    Invitationbtn.backgroundColor = TSEColor(162, 201, 240);
    Invitationbtn.titleLabel.font = Font(14);
    [Invitationbtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:Invitationbtn];
    

}

- (void)selectedAction:(UIButton*)sender
{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"logo"];
    NSArray *imageArray = @[img.image];
    NSString *path=[NSString stringWithFormat:@"http://www.cn-qch.com/wxuser/reg?UserGuid=%@",UserDefaultEntity.uuid];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"注册加入青创汇，项目、人才、资金、场地、导师、推广等创业资源一站式掌握。"
                                         images:imageArray
                                            url:[NSURL URLWithString:path]
                                          title:@"注册加入青创汇"
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
                           case SSDKResponseStateSuccess:{
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

- (void)Detaileselect:(UIButton *)sender
{
    InviteListVC *invitelist = [[InviteListVC alloc]init];
    [self.navigationController pushViewController:invitelist animated:YES];
    
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
