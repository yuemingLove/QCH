//
//  AppDelegate.h
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCHNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) QCHNavigationController *rootNavigationController;

@property (nonatomic,strong) BMKMapManager *mapManager;

@property (nonatomic,strong) NSString *JPtoken;
@property (nonatomic, assign)NSInteger JPUSHBabge;// 极光推送消息条数
@property (nonatomic, copy)void(^badgeBlock)();// 更改消息角标

//审核状态
@property (nonatomic,assign) NSInteger auditStatus;

//推送参数
@property (nonatomic,strong) NSString *Guid;
@property (nonatomic,strong) NSString *associateGuid;
@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSDictionary *qchUserInfo;//收到的通知中的参数;

@end

