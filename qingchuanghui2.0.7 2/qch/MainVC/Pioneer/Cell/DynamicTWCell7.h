//
//  DynamicTWCell.h
//  qch
//
//  Created by 青创汇 on 16/1/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@class DynamicTWCell7;

@protocol DynamicTWCell7Deleagte <NSObject>

- (void)tapImageWithObject7:(DynamicTWCell7 *)cell tap:(UITapGestureRecognizer *)tap;
- (void)careClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index;
- (void)talkClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index;
- (void)shareClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index;
- (void)deleteClicked7:(DynamicTWCell7 *)cell index:(NSInteger)index;


- (void)tapImg7:(DynamicTWCell7 *)cell tap:(UITapGestureRecognizer *)tap;


@end

@interface DynamicTWCell7 : UITableViewCell



@property (nonatomic,weak) IBOutlet UIImageView *headImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *positionLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UIView *bgkView;

@property (nonatomic,strong)UIButton *chatbtn;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *MoreBtn;
@property (nonatomic,strong)UIButton *DeleteBtn;



@property (nonatomic,weak) id<DynamicTWCell7Deleagte> dyDelegate;

@property (nonatomic,strong) NSMutableArray *imageViews;

-(void)updateData:(DynamicModel*)model;

@end
