//
//  ProjectListCell.h
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;

-(void)updateFrame:(NSDictionary*)dict;

@end
