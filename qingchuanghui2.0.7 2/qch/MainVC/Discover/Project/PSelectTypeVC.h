//
//  PSelectTypeVC.h
//  qch
//
//  Created by 苏宾 on 16/2/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol PSelectTypeVCDelegate <NSObject>

-(void)updatePSelectType:(NSDictionary*)dict;

@end

@interface PSelectTypeVC : QchBaseViewController

@property (nonatomic,assign) id<PSelectTypeVCDelegate> selectDelegate;

@property (nonatomic,strong) NSString *theme;
@property (nonatomic,assign) NSInteger type;

@end
