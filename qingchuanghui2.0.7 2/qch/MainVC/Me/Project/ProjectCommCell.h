//
//  ProjectCommCell.h
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCommCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;

@property (nonatomic,weak) IBOutlet UIImageView *comImageView;
@property (nonatomic,weak) IBOutlet UIImageView *statusImageView;

@property (nonatomic,weak) IBOutlet UIView *bgView;

@property (nonatomic,weak) IBOutlet UILabel *projectName;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

@property (nonatomic,weak) IBOutlet UILabel *title;
@property (nonatomic,weak) IBOutlet UILabel *detail;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

@end
