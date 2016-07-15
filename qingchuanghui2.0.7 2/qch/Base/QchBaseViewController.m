//
//  QchBaseViewController.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
#import "UserDefault.h"

@interface QchBaseViewController ()<UIAlertViewDelegate>

@end

@implementation QchBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationCapturesStatusBarAppearance=NO;
    }
    
    [self createNav];

    
    if (![self isBlankString:UserDefaultEntity.uuid ]) {
        [self updateDivceToken:UserDefaultEntity.uuid];
    }
    
    [self checkNetworkState];
}

-(void)updateDivceToken:(NSString*)uuid{
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [HttpLoginAction EditRid:uuid androidRid:@"" IOSRid:app.JPtoken Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
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



-(void)setNavBarTitle:(NSString *)str{
    
    UILabel *textLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [textLable setTextAlignment:NSTextAlignmentCenter];
    [textLable setFont:[UIFont systemFontOfSize:18]];
    [textLable setText:str];
    [textLable setTextColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitleView:textLable];
}

- (void)hideTabBar:(UIViewController *)vc {
    if (vc.tabBarController.tabBar.hidden == YES) {
        return;
    }
    
    UIView *contentView;
    if ( [[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
    }
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + vc.tabBarController.tabBar.frame.size.height);
    
    vc.tabBarController.tabBar.hidden = YES;
}
-(void)showAlertWithTitle:(NSString *)titleString{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:titleString delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.0];
    
}
- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        
    }
}

- (void)showTabBar:(UIViewController *)vc {
    if (vc.tabBarController.tabBar.hidden == NO) {
        return;
    }
    UIView *contentView;
    if ([[vc.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        contentView = [vc.tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [vc.tabBarController.view.subviews objectAtIndex:0];
    }
    
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - vc.tabBarController.tabBar.frame.size.height);
    vc.tabBarController.tabBar.hidden = NO;
}

//集成登录融云第三方SDK
- (void)linketoRongyun:(NSString *)tookenString{
    
    // 快速集成第二步，连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:tookenString success:^(NSString *userId) {
        // Connect 成功
        NSLog(@"成功&userid = %@",userId);
        
        UserDefaultEntity.userId=userId;
        UserDefaultEntity.token=tookenString;
        [UserDefault saveUserDefault];
    }
    error:^(RCConnectErrorCode status) {
        // Connect 失败
        NSLog(@"融云链接失败");
    }
    tokenIncorrect:^() {
        NSLog(@"Token 失效的状态处理");
    }];
}

-(void)getRYToken:(NSString *)Guid{
    [HttpLoginAction getRYToken:Guid Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            NSArray *array=[dict objectForKey:@"getToken"];
            NSDictionary *item=array[0];
            NSLog(@"获取：%@",[item objectForKey:@"token"]);
            [self linketoRongyun:[item objectForKey:@"token"]];
        }
    }];
}

- (void)ShareIntegral:(NSString *)type
{
    [HttpCenterAction ShareIntegral:UserDefaultEntity.uuid type:type Token:[MyAes aesSecretWith:@"userGuid"] complete:^(id result, NSError *error) {
    }];
}

-(UILabel *)createLabelFrame:(CGRect)frame color:(UIColor*)color font:(UIFont *)font text:(NSString *)text{
    
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.font=font;
    label.textColor=color;
    label.textAlignment=NSTextAlignmentLeft;
    label.text=text;
    
    return label;
}

-(UITextField *)createTextFieldFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder{
    
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.placeholder=placeholder;
    
    return textField;
}

-(NSString *)stringChangDate:(NSString *)date{
    NSString *time=[date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    time=[time substringFromIndex:5];
    time=[time substringToIndex:11];;
    
    return time;
}

-(void)checkNetworkState{
    
    Reachability *wifi=[Reachability reachabilityForLocalWiFi];
    Reachability *conn=[Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        NSLog(@"网络为wifi");
    }else if ([conn currentReachabilityStatus] !=NotReachable){
        NSLog(@"网络为设备自带网络");
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络不可用，请连接网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去连接", nil];
        [alert show];
        NSLog(@"没有网络");
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSURL *url = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {//iOS7
            url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        } else {
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        }
        //NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
            [[UIApplication sharedApplication] openURL:url];
        }
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
