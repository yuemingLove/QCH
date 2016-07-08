//
//  DynamicTWCell.h
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@class DynamicTWCell5;

@protocol DynamicTWCell5Deleagte <NSObject>

- (void)tapImageWithObject5:(DynamicTWCell5 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index;
- (void)talkClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index;
- (void)shareClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index;
- (void)deleteClicked5:(DynamicTWCell5 *)cell index:(NSInteger)index;


- (void)tapImg5:(DynamicTWCell5 *)cell tap:(UITapGestureRecognizer *)tap;


@end

@interface DynamicTWCell5 : UITableViewCell



@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UIView *bgkView;

@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *MoreBtn;
@property (nonatomic,strong)UIButton *DeleteBtn;



@property (nonatomic,weak) id<DynamicTWCell5Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;

@end