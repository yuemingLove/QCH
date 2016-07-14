//
//  SetAppVC.m
//  qch
//
//  Created by 苏宾 on 16/3/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SetAppVC.h"
#import "QCHWelcomeVC.h"
#import "QCHRegisterVC.h"
#import "QCHNavigationController.h"

@interface SetAppVC ()<UITableViewDataSource,UITableViewDelegate>{
    UILabel *textlabel;
    
    UISwitch *mySwitch;
    bool switchStatus;
}

@property (nonatomic,strong) UITableView *tableView;

@property (strong, nonatomic) NSArray *modules;
@property (nonatomic, strong) NSDictionary *titles;

@end

@implementation SetAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"设置"];
    
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor themeGrayColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    self.modules = @[@[@"set_account",@"set_pass",@"set_message",@"clean_lat"]];
    
    self.titles = @{@"set_account":@"解除绑定",
                    @"set_pass":@"修改密码",
                    @"set_message":@"消息提醒",
                    @"clean_lat":@"清除缓存",};
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    
    [self cleanTableView:_tableView];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50*PMBWIDTH)];
    footView.backgroundColor = [UIColor themeGrayColor];
    _tableView.tableFooterView = footView;
    
    UIButton *quitbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitbtn.frame = CGRectMake(0, 0, ScreenWidth, 30*PMBWIDTH);
    quitbtn.backgroundColor = [UIColor whiteColor];
    [quitbtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [quitbtn addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    quitbtn.titleLabel.font = Font(16);
    [footView addSubview:quitbtn];
}

-(void)cleanTableView:(UITableView*)tableView{
    
    UIView *view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    self.tableView.tableFooterView=view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modules.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_modules objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [self.titles objectForKey:module];
    
    NSString *theme=[self.titles objectForKey:module];
    if ([theme isEqualToString:@"清除缓存"]) {
        textlabel=[[UILabel alloc]initWithFrame:CGRectMake(150*SCREEN_WSCALE, 10*PMBWIDTH, 140*SCREEN_WSCALE, 20)];
        textlabel.font=Font(12);
        textlabel.textColor=[UIColor lightGrayColor];
        textlabel.textAlignment=NSTextAlignmentRight;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        
        textlabel.text=[NSString stringWithFormat:@"%.1fM",[self folderSizeAtPath:path]];
        [cell.contentView addSubview:textlabel];
        
    }else if([theme isEqualToString:@"消息提醒"]){
        
        mySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(260*SCREEN_WSCALE, 10*SCREEN_WSCALE, 50*SCREEN_WSCALE, 24*SCREEN_WSCALE)];
        switchStatus=mySwitch.on;
        [mySwitch setOn:YES animated:YES];
        [mySwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:mySwitch];
        
    }else if([theme isEqualToString:@"解除绑定"] || [theme isEqualToString:@"修改密码"]){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.selectionStyle=UITableViewCellAccessoryNone;
    
    return cell;

}



-(void)switchValueChanged:(id)sender{

    UISwitch* control = (UISwitch*)sender;
    if(control == mySwitch){
        switchStatus = control.on;
        //添加自己要处理的事情代码
        if (switchStatus ==true) {
            [mySwitch setOn:YES animated:YES];
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                
                //可以添加自定义categories
                [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                      categories:nil];
            } else {
                //categories 必须为nil
                [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                  UIRemoteNotificationTypeSound |
                                                                  UIRemoteNotificationTypeAlert)
                                                      categories:nil];
            }

        } else {
            [mySwitch setOn:NO animated:YES];
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *module = [[self.modules objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([module isEqualToString:@"set_account"]) {
        if ([UserDefaultEntity.login_type isEqualToString:@"1"]) {
            [SVProgressHUD showErrorWithStatus:@"您暂时没有绑定第三方" maskType:SVProgressHUDMaskTypeBlack];
        } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要解除绑定吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 200;
        [alert show];
        }
    }else if ([module isEqualToString:@"set_pass"]){
        QCHRegisterVC *registerVC=[[QCHRegisterVC alloc]init];
        registerVC.theme=@"修改密码";
        registerVC.type=3;
        [self.navigationController pushViewController:registerVC animated:YES];
    }else if ([module isEqualToString:@"clean_lat"]){
        [self clear:nil];
        textlabel.text=[NSString stringWithFormat:@"0.0M"];
    }
}

- (void)quit:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要退出吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 201;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==201) {
        if (buttonIndex==1) {
            [self quitExit];
        }
    }else if (alertView.tag==200){
        if (buttonIndex==1) {
            [self DelThree];
        }
    }
}
-(void)quitExit{

    UserDefaultEntity.uuid=nil;
    UserDefaultEntity.realName=nil;
    UserDefaultEntity.headPath=nil;
    UserDefaultEntity.user_style=nil;
    UserDefaultEntity.city=nil;
    UserDefaultEntity.birDate=nil;
    UserDefaultEntity.account=nil;
    UserDefaultEntity.cardPic=nil;
    UserDefaultEntity.commpany=nil;
    UserDefaultEntity.userId = nil;
    UserDefaultEntity.token = nil;
    UserDefaultEntity.uid = nil;
    UserDefaultEntity.telePhone = nil;
    UserDefaultEntity.rongCloudToken = nil;
    UserDefaultEntity.sex=nil;
    UserDefaultEntity.remark = nil;
    UserDefaultEntity.positionName =nil;
    UserDefaultEntity.positionId = nil;
    UserDefaultEntity.t_User_InvestMoney =nil;
    UserDefaultEntity.t_User_BusinessCard=nil;
    UserDefaultEntity.t_User_Complete = nil;
    UserDefaultEntity.login_type = nil;
    UserDefaultEntity.splashPath = nil;
    UserDefaultEntity.thridCode = nil;
    UserDefaultEntity.NowNeed = nil;
    
    [UserDefault saveUserDefault];
    
    [[RCIMClient sharedRCIMClient]logout];
    QCHWelcomeVC *welcome=[[QCHWelcomeVC alloc]init];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    QCHNavigationController * nav = [[QCHNavigationController alloc] initWithRootViewController:welcome];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = nav;

}

- (void)DelThree
{
    [SVProgressHUD showWithStatus:@"解绑中" maskType:SVProgressHUDMaskTypeBlack];
    [HttpCenterAction DelThree:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
 
        NSDictionary *dict = result[0];
        if ([[dict objectForKey:@"state"]isEqualToString:@"true"]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            if ([UserDefaultEntity.login_type isEqualToString:@"2"]) {
                [self quitExit];
            }
        } else if([[dict objectForKey:@"state"]isEqualToString:@"false"]) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"您暂时没有绑定的第三方登录" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}
- (void)clear:(id)sender{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                        });

}

- (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        long long size=[manager attributesOfItemAtPath:filePath error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*)folderPath{

    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:folderPath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:folderPath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[folderPath stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
@end
