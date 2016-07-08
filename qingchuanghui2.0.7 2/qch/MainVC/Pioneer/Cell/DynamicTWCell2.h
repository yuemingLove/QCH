//
//  DynamicTWCell.h
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"
#import "HTCopyableLabel.h"
@class DynamicTWCell2;

@protocol DynamicTWCell2Deleagte <NSObject>

- (void)tapImageWithObject:(DynamicTWCell2 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked:(DynamicTWCell2 *)cell index:(NSInteger)index;
- (void)talkClicked:(DynamicTWCell2 *)cell index:(NSInteger)index;
- (void)shareClicked:(DynamicTWCell2 *)cell index:(NSInteger)index;
- (void)tapImg:(DynamicTWCell2 *)cell tap:(UITapGestureRecognizer *)tap;

@end

@interface DynamicTWCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tapimg;

@property (weak, nonatomic) IBOutlet UIView *bgkView;
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UILabel *needsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (strong, nonatomic) HTCopyableLabel *contentLabel;
@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;


@property (nonatomic,weak) id<DynamicTWCell2Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;
@end
