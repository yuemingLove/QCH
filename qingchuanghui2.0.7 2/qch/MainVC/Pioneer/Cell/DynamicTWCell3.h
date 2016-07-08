//
//  DynamicTWCell.h
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@class DynamicTWCell3;

@protocol DynamicCell3Deleagte <NSObject>

- (void)tapImageWithObject3:(DynamicTWCell3 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index;
- (void)talkClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index;
- (void)shareClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index;
- (void)deleteClicked3:(DynamicTWCell3 *)cell index:(NSInteger)index;


- (void)tapImg3:(DynamicTWCell3 *)cell tap:(UITapGestureRecognizer *)tap;


@end

@interface DynamicTWCell3 : UITableViewCell



@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *MoreBtn;
@property (nonatomic,strong)UIButton *DeleteBtn;



@property (nonatomic,weak) id<DynamicCell3Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;

@end
