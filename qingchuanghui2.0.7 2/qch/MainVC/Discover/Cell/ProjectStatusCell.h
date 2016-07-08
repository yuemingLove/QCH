//
//  ProjectStatusCell.h
//  qch
//
//  Created by 苏宾 on 16/2/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectStatusCell;

@protocol  ProjectStatusCellDelegate<NSObject>

-(void)setUserStyle:(ProjectStatusCell*)cell;

@end


@interface ProjectStatusCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *rongziLabel;
@property (nonatomic,weak) IBOutlet UILabel *rzPriceLabel;
@property (nonatomic,weak) IBOutlet UILabel *rzUseLabel;

@property (nonatomic,weak) IBOutlet UIButton *VCBtn;

@property (nonatomic,assign) id<ProjectStatusCellDelegate>projectDelegate;

@end
