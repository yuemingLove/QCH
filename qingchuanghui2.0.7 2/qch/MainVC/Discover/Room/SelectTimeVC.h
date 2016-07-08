//
//  SelectTimeVC.h
//  qch
//
//  Created by 苏宾 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol SelectTimeVCDeleagte <NSObject>

-(void)selectDate:(NSString *)Guid index:(NSInteger)index;

@end

@interface SelectTimeVC : QchBaseViewController

@property (nonatomic,strong) NSMutableArray *datelist;

@property (nonatomic,assign) id<SelectTimeVCDeleagte>timeDelegate;
@property (nonatomic, copy)void(^dateBlock)(NSString *Guid, NSInteger index);

@end
