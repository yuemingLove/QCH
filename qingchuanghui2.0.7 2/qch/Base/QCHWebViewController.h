//
//  QCHWebViewController.h
//  qch
//
//  Created by 苏宾 on 16/1/11.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PConsultModel.h"
@interface QCHWebViewController : QchBaseViewController

@property (nonatomic,strong) NSString *theme;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) NSInteger type;//1:本地的html；2：远程的网页
@property (nonatomic,strong) NSString * sharebtn;
@property (nonatomic,strong) PConsultModel *model;
@property (nonatomic, strong)void(^clickBlock)();

@end
