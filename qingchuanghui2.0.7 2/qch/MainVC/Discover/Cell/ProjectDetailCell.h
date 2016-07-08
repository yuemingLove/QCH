//
//  ProjectDetailCell.h
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *themeLabel;

@property (nonatomic,weak) IBOutlet UIView *line;

@property (nonatomic,weak) IBOutlet UILabel *content;

-(void)setIntroductionText:(NSString*)text;

@end
