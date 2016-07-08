//
//  DynamicstateVC.h
//  qch
//
//  Created by 青创汇 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
@interface DynamicstateVC : QchBaseViewController

@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *guid;
@property (nonatomic, assign)BOOL flag;//0:创客评论, 1:其他身份评论
@property (nonatomic, assign)BOOL sureFlag;// 确定修改

@property (nonatomic, copy)void(^refleshBlock)();
@property (nonatomic, copy)void(^reflesh1Block)();

@end
