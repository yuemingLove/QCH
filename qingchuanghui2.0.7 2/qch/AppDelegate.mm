//
//  AppDelegate.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "QCHMainController.h"
#import "QCHWelcomeVC.h"
#import "ActivityDetailVC.h"
#import "DynamicstateVC.h"
#import "CarePersonListVC.h"
#import "QCHNavigationController.h"
#import "SystemMessageVC.h"
#import "MyProjectVC.h"
#import "MyActivityVC.h"
#import "ZLCGuidePageView.h"
#import "ViewController.h"
#define RONGCLOUD_IM_APPKEY @"e0x9wycfx5ybq"
#define UMENG_APPKEY @"5611e73b67e58e9d9700624d"
#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)


#define iPhone5                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(640, 1136),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)

#define iPhone4                                                           \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(640, 960),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
static BOOL isProduction = TRUE;

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>{
    enum WXScene _scene;
}

@end

@implementation AppDelegate


- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self showSplash];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];

    [NSThread sleepForTimeInterval:1.0];

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * curVersion = [userDefaults objectForKey:@"logistics_curversion"];
    if(curVersion && [curVersion isEqualToString:current_version]) {
        [self initViewController];
    }
    else {
        [userDefaults setObject:current_version forKey:@"logistics_curversion"];
        ViewController *main = [[ViewController alloc] init];
        [main.navigationController setNavigationBarHidden:YES];
        self.window.rootViewController = main;
    }
    [userDefaults synchronize];
    
    //微信支付配置
    [WXApi registerApp:@"wx54ec63a8d4b60179" withDescription:@"demo 2.0"];
    
    [self IQKeyBoard];
    [self BaiduMap];
    [self shareSDKLogin];
    [self RcimUI];
    
    [self JPushData:launchOptions];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }

    return YES;
}


-(void)showSplash{
    
    [HttpLoginAction LoadPic:[MyAes aesSecretWith:@"Token"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            [self.window makeKeyAndVisible];
            
            UIImageView* splashView = [[UIImageView alloc] initWithFrame:self.window.bounds];
            //[splashView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:UserDefaultEntity.splashPath]];
            NSString *path=[NSString stringWithFormat:@"%@%@",@"http://120.25.106.244:8002/Attach/LoadPic/",[dict objectForKey:@"LoadPic"]];
            [splashView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_03"]];

            
            [self.window addSubview:splashView];
            [self.window bringSubviewToFront:splashView];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:4.0];
            [UIView setAnimationDelegate:self];
            splashView.alpha=1.0;
            splashView.frame=CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            [UIView commitAnimations];
        }
    }];
}


- (void)onlineConfigCallBack:(NSNotification *)note {
    
    //NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

-(void) changeScene:(NSInteger )scene{
    _scene = (enum WXScene)scene;
}

-(void)initViewController{

    
    if ([UserDefaultEntity.t_User_Complete isEqualToString:@"1"]) {
        [self mainViewController];
    } else if([UserDefaultEntity.t_User_Complete isEqualToString:@"0"]){
        [self presentInitViewController];
    }else if ([self isBlankString:UserDefaultEntity.t_User_Complete]){
        [self presentInitViewController];
    }
}

-(void)JPushData:(NSDictionary *)launchOptions {
    
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
    
    [JPUSHService setupWithOption:launchOptions appKey:JP_APPKEY
                          channel:@"Publish channel" apsForProduction:isProduction];
}


-(void)shareSDKLogin{
    
    NSArray *array=@[
                    @(SSDKPlatformSubTypeWechatSession),
                     @(SSDKPlatformSubTypeWechatTimeline),
                    @(SSDKPlatformTypeQQ),
                    @(SSDKPlatformTypeSinaWeibo)];
    [ShareSDK registerApp:@"e072e4fff57a" activePlatforms:array onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType){
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"368953109"
                        appSecret:@"0288141bd943763107a83e020ccad6f9"
                                        redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1104876882"
                                     appKey:@"owU0BWX7Pv0ZdFvf"
                                   authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx54ec63a8d4b60179" appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                break;
            default:
                break;
        }
    }];
    
}


-(void)IQKeyBoard{
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = YES;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
}

-(void)BaiduMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"TmU8nPSIowHwSsq3x1FLHRYk" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

-(void)RcimUI{
    
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY ];
    //设置会话列表头像和会话界面头像
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;
    //开启发送已读回执（只支持单聊）
    [RCIM sharedRCIM].enableReadReceipt=YES;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    

}
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    [HttpLoginAction GetUserPic:userId Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            
            NSDictionary *item=[dict objectForKey:@"result"][0];
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = [item objectForKey:@"t_User_LoginId"];
            user.name = [item objectForKey:@"t_User_RealName"];
            user.portraitUri =   [NSString stringWithFormat:@"%@%@",SERIVE_USER,[item objectForKey:@"t_User_Pic"]];
            return completion(user);
            
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"false"]) {
            
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"数据加载失败，请重新加载" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
}


