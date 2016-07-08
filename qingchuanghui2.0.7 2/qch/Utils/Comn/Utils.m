//
//  Utils.m
//  Jpbbo
//
//  Created by jpbbo on 15/7/2.
//  Copyright (c) 2015年 河南金马电子商务股份有限公司. All rights reserved.
//

#import "Utils.h"
#import <objc/message.h>
#import "UIAlertView+fram.h"
#import "UIView+Hierarchy.h"
#import "UIImage+Blur.h"
#import "macrodef.h"
#import "GCDQueue.h"

typedef NS_ENUM(NSInteger, LevelType){
    levelTypeRed = 1,
    levelTypeYellow = 2,
    levelTypeBlue = 3,
    levelTypeGold = 4,
};

@implementation Utils

SINGLETON_GCD(Utils);

-(instancetype)init{
    if (self=[super init]) {
        // loadingView的引用计数，但不是最好的方式！fixme
        self.hudReference=0;
    }
    return self;
}

#pragma mark - Progress , Toast

+ (MBProgressHUD *)showProgressHUDWithText:(NSString *)text{
    
    MBProgressHUD *hud=[[MBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication] keyWindow]];

    [[[UIApplication sharedApplication] keyWindow] addSubview:hud];
    [hud bringToFront];
    [hud show:YES];
    
    hud.labelText=text;
    hud.removeFromSuperViewOnHide=YES;
    hud.dimBackground=YES;
    hud.square=YES;
    
    return hud;
}

+ (void)showLoadingView {
    if ([Utils sharedUtils].hudReference) return;
    
    [Utils sharedUtils].hudReference ++;
    
    [[GCDQueue mainQueue] queueBlock:^{
        [[Utils sharedUtils] setHud:[Utils showProgressHUDWithText:nil]]; // fixme: 创建＋show，用queue方式不合适。
    }];
}

+ (void)hideLoadingView {
    if ([Utils sharedUtils].hudReference < 0) {
        QQLog(@"Exception occurred!!! hudReference overflow!!");
        
        [Utils sharedUtils].hudReference = 0;
    }
    
    if (![Utils sharedUtils].hudReference) return;
    
    [[GCDQueue mainQueue] queueBlock:^{
        if ([Utils sharedUtils].hud) {
            [[Utils sharedUtils].hud hide:YES];
            [[Utils sharedUtils] setHud:nil];
            
            [Utils sharedUtils].hudReference --;
        }
    }];
}

+ (void)showToastWithText:(NSString *)text{
    [Utils showToastWithText:text isLoading:NO isBottom:NO];
}

+ (void)showToastWithText:(NSString *)text isLoading:(BOOL)isLoading isBottom:(BOOL)isBottom{
    [[GCDQueue mainQueue] queueBlock:^{
        UIAlertView *alertViewRe = [[UIAlertView alloc]
                                    initWithTitle:text
                                    message:nil
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil,nil];
        
        [alertViewRe show];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:alertViewRe];
        [alertViewRe dismissAfter:1];
    }];
}

+ (void)showAlertView:(NSString*)title :(NSString*)message :(NSString*)enterStr {
    
    UIAlertView *alertViewRe = [[UIAlertView alloc]
                                initWithTitle:title
                                message:message
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:enterStr,nil];
    
    [alertViewRe show];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:alertViewRe];
}

+(void)showAlertView:(NSString *)title :(NSString *)message :(NSString *)sureStr :(NSString *)cancelStr{
    UIAlertView *alertViewRe = [[UIAlertView alloc]
                                initWithTitle:title
                                message:message
                                delegate:self
                                cancelButtonTitle:sureStr
                                otherButtonTitles:cancelStr,nil];
    
    [alertViewRe show];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:alertViewRe];
}

