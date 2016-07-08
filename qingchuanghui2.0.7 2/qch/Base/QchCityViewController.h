//
//  QchCityViewController.h
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol QchCityViewControllerDelegate <NSObject>

-(void)selectCityData:(NSString *)city;

@end

@interface QchCityViewController : QchBaseViewController


@property (nonatomic,assign) id<QchCityViewControllerDelegate> cityDelegate;

@property (nonatomic,strong) NSMutableArray *citylist;

@end
