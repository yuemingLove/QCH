//
//  QCHNavigationController.m
//  qch
//
//  Created by 苏宾 on 16/1/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHNavigationController.h"

@interface QCHNavigationController ()

@end

@implementation QCHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBarTheme {
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSDictionary *attrNavBar = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setTitleTextAttributes:attrNavBar];
    [navBar setBackgroundColor:TSEColor(248, 248, 248)];
}

- (void)setupBarButtonItemTheme {
    UIBarButtonItem *btnItem = [UIBarButtonItem appearance];
    NSDictionary *attrBtnItem = @{NSFontAttributeName : [UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName : [UIColor redColor]};
    [btnItem setTitleTextAttributes:attrBtnItem forState:UIControlStateNormal];
}

-(void)setBarButtonItem{
    
    UIColor *backgroudColor = [UIColor redColor];
    [self.navigationBar setBackgroundImage:[Utils createSingleColorImage:backgroudColor andImageSize:CGSizeMake(1, 44)] forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundImage:[UIImage new]
                                                                             forState:UIControlStateNormal
                                                                           barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"icon_back7"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 25, 0)]
                                                                                       forState:UIControlStateNormal
                                                                                     barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"icon_back7_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 25, 0)]
                                                                                       forState:UIControlStateHighlighted
                                                                                     barMetrics:UIBarMetricsDefault];
}


@end
