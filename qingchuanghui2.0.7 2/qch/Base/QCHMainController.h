//
//  QCHMainController.h
//  qch
//
//  Created by 青创汇 on 16/1/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCHMainController : UITabBarController

@property (nonatomic, copy)void(^badgeBlock)();// 实时更新角标

- (void)myTabBarSelectedIndex:(int)page;

@end
