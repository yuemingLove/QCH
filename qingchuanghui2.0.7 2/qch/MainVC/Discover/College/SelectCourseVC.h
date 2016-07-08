//
//  SelectCourseVC.h
//  qch
//
//  Created by W.兵 on 16/4/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol SelectCourseVCDeleage <NSObject>

-(void)updateData:(NSMutableArray*)array;

@end


@interface SelectCourseVC : QchBaseViewController

@property (nonatomic,strong) NSString *courseGroup;

//@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,assign) id<SelectCourseVCDeleage> selectDeleage;

@end
