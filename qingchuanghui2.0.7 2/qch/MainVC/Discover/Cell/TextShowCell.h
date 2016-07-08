//
//  TextShowCell.h
//  qch
//
//  Created by 苏宾 on 16/3/15.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntity.h"

@interface TextShowCell : UITableViewCell

@property (nonatomic,strong) TextEntity *entity;

//展开多个活动信息
@property (nonatomic,copy) void (^showMoreTextBlock)(UITableViewCell *currentCell);

//未展开时的高度
+ (CGFloat)cellDefaultHeight:(TextEntity*)entity;
//展开后的高度
+ (CGFloat)cellMoreHeight:(TextEntity*)entity;

@end
