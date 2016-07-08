//
//  ProjectDetCell.h
//  qch
//
//  Created by 苏宾 on 16/2/26.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong) UILabel *cityStr;
@property (nonatomic,strong) UILabel *fieldStr;
@property (nonatomic,strong) UILabel *pStatusStr;

@end
