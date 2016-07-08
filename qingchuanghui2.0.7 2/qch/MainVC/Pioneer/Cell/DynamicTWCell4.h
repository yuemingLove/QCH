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
@class DynamicTWCell4;

@protocol DynamicTWCell4Deleagte <NSObject>

- (void)tapImageWithObject4:(DynamicTWCell4 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index;
- (void)talkClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index;
- (void)shareClicked4:(DynamicTWCell4 *)cell index:(NSInteger)index;
- (void)tapImg4:(DynamicTWCell4 *)cell tap:(UITapGestureRecognizer *)tap;

@end

@interface DynamicTWCell4 : UITableViewCell



@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (nonatomic,weak) IBOutlet HTCopyableLabel *contentLabel;
@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;


@property (nonatomic,weak) id<DynamicTWCell4Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;
@end