#pragma mark - TabBar control
+ (void)hideTabBar:(UIViewController *)vc {
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

+ (void)showTabBar:(UIViewController *)vc {
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

#pragma mark - 弹出框

+ (UIImage *)screenshotForView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    imageData = nil;
    
    return image;
}

- (void)handleCloseAction:(id)sender {
    [Utils dismissPopup];
}

+ (void)showPopup:(UIView *)contentView {
    if (!contentView) return;
    
    Utils *utils = [Utils sharedUtils];
    
    if (utils.popup) return;
    
    // 圆角
    contentView.layer.cornerRadius = 4.f;
    contentView.layer.masksToBounds = YES;
    
    // 内容图之下
    utils.contentHolder = [[UIView alloc] initWithFrame:contentView.frame];
    utils.contentHolder.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [utils.contentHolder addSubview:contentView];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    utils.popup = [[UIView alloc] initWithFrame:window.rootViewController.view.bounds]; // main view
    
    // 获取截屏图，并高斯模糊
    UIImage *image = [Utils screenshotForView:window.rootViewController.view];
    image = [image boxblurImageWithBlur:0.1];
    utils.blurView = [[UIImageView alloc] initWithImage:image];
    utils.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    utils.blurView.alpha = 0;
    [[Utils sharedUtils].popup addSubview:utils.blurView];
    
    // coverView
    utils.coverView = [[UIView alloc] initWithFrame:window.rootViewController.view.bounds];
    utils.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    utils.coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    [[Utils sharedUtils].popup addSubview:utils.coverView];
    
    // 点触事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[Utils sharedUtils] action:@selector(handleCloseAction:)];
    [utils.coverView addGestureRecognizer:tapGesture];
    
    [utils.coverView addSubview:utils.contentHolder];
    utils.contentHolder.center = CGPointMake(utils.coverView.bounds.size.width/2,
                                             utils.coverView.bounds.size.height/2);
    utils.coverView.alpha = 0;
    
    utils.popup.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [window.rootViewController.view addSubview:utils.popup];
    [utils.popup bringToFront];
    
    utils.contentHolder.transform = CGAffineTransformMakeScale(0.8, 0.8);
    utils.initialPopupTransform = utils.contentHolder.transform;
    //    [window.layer setMasksToBounds:YES];
    [UIView animateWithDuration:0.3
                     animations:^{
                         utils.coverView.alpha = 1;
                         utils.blurView.alpha = 1;
                         
                         utils.contentHolder.transform = CGAffineTransformIdentity;
                     }];
}

+ (void)dismissPopup {
    Utils *utils = [Utils sharedUtils];
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         utils.coverView.alpha = 0;
                         utils.contentHolder.transform = utils.initialPopupTransform;
                         utils.blurView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [utils.popup removeFromSuperview];
                         utils.popup = nil;
                         utils.blurView = nil;
                         utils.coverView = nil;
                     }];
}

#pragma mark -
+ (void)addLocalNotification:(NSString*)title :(NSString*)content {
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置调用时间
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];//通知触发的时间，10s以后
    notification.repeatInterval = 2;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    notification.alertBody = content; //通知主体
    notification.applicationIconBadgeNumber = 1;//应用程序图标右上角显示的消息数
    notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    notification.soundName = @"msg.caf";//通知声音（需要真机才能听到声音）
    
    //设置用户信息
    //notification.userInfo=@{@"id":@1,@"user":@"Kenshin Cui"};//绑定到通知上的其他附加信息
    
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)removeAllLocalNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Print 对象的属性值：最下层类结构

+ (void)printObject:(id)obj {
    const char *classname = object_getClassName(obj);
    id objclass_ = objc_getClass(classname);
    (void) objclass_;
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%s {", classname];
    
    id objclass = [obj class];
    unsigned int propCount, i;
    objc_property_t *properties = class_copyPropertyList(objclass, &propCount);
    for (i = 0; i < propCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [obj valueForKey:propName];
        
        [desc appendFormat:@" %@=%@ ", propName, value];
    }
    
    NSLog(@"%@}", desc);
}

+ (BOOL)isSimCardInstalled {
    return YES;
}

//判断手机号和邮箱
+ (BOOL)checkTel:(NSString *)str{
    

//    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSString *regex = @"^((13[0-9])|(147)|(17[016-8])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

+ (BOOL)isValidateEmail:(NSString*)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证号

+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{16,19})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}


+ (void)makePhoneCall:(NSString *)tel {
    // Note: 用该方法，主动结束后，返回系统界面，不返回应用界面
    //    [[UIApplication sharedApplication] openURL:phoneUrl];
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel:", tel]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:callWebview];
    [callWebview bringToFront];
}

+ (void)makeCall:(NSString *)callName andViewController:(UIViewController *)vc{
   
    NSString *phoneStr=[NSString stringWithFormat:@"tel://%@",callName];
    NSURL *phoneURL = [NSURL URLWithString:phoneStr];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [vc.view addSubview:callWebView];
}

+ (NSString *)getVersion{

    NSString *plistPath=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *data=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *version=[data objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert{
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage *)createSingleColorImage:(UIColor *)color andImageSize:(CGSize)size{
    
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)GPUImageGaussianBlurImage:(NSString *)path{
    
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    
    UIImageView *imageView=[[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"beijing_img.jpg"]];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:imageView.image];
    
    return blurredImage;
}

/**
 *  检测当前网络连接状态
 *
 *  @return
 */
+ (BOOL)isExistNetWork{
    BOOL isExist = NO;
    // fixme: AFNetworkReachabilityManager
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable: //无网络
            isExist = NO;
            break;
        case ReachableViaWWAN://WLAN
        {
            isExist = YES;
        }
            break;
        case ReachableViaWiFi://WIFI
        {
            isExist = YES;
        }
        default:
            break;
    }
    
    
    
    
    return isExist;
}
/**
+(BOOL)checkNetworkConnection{
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}**/


+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName{
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}


@end
