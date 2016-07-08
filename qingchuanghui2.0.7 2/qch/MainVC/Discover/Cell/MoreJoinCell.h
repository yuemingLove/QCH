//
//  MoreJoinCell.h
//  qch
//
//  Created by 苏宾 on 16/2/1.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreJoinCell;

@protocol MoreJoinCellDelegate <NSObject>

-(void)selectImageView:(MoreJoinCell*)cell index:(NSInteger)index;

@end

@interface MoreJoinCell : UITableViewCell

@property (nonatomic,assign) id<MoreJoinCellDelegate> joinDelegate;

@property (nonatomic,weak) IBOutlet UILabel *label2;
@property (nonatomic,weak) IBOutlet UILabel *numLabel;

@property (nonatomic,strong) UIButton *MoreBtn;
@property (nonatomic,strong) UILabel *line;

-(void)updateFrame:(NSMutableArray*)usePicArray;

@end
