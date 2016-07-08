//
//  WorkExperienceVC.h
//  qch
//
//  Created by 青创汇 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"
typedef void (^ReturnArrayBlock)(NSArray *HistorkWork);

@interface WorkExperienceVC : QchBaseViewController

@property (nonatomic,copy)ReturnArrayBlock returnArrayblock;

- (void)returnArray:(ReturnArrayBlock)block;
@end
