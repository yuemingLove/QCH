//
//  ProjectCell.h
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectCell;

@protocol ProjectCellDelegate <NSObject>

-(void)updateCareBtn:(ProjectCell*)cell;

@end

@interface ProjectCell : SWTableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;
@property (nonatomic,weak) IBOutlet UIImageView *statesImageView;

@property (nonatomic,weak) IBOutlet UIImageView *signImageView;

@property (nonatomic,weak) IBOutlet UIButton *careButton;

@property (nonatomic,weak) IBOutlet UILabel *themeLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *projectLabel;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;

@property (nonatomic,weak) IBOutlet UILabel *label;

@property (nonatomic,assign) id<ProjectCellDelegate> projectDelegate;

-(void)updateFrame:(NSDictionary*)dict;

@end
