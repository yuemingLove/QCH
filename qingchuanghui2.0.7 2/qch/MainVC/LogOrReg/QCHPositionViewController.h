//
//  QCHPositionViewController.h
//  qch
//
//  Created by 青创汇 on 16/1/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"


@protocol QCHPositionDelegate <NSObject>

-(void)selectPosition:(NSDictionary*)dict;

@end

@interface QCHPositionViewController : QchBaseViewController

@property (nonatomic,assign) id<QCHPositionDelegate> positonDelegate;

@end
