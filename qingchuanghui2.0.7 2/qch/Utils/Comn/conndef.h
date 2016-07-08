//
//  conndef.h
//  qch
//
//  Created by 苏宾 on 15/12/26.
//  Copyright © 2015年 qch. All rights reserved.
//

#ifndef conndef_h
#define conndef_h

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define SCREEN_WSCALE        (SCREEN_WIDTH/320.0)
#define SCREEN_WHCALE        (SCREEN_HEIGHT/568.0)
#define NUMBERS @"0123456789\n"
#define BGK_HEIGHT       200*SCREEN_WSCALE
#define APP_VERSION @"https://itunes.apple.com/lookup?id=1040438374"
#define current_version @"2.0.8"


//极光推送的指令和秘钥
#define JP_APPKEY      @"c5769e566eca15eac9f5bbc3"

//服务器地址
#define SERIVE_URL      @"http://192.168.1.77:8004/WebService/"
#define SERIVE_USER    @"http://192.168.1.77:8004/Attach/User/"
#define SERIVE_IMAGE   @"http://192.168.1.77:8004/Attach/Images/"
#define SERIVE_NEWURL    @"http://192.168.1.168:9011/api/"
#define SERIVE_HTML    @"http://192.168.1.77:8004/H5/"
#define SHARE_HTML        @"http://www.cn-qch.com/h5/"
#define SERIVE_Discovery @"http://192.168.1.77:8004/Attach/Discovery/"
#define SERIVE_LIVE    @"http://192.168.1.77:8004/Attach/Media/"


///http://120.25.106.244:8001
//#define SERIVE_URL      @"http://120.25.106.244:8002/WebService/"
//#define SERIVE_USER    @"http://120.25.106.244:8002/Attach/User/"
//#define SERIVE_IMAGE   @"http://120.25.106.244:8002/Attach/Images/"
//#define SERIVE_Discovery @"http://120.25.106.244:8002/Attach/Discovery/"
//#define SERIVE_NEWURL  @"http://120.25.106.244:9001/api/"
//#define SERIVE_HTML    @"http://www.cn-qch.com:8002/H5/"
//#define SHARE_HTML     @"http://www.cn-qch.com/h5/"
//#define SERIVE_LIVE     @"http://120.25.106.244:8002/Attach/Media/"

//NewsView.html  新闻

//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//定义兼容性
#define PMBWIDTH [UIScreen mainScreen].bounds.size.width / 320
#define PMBHEIGHT [UIScreen mainScreen].bounds.size.width / 320
//debug
#define Liu_DBG(format, ...) NSLog(format, ## __VA_ARGS__)

#define PAGE         1
#define PAGESIZE     15
#define PAGESIZE2    5
#define TOP          5

//
#define TableViewContentInset 100

// 设置颜色
#define TSEColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define TSEAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define ScreenWidth5S 320
#define ScreenWidth6 375
#define ScreenWidth6plus 414

#define Font(n) [UIFont fontWithName:@"Arial" size:n]

// 自定义Log
#ifdef DEBUG
#define TSELog(...) NSLog(__VA_ARGS__)
#else
#define TSELog(...)
#endif


#endif
