//
//  QchSelectCityVC.h
//  qch
//
//  Created by 苏宾 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QchBaseViewController.h"

@protocol  QchSelectCityVCDelegate <NSObject>

-(void)selectCityData:(NSString *)city;

@end

@interface QchSelectCityVC : QchBaseViewController

@property (nonatomic,assign) id<QchSelectCityVCDelegate> cityDelegate;

@property (nonatomic,strong) NSMutableArray *citylist;


@property (nonatomic,assign) NSInteger type;

@end
