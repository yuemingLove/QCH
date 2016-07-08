//
//  ProjectCell.h
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Project2Cell;

@protocol Project2CellDelegate <NSObject>

-(void)delCareProject:(Project2Cell*)cell index:(NSInteger)index;

-(void)addCareProject:(Project2Cell*)cell index:(NSInteger)index;

@end

@interface Project2Cell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;
@property (nonatomic,weak) IBOutlet UIButton *careButton;

@property (nonatomic,weak) IBOutlet UILabel *themeLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *projectLabel;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;

@property (nonatomic,weak) IBOutlet UILabel *label;

@property (nonatomic,weak) IBOutlet UIButton *delBtn;
@property (nonatomic,weak) IBOutlet UIButton *goodBtn;


@property (nonatomic,assign) id<Project2CellDelegate> projectDelegate;

-(void)updateFrame:(NSDictionary*)dict;

@end
