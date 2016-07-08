//
//  PositionViewController.h
//  qch
//
//  Created by 青创汇 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchBaseViewController.h"

@protocol PositionDelegate <NSObject>

-(void)selectPosition:(NSDictionary*)dict;
@end
@interface PositionViewController : QchBaseViewController

@property (nonatomic,assign) id<PositionDelegate> positonDelegate;
@end