-(void)presentInitViewController{
    
    QCHWelcomeVC *welcomeVC=[[QCHWelcomeVC alloc]init];
    _rootNavigationController=[[QCHNavigationController alloc] initWithRootViewController:welcomeVC];
    [_rootNavigationController setNavigationBarHidden:YES];
    
    [self.window setRootViewController:_rootNavigationController];
    
    [self.window makeKeyAndVisible];
}

-(void)mainViewController{
    
    QCHMainController *main = [[QCHMainController alloc] init];
    [main.navigationController setNavigationBarHidden:YES];
    self.window.rootViewController = main;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window setBackgroundColor:TSEColor(244, 244, 244)];
    [self.window makeKeyAndVisible];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [JPUSHService clearAllLocalNotifications];
}



#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

-(void) onResp:(BaseResp*)resp{
    
    //启动微信支付的response
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                strMsg = @"支付结果：成功！";
                break;
            case -1:
                strMsg = @"支付结果：失败！";
                break;
            case -2:
                strMsg = @"用户已经退出支付！";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
    if (resp.errCode==0) {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"支付成功",@"textOne", nil];
        /*
         *  创建通知
         *  通过通知中心发送通知
         */
        NSNotification *notifiction = [NSNotification notificationWithName:@"wxpay" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notifiction];
    }
}


/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
    self.JPtoken=[JPUSHService registrationID];
   NSLog(@"设备ID:%@",self.JPtoken);
    [JPUSHService registerDeviceToken:deviceToken];
}



/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:self
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        alert.tag=201;
        [alert show];
        
    }
}

//系统通知  消息类型

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    if (self.badgeBlock) {
        self.badgeBlock();
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    _qchUserInfo=[userInfo copy];
    
    [self receiveRemoteNoti:userInfo];
    
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    _qchUserInfo=[userInfo copy];
    
    if ([_qchUserInfo objectForKey:@"type"]) {//有消息参数  跳
        [self receiveRemoteNoti:userInfo];
    }
}

- (void)receiveRemoteNoti:(NSDictionary *)userInfo {
    
    _Guid=[userInfo objectForKey:@"Guid"];
    _associateGuid = [userInfo objectForKey:@"associateGuid"];
    NSString *alertTitle = nil;
    
    alertTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSInteger badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    self.JPUSHBabge = badge;
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    if (self.badgeBlock) {
        self.badgeBlock();
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去看看", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==201) {
        
        if (buttonIndex==0) {
            [self quitExit];
            QCHWelcomeVC *welcome=[[QCHWelcomeVC alloc]init];
            UINavigationController *_navi =
            [[UINavigationController alloc] initWithRootViewController:welcome];
            self.window.rootViewController = _navi;
             [[UIApplication sharedApplication]unregisterForRemoteNotifications];
        }
    }else{
        if (buttonIndex==1) {

            QCHMainController *tabBarCtrl=(QCHMainController*)self.window.rootViewController;
            // 向服务器上传数据表示已读
            [self singleChose];
            NSString *msgType = [_qchUserInfo objectForKey:@"type"];
            if ([msgType isEqualToString:@"activity"]) {
                ActivityDetailVC *activityDetail=[[ActivityDetailVC alloc]init];
                activityDetail.hidesBottomBarWhenPushed=YES;
                activityDetail.guid=_associateGuid;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:activityDetail animated:YES];
            }else if ([msgType isEqualToString:@"topic"]){
                DynamicstateVC *dynamicstate=[[DynamicstateVC alloc]init];
                dynamicstate.hidesBottomBarWhenPushed=YES;
                dynamicstate.guid=_associateGuid;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:dynamicstate animated:YES];
            }else if([msgType isEqualToString:@"fans"]){
                CarePersonListVC *carePerson=[[CarePersonListVC alloc]init];
                carePerson.hidesBottomBarWhenPushed=YES;
                carePerson.type=10;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:carePerson animated:YES];
            }else if ([msgType isEqualToString:@"message"]){
                SystemMessageVC *message = [[SystemMessageVC alloc]init];
                message.hidesBottomBarWhenPushed = YES;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:message animated:YES];
            }else if ([msgType isEqualToString:@"project"]){
                MyProjectVC *project = [[MyProjectVC alloc]init];
                project.hidesBottomBarWhenPushed = YES;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:project animated:YES];
            }else if ([msgType isEqualToString:@"activitylist"]){
                MyActivityVC *activity = [[MyActivityVC alloc]init];
                activity.hidesBottomBarWhenPushed = YES;
                [(QCHNavigationController*)tabBarCtrl.selectedViewController pushViewController:activity animated:YES];
            }
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
    [UserDefault saveUserDefault];
    
    [[RCIMClient sharedRCIMClient]logout];
    
}


- (void)singleChose {
    [HttpMessageAction EditReadPush:_Guid type:@"1" Token:[MyAes aesSecretWith:@"guid"] complete:^(id result, NSError *error){
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            Liu_DBG(@"单条推送已读");
            if (self.badgeBlock) {
                self.badgeBlock();
            }
        }
    }];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        NSLog(@"联网成功");
    }else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        NSLog(@"授权成功");
    }else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end
