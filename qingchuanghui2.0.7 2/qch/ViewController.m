//
//  ViewController.m
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import "ViewController.h"
#import "ZLCGuidePageView.h"
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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *images = nil;
    //引导页图片数组
  if (iPhone4){
        images =  @[[UIImage imageNamed:@"640*960_1"],[UIImage imageNamed:@"640*960_2"],[UIImage imageNamed:@"640*960_3"],[UIImage imageNamed:@"640*960_4"]];
    }else if (iPhone5){
        images =  @[[UIImage imageNamed:@"640*1136_1"],[UIImage imageNamed:@"640*1136_2"],[UIImage imageNamed:@"640*1136_3"],[UIImage imageNamed:@"640*1136_4"]];
    } else {
        images =  @[[UIImage imageNamed:@"750*1334_1"],[UIImage imageNamed:@"750*1334_2"],[UIImage imageNamed:@"750*1334_3"],[UIImage imageNamed:@"750*1334_4"]];
    }
    //创建引导页视图
    ZLCGuidePageView *pageView = [[ZLCGuidePageView alloc]initWithFrame:self.view.frame WithImages:images];
    [self.view addSubview:pageView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
