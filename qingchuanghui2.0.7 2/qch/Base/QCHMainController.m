//
//  QCHMainController.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//
#import "CrowdDetailsVC.h"
#import "CourseViewVC.h"
#import "LiveOnlineListVC.h"
#import "QCHMainController.h"
#import "WMPageController.h"

//首页
#import "HomeViewController.h"
#import "DynamicViewController.h"
#import "PartnViewController.h"
#import "ProjectViewController.h"
//发现
#import "DiscoverVC.h"
#import "DiscoverViewController.h"
#import "ActivityDetailVC.h"
//消息
#import "MessageViewController.h"
#import "MyMessageVC.h"
#import "NewDiscoverViewController.h"
//我的
#import "MyInfoViewController.h"
#import "MyNewInfoViewController2.h"

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#endif
#ifndef IOS6_OR_LATER
#define IOS6_OR_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)
#endif

@interface QCHMainController ()
{
    NSInteger status;

}

@property (nonatomic, strong)UINavigationController *messageNav;

@end

@implementation QCHMainController

// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    // MoviePlayerViewController 、ZFTableViewController 控制器支持自动转屏
    if ([nav.topViewController isKindOfClass:[CourseViewVC class]] || [nav.topViewController isKindOfClass:[CrowdDetailsVC class]]) {
        // 调用ZFPlayerSingleton单例记录播放状态是否锁定屏幕方向
        return !ZFPlayerShared.isLockScreen;
    }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    if ([nav.topViewController isKindOfClass:[CourseViewVC class]] || [nav.topViewController isKindOfClass:[CrowdDetailsVC class]]) { // MoviePlayerViewController这个页面支持转屏方向
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else if ([nav.topViewController isKindOfClass:[LiveOnlineListVC class]]) { // ZFTableViewController这个页面支持转屏方向
        if (ZFPlayerShared.isAllowLandscape) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initMainViewController];
    
    // 实时更新
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setBadgeBlock:^() {
        [self returnJPUSHUnreadMsgCount];
        // 消息页跟随实时更新
        if (self.badgeBlock) {
            self.badgeBlock();
        }
        
    }];

}


-(void)createNav{
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:18.0];
    UIColor *foregroundColor=[UIColor blackColor];
    UIColor *backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          foregroundColor, NSForegroundColorAttributeName,
                                                          backgroundColor, NSBackgroundColorAttributeName,font, NSFontAttributeName,nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].translucent = NO;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonAction:)];
}
- (void)backBarButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initMainViewController{
    
    //主页
    HomeViewController *homeVC=[[HomeViewController alloc]init];
    UINavigationController *homeNav =  [[UINavigationController alloc] initWithRootViewController:homeVC];
    [homeNav.navigationController setNavigationBarHidden:NO];
    

    NewDiscoverViewController *discoverVC=[[NewDiscoverViewController alloc]init];
    UINavigationController *discoverNav =  [[UINavigationController alloc] initWithRootViewController:discoverVC];
    [discoverNav.navigationController setNavigationBarHidden:NO];

    //消息
    
    MyMessageVC *messageVC=[[MyMessageVC alloc]init];
    _messageNav =  [[UINavigationController alloc] initWithRootViewController:messageVC];
    // 更改item角标
    [self returnJPUSHUnreadMsgCount];
    [_messageNav.navigationController setNavigationBarHidden:NO];
    

    MyNewInfoViewController2 *meVC=[[MyNewInfoViewController2 alloc]init];
    UINavigationController *meNav =  [[UINavigationController alloc] initWithRootViewController:meVC];
    [meNav.navigationController setNavigationBarHidden:NO];
     //2.初始化tabBarCtr
    NSArray *viewCtrs = @[homeNav,discoverNav,_messageNav,meNav];
    [self setViewControllers:viewCtrs animated:YES];
    UITabBar *tabBar = self.tabBar;
    // 3.设置控制器属性
    [self setupChildViewController:homeVC title:@"创业圈" imageName:@"frist_normal" selectedImageName:@"frist_press" tabBar:tabBar index:0];

    [self setupChildViewController:discoverVC title:@"发现" imageName:@"secord_normal" selectedImageName:@"secord_press" tabBar:tabBar index:1];

    [self setupChildViewController:messageVC title:@"消息" imageName:@"thrid_normal" selectedImageName:@"thrid_press" tabBar:tabBar index:2];

    [self setupChildViewController:meVC title:@"我的" imageName:@"four_normal" selectedImageName:@"four_press" tabBar:tabBar index:3];

    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       TSEColor(158, 158, 158), NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:12.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    TSEColor(110, 151, 245), NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:12.0], NSFontAttributeName,
                                                       nil]
                                             forState:UIControlStateSelected];
    

    if ( IOS7_OR_LATER ) {
        self.tabBar.translucent = NO;
    }
}

- (void)setupChildViewController:(UIViewController *)childVC
                           title:(NSString *)title
                       imageName:(NSString *)imageName
               selectedImageName:(NSString *)selectedImageName
                          tabBar:(UITabBar *)tabBar
                           index:(NSUInteger)index {
    childVC.title = title;
    UITabBarItem *item = [tabBar.items objectAtIndex:index];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 设置不对图片进行蓝色的渲染
    [item setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)myTabBarSelectedIndex:(int)page {
    //self.tabBar.hidden = YES;
    UIImageView *tmpImage = (UIImageView *)[self.view viewWithTag:120];
    for (int i = 0; i < 5; i++) {
        UIButton *tmpBtn = (UIButton *)[tmpImage viewWithTag:300 + i];
        tmpBtn.selected = NO;
    }
    UIButton *selectBtn = (UIButton *)[tmpImage viewWithTag:300 + page];
    selectBtn.selected = YES;
    self.selectedIndex = page;
}

#pragma mark - 消息推送
- (NSInteger)returnRCIMClientUnreadMsgCount {
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    return unreadMsgCount;
}


- (void)returnJPUSHUnreadMsgCount {
    // 数据请求
    [HttpMessageAction GetMessageCount:UserDefaultEntity.uuid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error){
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            Liu_DBG(@"%@", dict[@"result"]);
            NSInteger badge = [dict[@"result"] integerValue];
            //-------------------
            // 更改item的角标值
            badge = badge + [self returnRCIMClientUnreadMsgCount];
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badge];
            if (badge > 0 && badge <= 99) {
                _messageNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badge];
            } else if (badge > 99) {
                _messageNav.tabBarItem.badgeValue = @"99+";
            } else {
                _messageNav.tabBarItem.badgeValue = nil;
            }
            // 更改icon角标
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

        }
    }];
}

@end
