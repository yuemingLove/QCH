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
@class DynamicTWCell8;

@protocol DynamicTWCell8Deleagte <NSObject>

- (void)tapImageWithObject8:(DynamicTWCell8 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index;
- (void)talkClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index;
- (void)shareClicked8:(DynamicTWCell8 *)cell index:(NSInteger)index;
- (void)tapImg8:(DynamicTWCell8 *)cell tap:(UITapGestureRecognizer *)tap;

@end

@interface DynamicTWCell8 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tapimg;

@property (weak, nonatomic) IBOutlet UIView *bgkView;
@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (strong, nonatomic) HTCopyableLabel *contentLabel;
@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;


@property (nonatomic,weak) id<DynamicTWCell8Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;
@end
